# Start with Ubuntu base image and setup python and R
FROM ubuntu:22.04

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
RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install R and RStudio Server
RUN apt-get update && apt-get install -y \
    r-base-core \
    && wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.04.2-764-amd64.deb \
    && gdebi rstudio-server-2024.04.2-764-amd64.deb \
    && rm rstudio-server-2024.04.2-764-amd64.deb \
    && apt-get clean

# Install Jupyter, Quarto, and ipykernel
RUN /opt/venv/bin/pip install jupyterlab quarto-cli ipykernel

# Create an IPython kernel for the virtual environment
RUN /opt/venv/bin/python -m ipykernel install --user --name=venv --display-name "Python 3.12 (venv)"

# Set work directory
WORKDIR /workspace

# Expose ports for RStudio (8787) and Jupyter (8888)
EXPOSE 8787
EXPOSE 8888

# CMD to start both Jupyter and RStudio
CMD ["bash", "-c", "rstudio-server start; jupyter lab --ip=0.0.0.0 --no-browser --allow-root"]

# Create the vscode user and group
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode -m vscode \
    && apt-get update \
    && apt-get install -y sudo \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER vscode
