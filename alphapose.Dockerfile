FROM nvidia/cuda:12.5.0-devel-ubuntu22.04

# install utils
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    ninja-build \
    ca-certificates \
    wget \
    unzip \
    libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

# set env
ENV PATH="/opt/conda/bin:${PATH}"

WORKDIR /root/

# install conda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir /root/.conda && \
    chmod +x ~/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

RUN conda init bash &&\
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# AlphaPose setup
# see https://github.com/MVIG-SJTU/AlphaPose/blob/master/docs/INSTALL.md
# https://github.com/MVIG-SJTU/AlphaPose/issues/1188
RUN conda create -n alphapose python=3.7 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "alphapose", "/bin/bash", "-c"]
## clone repo
COPY ./AlphaPose-master.zip ./AlphaPose.zip

RUN conda install -c "nvidia/label/cuda-11.3.1" cuda-toolkit -y
RUN conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch
RUN pip install -U pip setuptools && \
    pip install cython==0.27.3
# fix gcc issue
# see https://github.com/MVIG-SJTU/AlphaPose/issues/1157#issuecomment-1734703528
RUN apt-get update && apt-get install -y --no-install-recommends gcc-9 g++-9 git && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --set gcc /usr/bin/gcc-9 &&\
    update-alternatives --set g++ /usr/bin/g++-9

RUN pip install easydict halpecocotools munkres natsort opencv-python pyyaml scipy tensorboardx terminaltables timm==0.1.20 tqdm visdom jinja2 typeguard

# fix "RPC failed; curl 16 Error in the HTTP2 framing layer"
# RUN git config --global http.version HTTP/1.1

RUN unzip ./AlphaPose.zip -d . && \
    mv AlphaPose-master/ AlphaPose/ && \
    rm -f AlphaPose.zip && \
    cd AlphaPose && \
    # fix "RPC failed; curl 16 Error in the HTTP2 framing layer"
    git config --global http.version HTTP/1.1

WORKDIR /root/AlphaPose/

ENTRYPOINT ["/bin/bash"]
