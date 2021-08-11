#!/bin/bash

export RSTUDIO_PANDOC=/Applications/RStudio.app/Contents/MacOS/pandoc

# Step_1
Rscript -e "rmarkdown::render('s0_Build_Immune_matrix.Rmd')"

# Step_2
Rscript -e "rmarkdown::render('s1_Load_Preprocess_MSKCC.Rmd')"

# Step_3
Rscript -e "rmarkdown::render('Figure_1_forest_plot_ICI_response.Rmd')"

# Step_4
Rscript -e "rmarkdown::render('Figure2_and_sup_figure_2.Rmd')"

# Step_5
Rscript -e "rmarkdown::render('Figure_3_mulivariate_model.Rmd')"
