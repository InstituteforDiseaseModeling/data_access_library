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

# Set up Jupyter notebooks for Python and R
echo "Setting up Jupyter notebooks..."
mkdir -p /home/vscode/.jupyter && echo \"c.NotebookApp.token = ''\" >> /home/vscode/.jupyter/jupyter_notebook_config.py

jupyter notebook --config=/home/vscode/jupyter_notebook_config.py

echo "Dev environment setup completed!"
