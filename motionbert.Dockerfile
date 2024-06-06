FROM ubuntu:22.04

# install utils
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    unzip \
    git && \
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

# MotionBERT setup
# see https://github.com/Walter0807/MotionBERT?tab=readme-ov-file#installation
RUN conda create -n alphapose python=3.9 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "alphapose", "/bin/bash", "-c"]
## clone repo
COPY ./MotionBERT-main.zip ./MotionBERT.zip
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
RUN unzip ./MotionBERT.zip -d . && \
    mv MotionBERT-main/ MotionBERT/ && \
    rm -f MotionBERT.zip && \
    cd MotionBERT && \
    pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]
