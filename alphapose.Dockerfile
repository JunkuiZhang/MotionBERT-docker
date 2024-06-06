FROM nvidia/cuda:12.5.0-runtime-ubuntu22.04

# install utils
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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
RUN conda create -n alphapose python=3.7 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "alphapose", "/bin/bash", "-c"]
## clone repo
COPY ./AlphaPose-master.zip ./AlphaPose.zip
RUN conda install pytorch torchvision torchaudio pytorch-cuda=11.3 -c pytorch -c nvidia
RUN unzip ./AlphaPose.zip -d . && \
    mv AlphaPose-master/ AlphaPose/ && \
    rm -f AlphaPose.zip && \
    cd AlphaPose && \
    python -m pip install cython && \
    python setup.py build develop

ENTRYPOINT ["/bin/bash"]
