#!/usr/bin/env Rscript

# load packages
packages <- c("tidyverse")
xfun::pkg_attach(packages, message = F)

# read .Rmd files in directory
# do not include files that are still being edited
files <- list.files(pattern = ".Rmd") %>%
  str_subset(string = ., pattern = "editing", negate = T)

# render site
lapply(files, rmarkdown::render_site)
