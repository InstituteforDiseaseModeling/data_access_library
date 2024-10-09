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
    libtiff5-dev \
    libproj-dev \
    libgdal-dev \
    libxt-dev \
    libarchive-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxrandr2 \
    libxss1 \
    libxcursor1 \
    libxcomposite1 \
    libasound2 \
    libxi6 \
    libxtst6 \
    gdebi-core \
    software-properties-common \
    ffmpeg \
    expect \
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

# Install latest Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb
RUN dpkg -i quarto-1.5.57-linux-amd64.deb

# Install Anaconda
# Set environment variable for non-interactive Anaconda install
ENV PATH /opt/conda/bin:$PATH

# Download and install Anaconda
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    /opt/conda/bin/conda clean -i -t -p -y

# Update conda to the latest version
RUN conda update -n base -c defaults conda

# Set the default shell to bash and activate Conda environment
SHELL ["/bin/bash", "-c"]

# Ensure conda is activated on startup
RUN echo "source /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

WORKDIR /app

COPY r /app/r
COPY python /app/python

# Expose ports for RStudio (8787) and Jupyter (8888)
EXPOSE 8787
EXPOSE 8888

# Install essentials globally for all users
RUN R -e "install.packages('renv', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('knitr', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('rmarkdown', repos='https://cran.rstudio.com/')"
RUN R -e ".libPaths()"

# Add /usr/local/bin to the PATH for all users
ENV PATH="/usr/local/bin:$PATH"

# Ensure the rstudio user's profile contains the updated PATH
RUN echo 'export PATH="/usr/local/bin:$PATH"' >> /home/rstudio/.bashrc
RUN usermod -aG sudo rstudio

# CMD to start both Jupyter and RStudio
#CMD ["bash", "-c", "rstudio-server start; jupyter lab --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token=''"]
