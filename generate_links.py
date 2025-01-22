import os
from pathlib import Path
import yaml
import re

def convert_md_to_qmd(input_file, output_file):
    """
    Convert a Markdown file to Quarto QMD format by replacing ```mermaid with ```{mermaid}.
    """
    with open(input_file, 'r', encoding='utf-8') as file:
        content = file.read()
    # Replace ```mermaid with ```{mermaid}
    converted_content = re.sub(r'```mermaid', r'```{mermaid}', content)
    # Save the result to the new .qmd file
    with open(output_file, 'w', encoding='utf-8') as file:
        file.write(converted_content)
    print(f"Converted {input_file} to {output_file}.")

def get_title(qmd_file):
    """Extract the title from a Quarto file or return None if not found."""
    with open(qmd_file, "r", encoding="utf-8") as file:
        for line in file:
            if line.lower().startswith("title:"):
                return line.split(":", 1)[1].strip()
    return None


def generate_quarto_config(root_dir, target_folders):
    """Generate a Quarto configuration file with links to rendered HTML files."""
    sidebar_contents = []
    files_to_copy = []
    root_path = Path(root_dir)
    print(root_path)
    for subfolder in root_path.iterdir():
        print(f"subfolder: {subfolder}")
        if subfolder.is_dir() and subfolder.name in target_folders:
            print(f"Processing folder: {subfolder}")
            for file in subfolder.glob("**/*.html"):
                if file.stem == "index":
                    continue
                print(f"Processing file: {file}")
                html_path = file
                relative_link = html_path.relative_to(root_dir)
                # Check for corresponding .qmd file to extract the title
                qmd_file = html_path.with_suffix(".qmd")
                title = None
                if qmd_file.exists():
                    title = get_title(qmd_file)
                title = relative_link.stem if title is None else title  # Fallback to folder name
                sidebar_contents.append({"text": title, "href": str(relative_link)})
                files_to_copy.append(str(relative_link))

    # Define the Quarto configuration structure
    quarto_config = {
        "project": {"type": "website", "render" : ["README.qmd"], "output-dir": "gallery",},
        "website": {
            "title": "Knowledge Sharing with Quarto Tutorial Website",
            "description": "A collection of examples using quarto showcasing Python / R code for data access and analysis",
            "navbar": {
                "left": [{"text": "Home", "href": "README.html"}],
                "right": [{"text": "GitHub", "href": "https://github.com/InstituteforDiseaseModeling/data_access_library"}],
            },
            "sidebar": {
                "contents": [{"section": "Examples Gallery", "contents": sidebar_contents}]
            }
        },
        "files": files_to_copy
    }
    return quarto_config


def write_quarto_config(config, output_file="_quarto.yml"):
    """Write the Quarto configuration to a YAML file."""
    with open(output_file, "w", encoding="utf-8") as f:
        yaml.dump(config, f, default_flow_style=False)


if __name__ == "__main__":
    root_dir = "."  # Root directory of the repository
    convert_md_to_qmd( Path(root_dir)/ "README.md", Path(root_dir)/ "README.qmd")
    quarto_config = generate_quarto_config(root_dir, ["r", "python"])
    write_quarto_config(quarto_config)
    print("Generated quarto.yml with sidebar links to HTML files.")
