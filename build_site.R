#!/usr/bin/env Rscript

# read .Rmd files in directory
# do not include files that are still being edited
files <- grep("editing", list.files(pattern = ".Rmd"), value = T, invert = T)

# render site
lapply(files, rmarkdown::render_site)
