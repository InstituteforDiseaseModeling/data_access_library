options(Ncpus = parallel::detectCores())

if (.Platform$OS.type == "unix") {
  type <- "source"
}else{
  type <- "binary"
}


pkgnames <- c(
'devtools', 'DT',
'dplyr','ggplot2', 'plotly', 'tidyr', 'stringr', 'logr', 'tidyverse', 
'knitr', 'rmarkdown',
"leaflet", "leaflet.extras"
)

print(paste0("Install Packages from Cran : ", pkgnames))
install.packages(pkgnames,
                 repos='http://cran.rstudio.com/',
                 type=type)

# Make sure packages are available
if (length(pkgnames[which (!pkgnames %in% installed.packages()[,'Package'])]) >0 ){
  cat(paste0("Package did not install correctly:", c(pkgnames[which (!pkgnames %in% installed.packages()[,'Package'])]), "\n"))
  stop("some packages are not available, please investigate...")
}