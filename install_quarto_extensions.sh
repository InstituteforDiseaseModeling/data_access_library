#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <extension1> [<extension2> ...]"
    exit 1
fi

# Loop through all provided extensions and install them without prompts
for extension in "$@"; do
    echo "Installing Quarto extension: $extension"
    quarto add "$extension" --no-prompt
done

echo "All requested extensions have been installed."
