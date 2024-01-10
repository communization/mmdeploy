#https://mmdeploy.readthedocs.io/en/latest/01-how-to-build/jetsons.html?highlight=jetson
apt update
apt install sudo    
sudo apt-get -y update
sudo apt-get install -y python3-pip
python3 -m pip install -U pip
apt install -y wget

##install pytorch 1.13.0
#https://forums.developer.nvidia.com/t/pytorch-for-jetson/72048
#wget https://nvidia.box.com/shared/static/fjtbno0vpo676a25cgvuqc1wty0fkkg6.whl -O torch-1.10.0-cp36-cp36m-linux_aarch64.whl

cd /
wget https://developer.download.nvidia.com/compute/redist/jp/v502/pytorch/torch-1.13.0a0+d0d6b1f2.nv22.10-cp38-cp38-linux_aarch64.whl \
    #-o torch-1.13.0a0+d0d6b1f2.nv22.10-cp38-cp38-linux_aarch64.whl
pip3 install torch-1.13.0a0+d0d6b1f2.nv22.10-cp38-cp38-linux_aarch64.whl


##torchvision 0.14.0 long time
cd /
sudo apt-get install libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev libopenblas-base libopenmpi-dev  libopenblas-dev -y
apt install -y git 
git clone --branch v0.14.0 https://github.com/pytorch/vision torchvision
cd torchvision
export BUILD_VERSION=0.14.0
pip install -e .

##CMake
cd /
sudo apt-get purge cmake -y
# install prebuilt binary
export CMAKE_VER=3.23.1
export ARCH=aarch64
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}-linux-${ARCH}.sh
chmod +x cmake-${CMAKE_VER}-linux-${ARCH}.sh
sudo ./cmake-${CMAKE_VER}-linux-${ARCH}.sh --prefix=/usr --skip-license
cmake --version


#TensorRT
export TENSORRT_DIR=/usr/include/aarch64-linux-gnu
export PATH=$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
echo -e '\n# set environment variable for TensorRT' >> ~/.bashrc
echo 'export TENSORRT_DIR=/usr/include/aarch64-linux-gnu' >> ~/.bashrc
echo -e '\n# set environment variable for CUDA' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/cuda/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64' >> ~/.bashrc
source ~/.bashrc

#libopencv
sudo apt-get -y install libopencv-dev

#MMCV 1 hour 40 m
cd /
sudo apt-get install -y libssl-dev
git clone --branch 2.x https://github.com/open-mmlab/mmcv.git
cd mmcv
MMCV_WITH_OPS=1 pip install -e .
pip install protobuf==3.20.2
pip install uff==0.6.9


# Execute one of the following comands
pip install onnx==1.13.1

#if error
sudo apt-get install -y protobuf-compiler libprotoc-dev


# Download pip wheel from location mentioned above
cd /
wget https://nvidia.box.com/shared/static/mvdcltm9ewdy2d5nurkiqorofz1s53ww.whl -O onnxruntime_gpu-1.15.1-cp38-cp38-linux_aarch64.whl
pip3 install /root/workspace/mmdeploy/onnxruntime_gpu-1.15.1-cp38-cp38-linux_aarch64.whl
pip install protobuf==3.20.2

#h5py and pycuda
sudo apt-get install -y pkg-config libhdf5-103 libhdf5-dev
pip install versioned-hdf5 pycuda

#C/C++ inference
sudo apt-get install -y libspdlog-dev

#install ppl.cv
cd /
git clone https://github.com/openppl-public/ppl.cv.git
cd ppl.cv
export PPLCV_DIR=$(pwd)
echo -e '\n# set environment variable for ppl.cv' >> ~/.bashrc
echo "export PPLCV_DIR=$(pwd)" >> ~/.bashrc
./build.sh cuda

#====================================================================================================
#build TensorRT custom operators
cd /root/workspace/mmdeploy
mkdir -p build && cd build
cmake .. -DMMDEPLOY_TARGET_BACKENDS="trt"
make -j$(nproc) && make install

#install mmdeploy
#git clone -b main --recursive https://github.com/open-mmlab/mmdeploy.git
cd /root/workspace/mmdeploy
export MMDEPLOY_DIR=$(pwd)

#install model converter
cd ${MMDEPLOY_DIR}
pip install -v -e .

#install C/C++ Inference SDK
mkdir -p build && cd build
cmake .. \
    -DMMDEPLOY_BUILD_SDK=ON \
    -DMMDEPLOY_BUILD_SDK_PYTHON_API=ON \
    -DMMDEPLOY_BUILD_EXAMPLES=ON \
    -DMMDEPLOY_TARGET_DEVICES="cuda;cpu" \
    -DMMDEPLOY_TARGET_BACKENDS="trt" \
    -DMMDEPLOY_CODEBASES=all \
    -Dpplcv_DIR=${PPLCV_DIR}/cuda-build/install/lib/cmake/ppl
make -j$(nproc) && make install

#mmseg
pip install -U openmim
mim install mmengine
mim install "mmcv>=2.0.0rc2"


#mmsegmentation
cd /root/workspace
git clone https://github.com/communization/mmsegmentation.git
cd mmsegmentation
pip install -r requirements.txt

#oakd depthai
sudo wget -qO- https://docs.luxonis.com/install_dependencies.sh | bash

#for runtime
export PYTHONPATH=/root/workspace/mmsegmentation:/root/workspace/mmdeploy/tools/package_tools/packaging/mmdeploy_runtime:/root/workspace/mmdeploy/build/lib
echo 'export PYTHONPATH=/root/workspace/mmsegmentation:/root/workspace/mmdeploy/tools/package_tools/packaging/mmdeploy_runtime:/root/workspace/mmdeploy/build/lib' >> ~/.bashrc 










# sudo apt-get -y python3-pip libopenblas-dev
    
# version=`python3 -c "import torch; print(torch.__version__)"`
# if [ -n "$version" ];then
#     return 0
# fi
# TORCH_WHL="torch-1.11.0-cp38-cp38-linux_aarch64.whl"
# if [ ! -e "${TORCH_WHL}" ];then
#     wget -q --show-progress https://nvidia.box.com/shared/static/ssf2v7pf5i245fk4i0q926hy4imzs2ph.whl -O ${TORCH_WHL}
# fi
# python3 -m pip install ${TORCH_WHL}
# python3 -m pip install numpy
# sudo apt install libopenblas-dev -y
# python3 -c "import torch; print(torch.__version__)"