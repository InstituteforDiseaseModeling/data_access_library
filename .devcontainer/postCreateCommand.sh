#!/bin/bash

# Activate the Python virtual environment
source /opt/venv/bin/activate

# Install Python dependencies
if [ -f "python/requirements.txt" ]; then
    pip install -r python/requirements.txt
fi

# Install R dependencies
#if [ -f "r/install_packages.R" ]; then
#    Rscript r/install_packages.R
#fi

# This may be done by the user
# Set up renv for R
#if [ -f "r/renv.lock" ]; then
#    cd r && R -e 'renv::restore()'
#fi

# Delay to allow the environment to fully initialize
sleep 10

# change the default working directory for RStudio
echo "session-default-working-dir=${CODESPACE_VSCODE_FOLDER}" | sudo tee -a /etc/rstudio/rsession.conf

# Start RStudio Server
rstudio-server start > rstudio_server.log 2>&1 &
sleep 5  # Give some time for the service to start
if ! pgrep -x "rstudio-server" > /dev/null; then
    echo "RStudio Server failed to start. Restarting..."
    rstudio-server restart > rstudio_server.log 2>&1 &
fi

# Start Jupyter Lab
jupyter lab --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token='' > jupyter_lab.log 2>&1 &
sleep 5
if ! pgrep -x "jupyter-lab" > /dev/null; then
    echo "Jupyter Lab failed to start. Restarting..."
    jupyter lab --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token='' > jupyter_lab.log 2>&1 &
fi

echo "Dev environment setup completed!"
