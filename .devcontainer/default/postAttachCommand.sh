#!/bin/bash

echo "Restarting Rstudio server..."
sudo rm -rf  /var/run/rstudio-server.id
sleep 1
rstudio-server start > rstudio_server.log 2>&1 &

echo "Install quarto tinytex extension"
quarto install tinytex

pip install jupyterlab jupyter_core
sleep 5
echo "Setup Jupyter-lab"
# Start Jupyter Lab
if ! pgrep -x "jupyter-lab" > /dev/null; then
    echo "Jupyter Lab is not started. Restarting..."
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' > jupyter_lab.log 2>&1 &
fi

# Install reticulate
Rscript -e "install.packages('reticulate', repos='https://cran.r-project.org/')"

echo "Dev environment startup completed!"
