#!/bin/bash

Rscript -e "rmarkdown::render('s0_Build_Immune_matrix.Rmd')"
Rscript -e "rmarkdown::render('s1_Load_Preprocess_MSKCC.Rmd')"
Rscript -e "rmarkdown::render('Figure_1_forest_plot_ICI_response.Rmd')"
Rscript -e "rmarkdown::render('Figure2_and_sup_figure_2.Rmd')"
Rscript -e "rmarkdown::render('Figure_3_mulivariate_model.Rmd')"
