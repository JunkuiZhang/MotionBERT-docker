# FROM Ubuntu:22.04
FROM nvidia/cuda:12.5.0-devel-ubuntu22.04

WORKDIR /root/

COPY conda.sh conda.sh

# install miniconda
RUN chmod +x /root/conda.sh &&\
    /root/conda.sh -b -p /opt/miniconda &&\
    rm /root/conda.sh &&\
    /opt/miniconda/bin/conda init bash &&\
    /opt/miniconda/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# set env
ENV PATH=/opt/miniconda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# AlphaPose

# MotionBERT
RUN conda create -n motionbert python=3.7 anaconda

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "motionbert", "/bin/bash", "-c"]
# RUN /opt/miniconda/bin/conda create -n motionbert python=3.7 anaconda &&\
#     /opt/miniconda/bin/conda activate motionbert &&\
#     # Please install PyTorch according to your CUDA version.
#     /opt/miniconda/bin/conda install pytorch torchvision torchaudio pytorch-cuda=12.0 -c pytorch -c nvidia &&\
#     /opt/miniconda/bin/pip install -r requirements.txt
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia &&\
    pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]
