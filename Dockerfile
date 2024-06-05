# FROM nvidia/cuda:12.5.0-runtime-ubuntu22.04
# FROM nvidia/cuda:12.5.0-devel-ubuntu22.04
FROM ubuntu:22.04

WORKDIR /root/

# install cuda toolkit
RUN apt-get update &&\
    apt-get install -y wget build-essential &&\
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb &&\
    dpkg -i cuda-keyring_1.1-1_all.deb &&\
    apt-get update &&\
    apt-get -y install cuda-toolkit-12-5

# install miniconda
COPY conda.sh conda.sh

RUN chmod +x /root/conda.sh &&\
    /root/conda.sh -b -p /opt/miniconda &&\
    rm /root/conda.sh &&\
    /opt/miniconda/bin/conda init bash &&\
    /opt/miniconda/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# set env
ENV PATH=/usr/local/cuda/bin:/opt/miniconda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64

RUN apt-get update &&\
    apt-get install -y libyaml-dev unzip

# AlphaPose
RUN conda create -n alphapose python=3.7 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "alphapose", "/bin/bash", "-c"]
## install Pytorch
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia
## clone repo
COPY ./AlphaPose-master.zip ./AlphaPose.zip
RUN apt-get install -y ninja-build
RUN unzip ./AlphaPose.zip -d . &&\
    mv AlphaPose-master/ AlphaPose/ &&\
    cd AlphaPose &&\
    # pip install cython tqdm natsort detector
    # pip install cython
    python -m pip install cython
# python setup.py build develop

# MotionBERT
# RUN conda create -n motionbert python=3.7 -y
# Make RUN commands use the new environment:
# SHELL ["conda", "run", "-n", "motionbert", "/bin/bash", "-c"]
## install pytorch
# RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia &&\
# pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]
