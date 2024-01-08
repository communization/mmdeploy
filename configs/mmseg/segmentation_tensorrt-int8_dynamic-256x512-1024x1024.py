_base_ = ['./segmentation_dynamic.py', '../_base_/backends/tensorrt-int8.py']
backend_config = dict(
    common_config=dict(max_workspace_size=1 << 30),
    model_inputs=[
        dict(
            input_shapes=dict(
                input=dict(
                    min_shape=[1, 3, 256, 512],
                    opt_shape=[1, 3, 540, 960], #height, width
                    max_shape=[1, 3, 1024, 1024])))
    ])
 