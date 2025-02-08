# Use Rocker RStudio as base image
FROM rocker/rstudio:latest

# Set Environment Variables
ENV DISABLE_AUTH=true \
    RSTUDIO_SESSION_TIMEOUT=0 \
    R_LIBS_USER=/renv

# Install System Dependencies (Pandoc, Quarto, etc.)
RUN apt-get update && apt-get install -y \
    pandoc \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Create renv cache directory
RUN mkdir -p /renv/cache && chown rstudio:rstudio /renv/cache

# Pre-install R packages into renv cache
RUN Rscript -e "install.packages(c('tidyverse', 'data.table', 'shiny', 'ggplot2', 'dplyr', 'remotes', 'renv'), repos='https://cran.rstudio.com/')"

# Expose port for RStudio
EXPOSE 8787

# Set default working directory for RStudio
RUN echo "session-default-working-dir=/workspace/codespaces_demo" >> /etc/rstudio/rsession.conf

# Set Workdir
WORKDIR /workspace/codespaces_demo
