#image 
#https://gitlab.com/nvidia/container-images/l4t-jetpack
#https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base


#https://github.com/open-mmlab/mmdeploy/blob/main/docs/en/01-how-to-build/build_from_docker.md

# sudo docker run -it --network host --ipc=host --privileged \
#     -e DISPLAY=$DISPLAY -v $(pwd):/root/workspace/mmdeploy -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -v=/dev:/dev --runtime nvidia\
#     --name mmdeploy nvcr.io/nvidia/l4t-jetpack:r35.1.0

sudo docker run -it --network host --ipc=host --privileged \
    -e DISPLAY=$DISPLAY -v $(pwd):/root/workspace/mmdeploy -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v=/dev:/dev --runtime nvidia\
    --name mmdeploy nvcr.io/nvidia/l4t-tensorrt:r8.5.2.2-devel


# sudo docker run -it --network host --ipc=host --privileged \
#     -e DISPLAY=$DISPLAY -v $(pwd):/root/workspace/mmdeploy -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -v=/dev:/dev --runtime nvidia\
#     --name mmdeploy_used mmdeploy_used
    
#python -c "import tensorrt; print(tensorrt.__version__)"
# sudo docker run -it --network host --gpus all --ipc=host --privileged \
#     -e DISPLAY=$DISPLAY -v $(pwd):/root/workspace/mmdeploy -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -v /media/lee/90182A121829F83C2/Dataset:/Dataset \
#     -v=/dev:/dev \
#     --name mmdeploy_used2 mmdeploy_used2



# sudo docker run -it --network host --ipc=host --privileged \
#     -e DISPLAY=$DISPLAY -v $(pwd):/root/workspace/mmdeploy -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -v=/dev:/dev --runtime nvidia\
#     --name mmdeploy nvcr.io/nvidia/l4t-tensorrt:r8.4.1-runtime