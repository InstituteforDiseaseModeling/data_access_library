#!/bin/bash

# Activate the Python virtual environment
source /opt/venv/bin/activate

# Install Python dependencies
if [ -f "python/requirements.txt" ]; then
    pip install -r python/requirements.txt
fi

# Set up renv for R
if [ -f "R/renv.lock" ]; then
    cd R && R -e 'renv::restore()'
fi

rstudio-server start && jupyter lab --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token=''

echo "Dev environment setup completed!"
