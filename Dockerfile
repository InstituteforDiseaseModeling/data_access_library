# Start with Ubuntu base image and setup python and R
FROM rocker/rstudio:latest


# Set environment variables to ensure non-interactive installations
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    libssl-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libjpeg-dev \
    libpng-dev \
    libxt-dev \
    gdebi-core \
    software-properties-common \
    && apt-get clean

# Install Python 3.12.5
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    && apt-get clean

# Set up Python virtual environment
# Install Jupyter, Quarto, and ipykernel
RUN python3.12 -m ensurepip --upgrade
RUN python3.12 -m pip --version
RUN python3.12 -m pip install jupyterlab jupyterlab-quarto jupyter_contrib_nbextensions quarto-cli ipykernel ipython

RUN python3.12 -m venv /opt/venv --system-site-packages

ENV PATH="/opt/venv/bin:$PATH"

# Create an IPython kernel for the virtual environment
RUN /opt/venv/bin/python -m ipykernel install --user --name=venv --display-name "Python 3.12 (venv)"

# Expose ports for RStudio (8787) and Jupyter (8888)

#WORKDIR /workspaces

EXPOSE 8787
EXPOSE 8888

# CMD to start both Jupyter and RStudio
#CMD ["bash", "-c", "rstudio-server start; jupyter lab --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token=''"]
