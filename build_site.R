#!/usr/bin/env Rscript

# read .Rmd files in directory
# do not include files that are still being edited
in_paths <- list.files(".", pattern = ".qmd", full.names = TRUE, recursive = TRUE)

# render site
lapply(in_paths, quarto::quarto_render)
