#!/bin/bash

# Install ZeroMQ
sudo apt-get update -y
sudo apt-get install libzmq3-dev -y

# Install shared library (libpython3.x.so for reticulate)
sudo apt-get install python3-dev
# Install GDAL
sudo apt-get install gdal-bin libgdal-dev -y

# Install a few common dependencies
sudo apt-get install libharfbuzz-dev libfribidi-dev libfreetype6-dev pkg-config libarchive-dev -y
# Install ffmpeg
sudo apt-get install ffmpeg -y

# Setup bash to allow conda to run
#conda init bash && conda install -y ipykernel

# Allow JupyterLab and IRkernel ro run R workbook
R -e "install.packages('IRkernel')"
R -e "IRkernel::installspec()"

# change the default working directory for RStudio
echo "session-default-working-dir=/workspaces/data_access_library/" | sudo tee -a /etc/rstudio/rsession.conf
echo "copilot-enabled=1" | sudo tee -a /etc/rstudio/rsession.conf
