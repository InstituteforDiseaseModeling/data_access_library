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

echo "Dev environment setup completed!"
