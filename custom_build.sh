#https://github.com/open-mmlab/mmdeploy/blob/main/docs/en/01-how-to-build/build_from_docker.md
export MMDEPLOY_VERSION=main
export TAG=mmdeploy-${MMDEPLOY_VERSION}

docker build -t ${TAG} --build-arg MMDEPLOY_VERSION=${MMDEPLOY_VERSION} ./docker/Release/

sudo docker run -it --network host --gpus all --ipc=host --privileged \
    -e DISPLAY=$DISPLAY -v $(pwd):/root/workspace/mmdeploy -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /media/lee/90182A121829F83C1/Dataset:/Dataset \
    -v=/dev:/dev \
    --name mmdeploy ${TAG}

# sudo docker run -it --network host --gpus all --ipc=host --privileged \
#     -e DISPLAY=$DISPLAY -v $(pwd):/root/workspace/mmdeploy -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -v /media/lee/90182A121829F83C2/Dataset:/Dataset \
#     -v=/dev:/dev \
#     --name mmdeploy_used2 mmdeploy_used2