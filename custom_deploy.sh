export PYTHONPATH="/root/workspace/mmsegmentation:$PYTHONPATH"

python3 tools/deploy.py \
    configs/mmseg/segmentation_tensorrt-int8_dynamic-256x512-1024x1024.py \
    ../mmsegmentation/configs/custom/deeplabv3plus_r50_DLoop.py \
    ../mmsegmentation/work_dirs/deeplabv3plus_r50_DLoop/iter_2000.pth \
    demo/resources/cityscapes.png \
    --work-dir mmdeploy_models/mmseg/DLoop_ort \
    --device cuda \
    --show \
    --dump-info
    
    
#../mmsegmentation/work_dirs/iter_2000.pth \
#configs/mmseg/segmentation_onnxruntime_dynamic.py \

#/root/workspace/mmsegmentation/work_dirs/deeplabv3plus_r50_DLoop/iter_2000.pth \


# python3 tools/deploy.py \
#     configs/mmseg/segmentation_tensorrt-int8_dynamic-512x1024-2048x2048.py \
#     ../mmsegmentation/configs/custom/deeplabv3plus_r50_DLoop.py \
#     ../mmsegmentation/work_dirs/deeplabv3plus_r50_DLoop/iter_2000.pth \
#     demo/resources/cityscapes.png \
#     --work-dir mmdeploy_models/mmseg/DLoop_ort \
#     --device cuda \
#     --show \
#     --dump-info