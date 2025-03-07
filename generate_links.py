import os
from pathlib import Path
import yaml
import re
import json

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
        if qmd_file.suffix == ".ipynb":
            # read notebook as json and get title from metadata
            data = json.load(file)
            for cell in data["cells"]:
                if cell["cell_type"] == "raw":
                    for s in cell["source"]:
                       if "title:" in s:
                        return s.split(":", 1)[1].strip().replace("\"", "").replace("\n", "")
        else:
            for line in file:
                if line.lower().startswith("title:"):
                    return line.split(":", 1)[1].strip().replace("\"", "")
    return None


def generate_quarto_config(root_dir, target_folders, output_dir="_site"):
    """Generate a Quarto configuration file with links to rendered HTML files."""
    sidebar_contents = []
    root_path = Path(root_dir)
    print(root_path)
    for subfolder in root_path.iterdir():
        # print(f"subfolder: {subfolder}")
        if subfolder.is_dir() and subfolder.name in target_folders:
            print(f"Processing folder: {subfolder}")
            target_files = list(subfolder.glob("**/*.qmd") ) + list (subfolder.glob("**/*.ipynb"))
            for f in target_files:
                # Check for corresponding .qmd file to extract the title
                title = get_title(f)
                html_file = f.with_suffix(".html")
                sidebar_contents.append({"text": html_file.stem if title is None else title, "href": str(html_file.relative_to(root_dir).as_posix())})

    # Define the Quarto configuration structure
    quarto_config = {
        "project": {"type": "website",
                    "render": ["**/*.qmd", "**/*.ipynb", "!r/", "!python/", "!gallery/"],
                    "output-dir": output_dir,
                    },
        "website": {
            "title": "Data access and analysis library",
            "description": "A collection of examples using quarto showcasing Python / R code for data access and analysis",
            "navbar": {
                "left": [{"text": "Home", "href": "index.html"}],
                "right": [{"text": "GitHub", "href": "https://github.com/InstituteforDiseaseModeling/data_access_library"}],
            },
            "sidebar": {
                "contents": [{"section": "<span class='sidebar-header'>Repo Examples Gallery</span>", "contents": sidebar_contents},
                             {"section": "<span class='sidebar-header'>Other Quarto Examples</span>", "contents":
                                 [{"text": "Quarto example by Amelia", "href":"https://bertozzivill.github.io/Principles-and-Practice-of-Data-Visualization-in-R/"}]}]
            }
        },
        "format": {
            "html":{
                "css": "style.css"
            }
        }
    }
    return quarto_config


def write_quarto_config(config, output_file="_quarto.yml"):
    """Write the Quarto configuration to a YAML file."""
    with open(output_file, "w", encoding="utf-8") as f:
        yaml.dump(config, f, default_flow_style=False)


if __name__ == "__main__":
    root_dir = "."  # Root directory of the repository
    # convert_md_to_qmd( Path(root_dir)/ "README.md", Path(root_dir)/ "index.qmd")
    quarto_config = generate_quarto_config(root_dir, ["r", "python"])
    write_quarto_config(quarto_config)
    print("Generated quarto.yml with sidebar links to HTML files.")
