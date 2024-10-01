#!/bin/bash

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

echo "Dev environment startup completed!"