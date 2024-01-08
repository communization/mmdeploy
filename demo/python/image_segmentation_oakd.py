import depthai as dai
import cv2
import time
import argparse
import numpy as np
from mmdeploy_runtime import Segmentor

def parse_args():
    parser = argparse.ArgumentParser(
        description='show how to use sdk python api')
    parser.add_argument('--device_name', default='cuda' ,help='name of device, cuda or cpu')
    parser.add_argument(
        '--model_path', default='/root/workspace/mmdeploy/mmdeploy_models/mmseg/ort2',
        help='path of mmdeploy SDK model dumped by model converter')
    parser.add_argument('--image_path', default='/root/workspace/mmdeploy/demo/resources/cityscapes.png',
                        help='path of an image')
    args = parser.parse_args()
    return args


def get_palette(num_classes=3):
    state = np.random.get_state()
    # random color
    np.random.seed(42)
    palette = np.random.randint(0, 256, size=(num_classes, 3))
    np.random.set_state(state)
    return [tuple(c) for c in palette]

def get_mask(args, img):
    segmentor = Segmentor(
        model_path=args.model_path, device_name=args.device_name, device_id=0)
    
    a= time.time()
    seg = segmentor(img)
    if seg.dtype == np.float32:
        seg = np.argmax(seg, axis=0)
    if False:
        palette = get_palette()
        color_seg = np.zeros((seg.shape[0], seg.shape[1], 3), dtype=np.uint8)
        for label, color in enumerate(palette):
            color_seg[seg == label, :] = color

        # convert to BGR
        color_seg = color_seg[..., ::-1]
        img = img * 0.5 + color_seg * 0.5
    if True:
        print("seg.unique: ",np.unique(seg))
        grey_seg = np.stack([seg]*3,axis=2)*120
        img = img+grey_seg
    img = img.astype(np.uint8)
    return img

pipeline = dai.Pipeline()

camRgb = pipeline.createColorCamera()
camRgb.setResolution(dai.ColorCameraProperties.SensorResolution.THE_1080_P)
camRgb.setInterleaved(False)
camRgb.setFps(fps=30)

rgbout = pipeline.createXLinkOut()
rgbout.setStreamName("RGB")
camRgb.video.link(rgbout.input)

args = parse_args()

with dai.Device(pipeline) as device:
    device.startPipeline()
    qRgb = device.getOutputQueue(name="RGB", maxSize=4, blocking=False)

    frame_count = 0
    start_time = time.time()

    while True:
        inRgb = qRgb.get()  # blocking call, will wait until a new data has arrived
        frame_count += 1

        # Calculate FPS
        current_time = time.time()
        elapsed_time = current_time - start_time
        if elapsed_time > 0:
            fps = frame_count / elapsed_time

        # Display FPS on frame
        frame = inRgb.getCvFrame()
        frame = cv2.resize(frame,(1024,512))
        frame = get_mask(args, frame)
        cv2.putText(
            frame,
            f"FPS: {fps:.2f}",
            (10, 30),
            cv2.FONT_HERSHEY_SIMPLEX,
            1,
            (0, 255, 0),
            2,
        )
        cv2.imshow("bgr", frame)

        if cv2.waitKey(1) == ord("q"):
            break
