# Immune_determinant_for_power_of_TMB
## Abstract
Determining the immnue factors which can effect the Power of TMB in immunotherapy.

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
If you get this error with Pandoc while running the .sh file

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

* panel_1_A.pdf, panel_1_B.pdF, Extended_panel_1.PDF = Represents the Association TMB High and TMB low with three ICI response (Overall Survival(OS), Progression Free Survival(PFS) and Objective response rate(ORR)). Panel 1 and ex_figure 1 in Manuscript (MS) <br />

* figure 2A and ex_figure_2C = tmb-response VS TME_factorsall_cancerTypes_OS.pdf and tmb-responseVSTME_factorsOnly_Sig_Tmb.Resp_associated_cancerTypes_OS.pdf represent the spearman correlation between <b>TMB power </b> and <b>Immune factor, when ICI response is OS. </b><br />

* figure 2B and ex_figure_2D= tmb-response VS TME_factorsall_cancerTypes_ORR.pdf and tmb-responseVSTME_factorsOnly_Sig_Tmb.Resp_associated_cancerTypes_ORR.pdf represent the spearman correlation between <b>TMB power </b> and <b>Immune factor, when ICI response is OS.</b> <br />

* Ex_figure_2(A and B) = tmb-response VS TME_factorsall_cancerTypes_PFS.pdf and tmb-responseVSTME_factorsOnly_Sig_Tmb.Resp_associated_cancerTypes_PFS.pdf represent the spearman correlation between <b>TMB power </b> and <b>Immune factor, when ICI response is PFS,</b> <br />

* Panel 3 = model_pred_obs_POT_spearman and lollipop_plot_predicted_POT_values <Br />

In Data section: <br />
* The TMB power output from our predictive model for nine rare cancer types is generated.<br />






