# Immune_determinant_for_power_of_TMB
## Abstract
Determining the immnue factors which can effect the Power of TMB in immnotherapy.

## Requirements
### software and platform
RStudio

Install R markdown

pandoc version > 1.12.3

### Reproducing results in the manuscript

Clone the git repository:
It should take 5 minutes to install the software, which involves downloading the code from GitHub using the below instructions. 

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
All analysis figures are generated in Result_figures folder

In Data section, the TMB power output from our predictive model for nine rare cancer types is generated.







