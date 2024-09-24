
## Before you start creating an example for others, please read the renv best-practices to make sure your code can be easily run and repro by others

`renv` is a good practice to manage R package dependencies. Follow the steps below to restore the project environment, 
start working, add libraries as needed, and create a snapshot of the dependencies for version control. This will ensure that whoever checkout the code from this repo will be
working with the same package versions as your original environment.

### 1. Restore the Environment with `renv`

To restore the R environment with the exact packages used in this project, use the `renv` lock file.
This ensures that you are working with the same package versions as the original environment when it was created.

1. Open R or RStudio within the project folder.
2. Restore the environment by running:

```r
# Make sure you have the renv package installed
install.packages("renv")

# Restore the environment
renv::restore()
```

This will install all the required packages as installed as listed in the `renv.lock` file.

### 2. Add Libraries as Needed

As you work on the project, you might need to install additional R libraries. You can do this with `install.packages()` as usual. For example:

```r
install.packages("ggplot2")
```

After installing new packages, be sure to update the environment snapshot to capture these new changes.

### 3. Snapshot the Environment

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

### 4. Optional: Start a New `renv` Environment

If you are starting a new project or want to reset the environment, you can initialize a new `renv` environment:

```r
# Initialize renv when there is no existing environment in the project
renv::init()
```

This will generate a new `renv` setup, including a fresh `renv.lock` file for you to manage the project’s dependencies.

---

## Use Quarto to Create Interactive Documents

In this folder we show an example that you can share code and ideas with others using a quarto document. See
[simple_example.qmd](./simple_example.qmd).

To begin with the example, you can open the `simple_example.qmd` file in Rstudio or other IDEs such as VS Code with the Quarto extension installed.

### 1.How to Run the Example

Since we use shinylive to showcase a shiny app in the quarto document, you need to install the `shinylive` package first. 
This should already be included in the renv.lock file if you follow the above instructions.

```bash
quarto install extension quarto-ext/shinylive
```

Then you can preview and render the quarto document by running the following command in the terminal:

```bash
quarto preview simple_example.qmd --port 4321
```
This will start a local server at port 4321 and open the document in your default browser. 
Any changes you make to the document will be automatically re-rendered in the browser. 
When you are satisfied with the document, you can render it to a standalone HTML file by running:

```bash
quarto render simple_example.qmd
```

This will use the `_quarto.yaml_` configuration file to render the document to an HTML file in the `output-dir` directory defined.

For more implementation details, please refer to the [Quarto documentation](https://quarto.org/).

