# Immune_determinant_for_power_of_TMB
## Summary

The recent studies indicating that high-Tumor mutation burden levels, a recently approved biomarker for the treatment of any solid tumor with Immune checkpoint inhibitor (ICI), are only able to stratify ICI responders in a subset of cancer types. The mechanisms underlying this observation have remained unknown. We hypothesized that the tumor immune microenvironment (TME) may modulate the stratification power of TMB (TMB power), leading to this observation and built a framework that leverages existing publicly available large-scale omics data to identify the key immune factors that can determine this TMB power across different cancer types. Briefly, we find that high levels of M1 macrophages and low levels of resting dendritic cells in the TME characterize cancer types with high TMB power. We also predicted TMB power in additional 9 cancer types, including rare cancers, for which TMB and ICI response data are not yet publicly available on a large scale. This could potentially help in prioritizing cancer types for clinical trials with this ICI biomarker.

## Requirements
Install the software, which involves downloading the code from GitHub using the below instructions. 

### software and platform
Rstudio<br />
Install R markdown <br />
pandoc version > 1.12.3 <br />

### Clone the git repository:

```
git clone https://github.com/ruppinlab/Immune_determinant_for_power_of_TMB.git
```
In the Terminal, go to the Tools directory and Run "Run.sh file"

```
$ cd ./"--PATH of your directory where file is located--"/Immune_determinant_for_power_of_TMB/Tools
$ sh ./Run.sh
```
#### The Run.sh file runs all the RMD scripts:<br />
First, it runs the Step_0 and Step_1 respectively, where it loads the required datasets and functions. <br />
Next, it run Step_3, Step_4, Step_5, for analysis, Figures and building a multivariate Model. <br />

While, running .sh file, if this error with Pandoc occurs:
```
Error: pandoc version 1.12.3 or higher is required and was not found (see the help page ?rmarkdown::pandoc_available).
```
Open the run.sh file and add the below command on second (before starting rscript command) and save. Run again the Run.sh file using above command

For mac users:
```
export RSTUDIO_PANDOC=/Applications/RStudio.app/Contents/MacOS/pandoc
```

For windows user
```
export RSTUDIO_PANDOC="/c/Program Files/RStudio/bin/pandoc/"
```

If Pandoc Path is not correct then. open RStudio in your system and check the Pandoc env using this command.

```
Sys.getenv("RSTUDIO_PANDOC")
## Now paste the output of above command to 

export RSTUDIO_PANDOC="<--Output of above command -->"
```

### What are the expected output files?

In Result figures:
All analysis figures are generated in PDF.<br />

* Panel 1 and ex_figure 1 = Panel_1_A.pdf, panel_1_B.pdF, Extended_panel_1.PDF represents the Association TMB High and TMB low with three ICI response (Overall Survival(OS), Progression Free Survival(PFS) and Objective response rate(ORR)).<br />

* Figure 2A and Ex_figure_2C = tmb-response VS TME_factorsall_cancerTypes_OS.pdf and tmb-responseVSTME_factorsOnly_Sig_Tmb.Resp_associated_cancerTypes_OS.pdf represent the spearman correlation between <b>TMB power </b> and <b>Immune factor, when ICI response is OS. </b><br />

* Figure 2B and Ex_figure_2D= tmb-response VS TME_factorsall_cancerTypes_ORR.pdf and tmb-responseVSTME_factorsOnly_Sig_Tmb.Resp_associated_cancerTypes_ORR.pdf represent the spearman correlation between <b>TMB power </b> and <b>Immune factor, when ICI response is ORR.</b> <br />

* Ex_figure_2(A and B) = tmb-response VS TME_factorsall_cancerTypes_PFS.pdf and tmb-responseVSTME_factorsOnly_Sig_Tmb.Resp_associated_cancerTypes_PFS.pdf represent the spearman correlation between <b>TMB power </b> and <b>Immune factor, when ICI response is PFS,</b> <br />

* Figure 2D = OS_Power_of_TMB_in_5_abu_modulators_spear represents the Pearson correlation of Four Top modulators. <br />

* Panel 3 = model_pred_obs_POT_spearman and lollipop_plot_predicted_POT_values <Br />

In Data section: <br />
* Model_prediction_OS = The TMB power output from our predictive model for nine rare cancer types is generated.<br />






