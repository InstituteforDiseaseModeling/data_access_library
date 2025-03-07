# Data Access and Analysis Library Demo

This repository demonstrates some good examples for sharing interactive, reproducible data analysis code across Python and R.
By leveraging devcontainer for consistent development environments and Quarto for technical publishing, 
this setup ensures a smooth experience for researchers to share their code and ideas.

Contributors are encouraged to submit code examples using Quarto in `r/samples` or `python/samples` folders. 
Our goal is not to provide a comprehensive guide to showcase the possibilities of using Quarto for technical publishing. 
But by adding yaml metadata to your code-snippets, it allows publishing the content to Github Pages easily and
others can view the code / results directly in the browser without running the code. 

## Table of Contents

- [Workflow](#workflow)
- [DevContainer](#1-use-of-devcontainer)
- [Quarto Examples Using Jupyter Notebook](#2-quarto-examples-using-jupyter-notebook)
- [Quarto Examples Using `.qmd` for R](#3-quarto-examples-using-markdown-for-r)
- [Key Quarto commands](#4-key-quarto-commands)
- [Contribute your example](#5-contribute-your-example-and-github-page-hosting)

## Workflow 

It is recommended to follow the steps below to create a reproducible example:

```mermaid
%%{init: {'themeVariables': { 'fontSize': '10px', 'nodeSpacing': 1, 'rankSpacing': 1 }}}%%
graph TD
    A[Start] --> B{Dev Container?}
    B -- Yes --> C[Follow step 1 for how to use devcontainer]
    B -- No --> D[Clone the repo locally and setup python or R environment on your own]
    C --> E[Create a new folder under r/samples or python/sample]
    D --> E
    E --> F[Follow step 2 or 3 to add your jupyter notebook or qmd file]
    F --> G[Follow step 4 to test your example locally]
    G --> H[Follow step 5 to Commit your changes and create a pull request]
```
## 1. Use of Devcontainer

The `devcontainer` feature in VS Code allows you to define the development environment using a Docker-based configuration. 
This ensures that all participant in a project has a consistent setup, eliminating the "works only on my machine" problem. 
By using `devcontainer.json`, you can specify the required dependencies for Python and R, configure the environment, 
and set up additional tools like Jupyter and Quarto for sharing your work.

**How to:**

In this repo, we have a template "Python and R Dev Container" that you can use to create a consistent development environment. 
Go to github codespaces and create a new codespace using this template as shown below: 
**(This may take 5-10 minutes, and please be aware of codespace [costs](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-codespaces/about-billing-for-github-codespaces#monthly-included-storage-and-core-hours-for-personal-accounts) )**

![](assets/codespace.png)

**Use the JupyterLab or Rstudio Server instance running in the codespace to edit your Jupyter notebook or Quarto document.**

The default devcontainer configuration has JupyterLab running on port 8888 and Rstudio Server running on port 8787. 
You can access them directly on the browser:
![](assets/port.png)


**Stopping or deleting a GitHub Codespace are effective ways to control costs!**

Stopping a Codespace pauses the environment and stops billing temporarily, 
allowing you to save the state and resume work later without accruing charges. 
Deleting a Codespace will permanently remove the environment, you should make sure to do this 
when you’ve finished the work and don’t need the environment or data anymore.

![](assets/codespace_manage.png)

**Use credentials in Github codespaces**

Codespace account-specific secrets is tied to an individual GitHub account and are available in any Codespace the user launches. 
These are particularly useful for storing credentials that should not be shared across a team, such as personal API tokens or SSH keys. 
Unlike repository-level secrets, personal user secrets persist across all repositories and organizations where the user has access, 
making them ideal for cross-project authentication without exposing credentials in shared environments.
See reference [here](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces).

**Use your local development environment**

If you choose to clone the repo locally, you can also setup your local container to use the same environment, 
follow this [tutorial](https://code.visualstudio.com/docs/devcontainers/tutorial) to set it up.

If your project requires additional dependencies, you can create a customized `your_devcontainer.json` file. 
For more information, check the [VS Code documentation](https://code.visualstudio.com/docs/remote/containers). 
There are many features available in the devcontainer that you can leverage, see this [list](https://containers.dev/features).


## 2. Quarto Examples Using Jupyter Notebook

Quarto is an open-source tool for technical publishing that enables you to create interactive, data-driven documents. 
It is built on top of the R Markdown format and supports Jupyter notebooks as part of its ecosystem.
This section provides examples of using Quarto with Jupyter notebooks for Python-based data analysis. 
The integration allows you to create rich, interactive documents that blend code, analysis, and markdown. for more information, go to [Quarto.org](https://quarto.org/).

**How to:**

In this repo, we have a sample Jupyter notebook [sir_model_simulation.ipynb](python/samples/sir/sir_model_simulation.ipynb) 
that demonstrates how you can insert a yaml at the top of a markdown cell to specify metadata for quarto publishing.
If you are using codespace, a jupyterlab instance is running on port 8888, and you can edit the notebook in the browser or add your own:

![](assets/jupyter.png)

It is a good practice to add required dependencies in the [requirements.txt](python/samples/sir/requirements.txt) file 
so that your example will be easily reproducible by others. You can also choose to use the magic command `!` or `%` 
inside your notebook to install dependent packages.

```python
!pip install numpy~=2.1
%pip install matplotlib>=3.9
```

## 3. Quarto Examples Using Markdown for R

In this section, we explore how to use Quarto's `.qmd` format to create reproducible reports in R. 
Quarto simplifies the process of creating technical documents that include R code, plots, and analysis. 
The `.qmd` files serve as an efficient way to write and maintain both the narrative and the underlying code used in your analysis.
It is very similar to R Markdown but offers additional features and flexibility for publishing.

**How to:**

In this repo, we have a sample Quarto document [simple_plot.qmd](r/samples/simple_plot/simple_plot.qmd) that shows how to add metadata and use R code chunks.
If you are using codespace, an Rstudio Server instance is running on port 8787 (username: **rstudio**, password: **rstudio**)
and you can edit the `.qmd` file directly in the browser or add your own:

![](assets/rstudio_login.png)

You should handle `install.packages` and `library` commands to install and load the required R packages for reproducibility, or provide 
a [install_packages.R](r/samples/simple_plot/install_packages.R) file so that others can reproduce your code easily.


## 4. Key Quarto commands

Once you have created a new folder and added your Jupyter notebook or `.qmd` file, 
you can test it using the `quarto render` command.

You can open a terminal window in your local machine or in the codespace and run the following commands
to build the quarto document locally:

![](assets/terminal.png)


```bash
quarto render your_example.qmd
quarto render your_example.ipynb --to html
```
Quarto allows you to customize the rendering of documents using both the `quarto render` command and the YAML header within a file. Here's a brief overview:

### Quarto Render Command Options:
- **Output Format:** You can specify the format (HTML, PDF, DOCX, etc.) by adding the `--to` flag. For example:
  ```bash
  quarto render file.qmd --to pdf
  ```
  This converts your `.qmd` or `.ipynb` file to PDF.

- **Output Directory:** Control where the output file is saved using `--output-dir`:
  ```bash
  quarto render file.qmd --output-dir output/
  ```

### YAML Header Options:
- **Document Metadata:** Set properties like title, author, and date in the YAML header:
  ```yaml
  ---
  title: "My Report"
  author: "Jane Doe"
  ---
  ```

- **Table of Contents (TOC):** Enable and position the table of contents:
  ```yaml
  ---
  toc: true
  toc-location: left
  ---
  ```

- **Code Execution:** Control whether code is executed or shown in the final document:
  ```yaml
  ---
  execute:
    echo: true
  ---
  ```

These options give you flexibility to control how your documents are rendered, either through the command line or the YAML configuration in your file.
See list of all available options [here](https://quarto.org/docs/reference/formats/opml.html).


## 5. Contribute your example and Github Page hosting
You are encouraged to check in your example to this repo! Please create your own folder under `r/samples` or `python/samples` and add your jupyter notebook or .qmd (quarto markdown) file, you do not need to include the html files as 
all examples checked in to this repo
will be published to [Github Pages](https://institutefordiseasemodeling.github.io/data_access_library/). automatically when merged to main branch.

Below is an example of how to check in a new example to the repo:
### Steps

#### 0. Create a new branch based on the main branch
```bash
git checkout -b my_branch --track origin/main
```
#### 1. Navigate to your example Folder

Open a terminal window and navigate to the folder that you created:

```bash
cd r/samples/my_example
# or
cd python/samples/my_example
```
#### 2. Add your Jupyter Notebook or Quarto Document and other necessary files 
```bash
git add r/samples/my_example/example.qmd

# if you use python, you can add a jupyter notebook and requirements.txt file
git add python/samples/my_example/requirements.txt
git add python/samples/my_example/example.ipynb
```

#### 3. Commit your changes (provide a commit message)
```bash
git commit -m "your_commit_message"
```

#### 4. Push your changes to your branch
```bash
git push origin my_branch
```
note that when codespace is created, it generates a temporary authentication token for GitHub CLI and Git commands, which provides access to the repository for the duration of the Codespace session, it may refresh periodically so you may get access denied error when pushing changes, you can use the "Export changes to a new branch" from UI instead:

![](assets/branch.png)

Be aware that any files you added /edited will appear in this branch but if you have created a commit in step (3), it will be shown in the history which you can easily retrieve later.

#### 5. Create a pull request
Go to the [pull request](https://github.com/InstituteforDiseaseModeling/data_access_library/pulls) 
page and click "create a new pull request" from your branch to the main branch. 
You should use the pull reqeust template provided in [pull_request_template.md](./.github/pull_request_template.md).
Ask a peer to review your code and merge it to the main branch.






