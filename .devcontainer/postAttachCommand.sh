#!/bin/bash

echo "RStudio Server failed to start. Restarting..."
rstudio-server restart > rstudio_server.log 2>&1 &

pip install jupyterlab jupyter_core
sleep 5
echo "Setup Jupyter-lab"
# Start Jupyter Lab
if ! pgrep -x "jupyter-lab" > /dev/null; then
    echo "Jupyter Lab is not started. Restarting..."
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' > jupyter_lab.log 2>&1 &
fi

echo "Dev environment startup completed!"
