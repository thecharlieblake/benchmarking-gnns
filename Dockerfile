# this docker file evolved from https://github.com/ShangtongZhang/DeepRL/blob/master/Dockerfile
# and updated to ubuntu18.04 hereafter

FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# CUDA includes
ENV CUDA_PATH /usr/local/cuda
ENV CUDA_INCLUDE_PATH /usr/local/cuda/include
ENV CUDA_LIBRARY_PATH /usr/local/cuda/lib64

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

# to avoid dialogues for tzada install
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt update && apt install -y --allow-unauthenticated --no-install-recommends \
    build-essential apt-utils cmake git curl vim ca-certificates \
    libjpeg-dev libpng-dev python3.6 python3-pip python3-setuptools \
    libgtk3.0 libsm6 python3-venv cmake ffmpeg pkg-config \
    qtbase5-dev libqt5opengl5-dev libassimp-dev libpython3.6-dev \
    libboost-python-dev libtinyxml-dev bash python3-tk \
    wget unzip libosmesa6-dev software-properties-common \
    libopenmpi-dev libglew-dev graphviz graphviz-dev patchelf

RUN pip3 install pip --upgrade

#RUN add-apt-repository ppa:jamesh/snap-support && apt-get update && apt install -y patchelf
RUN rm -rf /var/lib/apt/lists/*

# For some reason, I have to use a different account from the default one.
# This is absolutely optional and not recommended. You can remove them safely.
# But be sure to make corresponding changes to all the scripts.

WORKDIR /ms19cb
RUN chmod -R 777 /ms19cb
RUN chmod -R 777 /usr/local

ARG uid
ARG user
ARG cuda
RUN useradd -d /ms19cb -u $uid $user

RUN pip3 install wheel
RUN pip3 install --upgrade pip
RUN pip3 install pymongo
RUN pip3 install numpy scipy pyyaml matplotlib ruamel.yaml networkx tensorboardX pygraphviz
RUN pip3 install torch==1.4.0 torchvision -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install torch-scatter==latest+$cuda torch-sparse==latest+$cuda -f https://pytorch-geometric.com/whl/torch-1.4.0.html
RUN pip3 install torch-geometric
RUN pip3 install gym
RUN pip3 install gym[atari]
RUN pip3 install pybullet cffi
RUN pip3 install seaborn
RUN pip3 install git+https://github.com/yobibyte/pgn.git
RUN pip3 install tensorflow
RUN pip3 install git+git://github.com/openai/baselines.git

RUN pip3 install six beautifulsoup4 termcolor num2words
RUN pip3 install lxml tabulate coolname lockfile glfw
RUN pip3 install Cython
RUN pip3 install sacred

USER $user
RUN mkdir -p /ms19cb/.mujoco \
    && wget https://www.roboti.us/download/mjpro150_linux.zip -O mujoco.zip \
    && unzip mujoco.zip -d /ms19cb/.mujoco \
    && rm mujoco.zip
RUN wget https://www.roboti.us/download/mujoco200_linux.zip -O mujoco.zip \
    && unzip mujoco.zip -d /ms19cb/.mujoco \
    && rm mujoco.zip
COPY ./mjkey.txt /ms19cb/.mujoco/mjkey.txt
ENV LD_LIBRARY_PATH /ms19cb/.mujoco/mjpro150/bin:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH /ms19cb/.mujoco/mjpro200_linux/bin:${LD_LIBRARY_PATH}
RUN pip3 install mujoco-py==1.50.1.68

WORKDIR /ms19cb/gnn-freeze
ENV PYTHONPATH /ms19cb/gnn-freeze:${PYTHONPATH}
# WTF cpu version of tf wants to use my cuda. WHY?
#ENV LD_LIBRARY_PATH /usr/local/cuda/compat:${LD_LIBRARY_PATH}
