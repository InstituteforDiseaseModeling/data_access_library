#!/bin/bash

# Install ZeroMQ
sudo apt-get update -y
sudo apt-get install libzmq3-dev -y

# Install ffmpeg
sudo apt-get install ffmpeg -y

# Setup bash to allow conda to run
#conda init bash && conda install -y ipykernel

# Allow JupyterLab and IRkernel ro run R workbook
R -e "install.packages('IRkernel')"
R -e "IRkernel::installspec()"
