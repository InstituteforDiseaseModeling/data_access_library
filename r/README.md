# Advanced Topics
## Optional Setup: Managing R Dependencies with `renv`

This section is not required for submitting the samples, it is only for those who want to manage the R environment using `renv`.

`renv` is a good practice to manage R package dependencies. Follow the steps below to restore the project environment, 
start working, add libraries as needed, and create a snapshot of the dependencies for version control. This will ensure that whoever checkout the code from this repo will be
working with the same package versions as your original environment.

### 1. Setting Up renv
When starting a new R project or adding R examples to this repository, initialize renv by running:

```r
renv::init()
```
This will create an isolated environment and save your package dependencies to a renv.lock file. 
Once the environment is initialized, any subsequent package installations will be tracked automatically. 
The renv.lock file ensures that others can restore the exact package versions you used.

### 2. Restore the Environment with `renv`

To restore the R environment with the exact packages used in this project, use the `renv` lock file.
This ensures that you are working with the same package versions as the original environment when it was created.

1. Open R or RStudio within the project folder.
2. Restore the environment by running:

```r
# Make sure you have the renv package installed
install.packages("renv")

# Restore the environment from the lock file
renv::restore()
```

This will install all the required packages as installed as listed in the `renv.lock` file.

### 3. Add Libraries as Needed

As you work on the project, you might need to install additional R libraries. You can do this with `install.packages()` as usual. For example:

```r
install.packages("ggplot2")
```

After installing new packages, be sure to update the environment snapshot to capture these new changes.

### 4. Snapshot the Environment

Once you have added or updated any packages, you need to create a new snapshot to update the `renv.lock` file. This ensures that any new dependencies are tracked.

1. Create the snapshot with the following command in R:

```r
renv::snapshot()
```

This will update the `renv.lock` file to reflect the current state of your project’s package library.

2.Commit the changes to version control:

```bash
git add renv.lock
git commit -m "Updated renv.lock after adding new libraries"
git push origin <branch-name>
```

This ensures that others working on the project can restore the environment with the new packages you added.

---

## Use Quarto and shinylive to Create Interactive Documents

In this folder we show an example that you can share code and ideas with others using a quarto document. See
the [simple_example.qmd](./samples/shinylive_demo/simple_example.qmd) file for more details.

To begin with the example, you can open the `simple_example.qmd` file in Rstudio or other IDEs such as VS Code with the Quarto extension installed.

### How to Run the Example

note: if you are running a shinylive that showcases a shiny app in the quarto document, you will need to install the `shinylive` package first.

```bash
quarto install extension quarto-ext/shinylive
```

You can preview and render the quarto document by running the following command in the terminal:

```bash
quarto preview simple_example.qmd --port 4321
```
This will start a local server at port 4321 and open the document in your default browser. 
Note, if you are using codespace, you will need to manually forward the port to view the document in your browser.

Any changes you make to the document will be automatically re-rendered in the browser. 
When you are satisfied with the document, you can render it to a standalone HTML file by running:

```bash
quarto render simple_example.qmd --to html
```

This will use the`_quarto.yaml_` configuration file or the yaml section in your quarto document to render the desired file format
and save them in the `output-dir` directory defined.

For more implementation details, please refer to the [Quarto documentation](https://quarto.org/).

