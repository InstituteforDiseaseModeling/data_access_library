#!/bin/bash

# install rsync
apt-get install -y rsync

# Activate the virtual environment
source /opt/venv/bin/activate
echo 'activated virtualenv.'

# Run the Quarto extension installation
chmod +x /workspace/r/install_quarto_extensions.expect
/workspace/r/install_quarto_extensions.expect
quarto list extensions

# Check Quarto and Rscript status
echo 'Check Quarto status:'
quarto check
echo 'Check R script path:'
which Rscript

# Define folders to process
FOLDERS=(python r)
echo "Folders to process: ${FOLDERS[@]}"

conda update conda
echo "Update conda"

# Process .qmd and .ipynb files in the specified folders
for FOLDER in "${FOLDERS[@]}"; do
  echo "Searching for .qmd and .ipynb files in /workspace/$FOLDER..."
  find "/workspace/$FOLDER" \( -name '*.qmd' -o -name '*.ipynb' \) | while read -r file; do

    echo "Processing file: $file"
    # Remove the /workspace prefix from the file path
    relative_dir=$(dirname "${file#'/workspace/'}")

     # Create a virtual environment inside each folder under .venv
    if [[ "$FOLDER" == "python" ]]; then
      venv_path="/workspace/$relative_dir/.venv"
      echo "Creating virtual environment at: $venv_path"
      python3 -m venv "$venv_path"
      source "$venv_path/bin/activate"
      echo "Activated virtual environment in $venv_path"

      # Install requirements if there is a requirements.txt
      if [[ -f "/workspace/$relative_dir/requirements.txt" ]]; then
        pip install -r "/workspace/$relative_dir/requirements.txt"
      fi
    fi

    # Create a Conda environment for R folders
    if [[ "$FOLDER" == "r" ]]; then
      conda_env_name=$(echo "$relative_dir" | sed 's/\//_/g')_conda_env
      echo "Creating Conda environment: $conda_env_name"

      if [[ -f "/workspace/$relative_dir/environment.yml" ]]; then
        echo "Found environment.yml. Creating environment from file..."
        conda env create -n "$conda_env_name" -f "/workspace/$relative_dir/environment.yml"
      else
        echo "environment.yml not found. Creating a minimal Conda environment with R..."
        conda create -y -n "$conda_env_name" r-base=4.4.1  # Create a minimal Conda environment with R
      fi
      source activate "$conda_env_name"
      echo "Activated Conda environment: $conda_env_name"
      R -e '.libPaths(c("/usr/local/lib/R/site-library", .libPaths()))'

      # Run install_packages.R if it exists
      if [[ -f "/workspace/$relative_dir/install_packages.R" ]]; then
        Rscript "/workspace/$relative_dir/install_packages.R"
      fi
    fi

    # Install extensions in the folder
    # TODO: investigate smarter way to install gobally
    pushd $relative_dir
    /workspace/r/install_quarto_extensions.expect
    popd

    # Define the target directory for the output
    target_dir="/workspace/gallery/$relative_dir"
    echo "Creating target directory: $target_dir"
    mkdir -p "$target_dir" && echo "Directory $target_dir created."

    file_dir=$(dirname "$file")
    if ls "$file_dir"/*.html &>/dev/null; then
      echo "HTML files already exist in $file_dir. Skipping rendering."
      rsync -av --exclude="$(basename "$file")" "$file_dir"/ "$target_dir"
      echo "Files copied to $target_dir."
    else
      # Attempt to render the file with execution
      echo "Attempting to render $file with execution..."
      if quarto render "$file" --to html --output-dir "$target_dir"; then
        echo "Successfully rendered $file with execution."
      else
        echo "Failed to render $file with execution. Rendering without execution..."
        if quarto render "$file" --to html --no-execute --output-dir "$target_dir"; then
          echo "Successfully rendered $file without execution."
        else
          echo "Rendering failed for $file, even without execution."
        fi
      fi
    fi
    # Deactivate and delete virtual environment for Python folders
    if [[ "$FOLDER" == "python" ]]; then
      deactivate
      echo "Deactivated virtual environment: $venv_path"
      rm -rf "$venv_path"
      echo "Deleted virtual environment: $venv_path"
    fi

    # Deactivate and delete the Conda environment for R folders
    if [[ "$FOLDER" == "r" ]]; then
      conda deactivate
      conda remove -y --name "$conda_env_name" --all
      echo "Deleted Conda environment: $conda_env_name"
    fi

  done
done
