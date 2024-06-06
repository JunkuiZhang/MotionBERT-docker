# https://github.com/pytorch/pytorch/blob/main/Dockerfile
FROM ubuntu:22.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    unzip \
    libyaml-dev && \
    rm -rf /var/lib/apt/lists/*
# RUN /usr/sbin/update-ccache-symlinks
# RUN mkdir /opt/ccache && ccache --set-config=cache_dir=/opt/ccache
ENV PATH="/opt/conda/bin:${PATH}"

WORKDIR /root/

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir /root/.conda && \
    chmod +x ~/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

RUN conda init bash &&\
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# RUN conda init bash

# AlphaPose
RUN conda create -n alphapose python=3.8 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "alphapose", "/bin/bash", "-c"]
## install Pytorch, see https://pytorch.org/
## clone repo
COPY ./AlphaPose-master.zip ./AlphaPose.zip
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
# RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN unzip ./AlphaPose.zip -d . &&\
    mv AlphaPose-master/ AlphaPose/ &&\
    cd AlphaPose &&\
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
