FROM nvidia/cuda:12.5.0-runtime-ubuntu22.04
# FROM nvidia/cuda:12.5.0-devel-ubuntu22.04

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
RUN conda create -n alphapose python=3.7 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "alphapose", "/bin/bash", "-c"]
## install Pytorch
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
## clone repo
RUN git clone https://github.com/MVIG-SJTU/AlphaPose.git &&\
    cd AlphaPose &&\
    python -m pip install cython &&\
    apt-get install libyaml-dev &&\
    python setup.py build develop

# MotionBERT
RUN conda create -n motionbert python=3.7 -y
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "motionbert", "/bin/bash", "-c"]
## install pytorch
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia &&\
    pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]
