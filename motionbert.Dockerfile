FROM ubuntu:22.04

# install utils
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
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
RUN conda create -n motionbert python=3.8 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "motionbert", "/bin/bash", "-c"]
## clone repo
COPY ./MotionBERT-main.zip ./MotionBERT.zip
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
RUN unzip ./MotionBERT.zip -d . && \
    mv MotionBERT-main/ MotionBERT/ && \
    rm -f MotionBERT.zip

WORKDIR /root/MotionBERT/

RUN pip install -r requirements.txt

# cv2 dep
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/MotionBERT/checkpoint/pose3d/FT_MB_lite_MB_ft_h36m_global_lite/ && \
    mkdir -p checkpoint/mesh/FT_MB_release_MB_ft_pw3d/
COPY motionbert-data/3dpose_best_epoch.bin /root/MotionBERT/checkpoint/pose3d/FT_MB_lite_MB_ft_h36m_global_lite/best_epoch.bin
COPY motionbert-data/mesh_best_epoch.bin /root/MotionBERT/checkpoint/mesh/FT_MB_release_MB_ft_pw3d/best_epoch.bin

# fix numpy
RUN pip uninstall numpy -y && \
    pip install numpy==1.23.1

ENTRYPOINT ["/bin/bash"]
