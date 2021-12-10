
<!-- rnb-text-begin -->

---
title: "R Notebook"
## title: "Data preprocessing and function"
output: html_notebook
---
<!-- Libraries -->

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucmVxdWlyZShnZ3JlcGVsKVxuYGBgIn0= -->

```r
require(ggrepel)
```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiTG9hZGluZyByZXF1aXJlZCBwYWNrYWdlOiBnZ3JlcGVsXG5Mb2FkaW5nIHJlcXVpcmVkIHBhY2thZ2U6IGdncGxvdDJcbkVycm9yOiBwYWNrYWdlIG9yIG5hbWVzcGFjZSBsb2FkIGZhaWxlZCBmb3IgkWdncGxvdDKSIGluIGxvYWROYW1lc3BhY2UoaSwgYyhsaWIubG9jLCAubGliUGF0aHMoKSksIHZlcnNpb25DaGVjayA9IHZJW1tpXV0pOlxuIG5hbWVzcGFjZSCRcmxhbmeSIDAuNC43IGlzIGFscmVhZHkgbG9hZGVkLCBidXQgPj0gMC40LjEwIGlzIHJlcXVpcmVkXG5GYWlsZWQgd2l0aCBlcnJvcjogIOKAmHBhY2thZ2Ug4oCYZ2dwbG90MuKAmSBjb3VsZCBub3QgYmUgbG9hZGVk4oCZXG4ifQ== -->

```
Loading required package: ggrepel
Loading required package: ggplot2
Error: package or namespace load failed for 㤼㸱ggplot2㤼㸲 in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]):
 namespace 㤼㸱rlang㤼㸲 0.4.7 is already loaded, but >= 0.4.10 is required
Failed with error:  ‘package ‘ggplot2’ could not be loaded’
```



<!-- rnb-output-end -->

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuIyBsaWJyYXJ5KGZvcmVzdHBsb3QpXG5saWJyYXJ5KGNvcnJwbG90KVxuYGBgIn0= -->

```r
# library(forestplot)
library(corrplot)
```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiY29ycnBsb3QgMC44NCBsb2FkZWRcbiJ9 -->

```
corrplot 0.84 loaded
```



<!-- rnb-output-end -->

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucmVxdWlyZShcInN1cnZpdmFsXCIpXG5gYGAifQ== -->

```r
require("survival")
```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiTG9hZGluZyByZXF1aXJlZCBwYWNrYWdlOiBzdXJ2aXZhbFxuIn0= -->

```
Loading required package: survival
```



<!-- rnb-output-end -->

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucmVxdWlyZShzdGF0YXIpXG5gYGAifQ== -->

```r
require(statar)
```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiTG9hZGluZyByZXF1aXJlZCBwYWNrYWdlOiBzdGF0YXJcbnBhY2thZ2UgkXN0YXRhcpIgd2FzIGJ1aWx0IHVuZGVyIFIgdmVyc2lvbiA0LjAuNUVycm9yOiBwYWNrYWdlIG9yIG5hbWVzcGFjZSBsb2FkIGZhaWxlZCBmb3IgkXN0YXRhcpIgaW4gbG9hZE5hbWVzcGFjZShpLCBjKGxpYi5sb2MsIC5saWJQYXRocygpKSwgdmVyc2lvbkNoZWNrID0gdklbW2ldXSk6XG4gbmFtZXNwYWNlIJFybGFuZ5IgMC40LjcgaXMgYWxyZWFkeSBsb2FkZWQsIGJ1dCA+PSAwLjQuMTAgaXMgcmVxdWlyZWRcbiJ9 -->

```
Loading required package: statar
package 㤼㸱statar㤼㸲 was built under R version 4.0.5Error: package or namespace load failed for 㤼㸱statar㤼㸲 in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]):
 namespace 㤼㸱rlang㤼㸲 0.4.7 is already loaded, but >= 0.4.10 is required
```



<!-- rnb-output-end -->

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxubGlicmFyeShnZ3Bsb3QyKVxuYGBgIn0= -->

```r
library(ggplot2)
```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiRXJyb3I6IHBhY2thZ2Ugb3IgbmFtZXNwYWNlIGxvYWQgZmFpbGVkIGZvciDigJhnZ3Bsb3Qy4oCZIGluIGxvYWROYW1lc3BhY2UoaSwgYyhsaWIubG9jLCAubGliUGF0aHMoKSksIHZlcnNpb25DaGVjayA9IHZJW1tpXV0pOlxuIG5hbWVzcGFjZSDigJhybGFuZ+KAmSAwLjQuNyBpcyBhbHJlYWR5IGxvYWRlZCwgYnV0ID49IDAuNC4xMCBpcyByZXF1aXJlZFxuIn0= -->

```
Error: package or namespace load failed for ‘ggplot2’ in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]):
 namespace ‘rlang’ 0.4.7 is already loaded, but >= 0.4.10 is required
```



<!-- rnb-output-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


<!--Load MSKCC combined data -->

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxubXNrY2NfY29tYmluZWQ9IHJlYWQuY3N2KFwiLi4vZGF0YS9tc2tjY19jb21iaW5lZC5jc3ZcIilcbiMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuIyAjIyBSZXBlYXQgQW5hbHlzaXMgZXhjbHVkaW5nIFBBQUQgIyMjIyMjIyMjIyMjIyMjIyNcbiMgbXNrY2NfY29tYmluZWQ9IG1za2NjX2NvbWJpbmVkWyFtc2tjY19jb21iaW5lZCRDYW5jZXJfVHlwZV9hY3JvbnltID09IFwiUEFBRFwiLF1cbiMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXG5tc2tjY19jb21iaW5lZCRDYW5jZXJfVHlwZV9hY3JvbnltPWZhY3Rvcihtc2tjY19jb21iaW5lZCRDYW5jZXJfVHlwZV9hY3JvbnltKVxudGFibGUobXNrY2NfY29tYmluZWQkQ2FuY2VyX1R5cGVfYWNyb255bSlcbmBgYCJ9 -->

```r
mskcc_combined= read.csv("../data/mskcc_combined.csv")
# ########################################
# ## Repeat Analysis excluding PAAD #################
# mskcc_combined= mskcc_combined[!mskcc_combined$Cancer_Type_acronym == "PAAD",]
# ########################################

mskcc_combined$Cancer_Type_acronym=factor(mskcc_combined$Cancer_Type_acronym)
table(mskcc_combined$Cancer_Type_acronym)
```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiXG4gQkxDQSAgQlJDQSAgQ09BRCAgRVNDQSAgIEdCTSAgSE5TQyAgS0lSQyAgTElIQyBOU0NMQyAgICBPViAgUEFBRCAgU0FSQyAgU0tDTSAgVUNFQyBcbiAgMjE4ICAgIDM5ICAgMTM0ICAgIDg5ICAgMTQ1ICAgMTc0ICAgMjIyICAgIDUzICAgODAwICAgIDI4ICAgIDMxICAgIDY4ICAgMjEyICAgIDY0IFxuIn0= -->

```

 BLCA  BRCA  COAD  ESCA   GBM  HNSC  KIRC  LIHC NSCLC    OV  PAAD  SARC  SKCM  UCEC 
  218    39   134    89   145   174   222    53   800    28    31    68   212    64 
```



<!-- rnb-output-end -->

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuc2FtcGxlc19ieV9jYW5jZXJfdHlwZSA9IGFnZ3JlZ2F0ZShJRCB+IENhbmNlcl9UeXBlX2Fjcm9ueW0sbXNrY2NfY29tYmluZWQsIGxlbmd0aCkgXG5jYW5jZXJUeXBlc19vZl9JbnRlcmVzdCA9IHNhbXBsZXNfYnlfY2FuY2VyX3R5cGVbLDFdW3NhbXBsZXNfYnlfY2FuY2VyX3R5cGVbLDJdPiAxXVxuXG4jIyByZW1vdmluZyBjYW5jZXIgdHlwZXMgd2hlcmUgUEZTLyBPUlIgaXMgTkEgZm9yIGZpZ3VyZSAxQiBhbmQgZXggZmlndXJlIDFcbm1za2NjX2RmX09SUl9QRlM9IG1za2NjX2NvbWJpbmVkWyEoaXMubmEobXNrY2NfY29tYmluZWQkUEZTX3N0YXR1cykpLF1cbnNhbXBsZXNfZWFjaF9jYW5jZXJfdHlwZSA9IGFnZ3JlZ2F0ZShJRCB+IENhbmNlcl9UeXBlX2Fjcm9ueW0sbXNrY2NfZGZfT1JSX1BGUywgbGVuZ3RoKSBcbmNhbmNlclR5cGVzX29mX0ludGVyZXN0ID0gc2FtcGxlc19ieV9jYW5jZXJfdHlwZVssMV1bc2FtcGxlc19ieV9jYW5jZXJfdHlwZVssMl0+IDFdXG5gYGAifQ== -->

```r
samples_by_cancer_type = aggregate(ID ~ Cancer_Type_acronym,mskcc_combined, length) 
cancerTypes_of_Interest = samples_by_cancer_type[,1][samples_by_cancer_type[,2]> 1]

## removing cancer types where PFS/ ORR is NA for figure 1B and ex figure 1
mskcc_df_ORR_PFS= mskcc_combined[!(is.na(mskcc_combined$PFS_status)),]
samples_each_cancer_type = aggregate(ID ~ Cancer_Type_acronym,mskcc_df_ORR_PFS, length) 
cancerTypes_of_Interest = samples_by_cancer_type[,1][samples_by_cancer_type[,2]> 1]
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->

<!-- funtion Error handle -->

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuZXJyX2hhbmRsZTwtZnVuY3Rpb24oeClcbiAgeyB0cnlDYXRjaCh4LCBlcnJvcj1mdW5jdGlvbihlKXtOQX0pIH1cbmBgYCJ9 -->

```r
err_handle<-function(x)
  { tryCatch(x, error=function(e){NA}) }
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->

<!--Analysis: reviewer 3- R5, finding equal number of sample when TMB >= 10 mut/MB, using percentile-->

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuYGBgclxuc2FtcGxlc19lcXVhbF9pbl90aHJlc2hvbGRfZWFjaF9jYW5jZXJfdHlwZVxuXG5gYGBcbmBgYCJ9 -->

```r
```r
samples_equal_in_threshold_each_cancer_type

```
```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiICAgICAgbGVzc190aGFuX3RocmVzaG9sZCBncmVhdGVyX3RoYW5fdGhyZXNob2xkIHRocmVzaG9sZFxuQkxDQSAgICAgICAgICAgICAgICAgIDE2MCAgICAgICAgICAgICAgICAgICAgIDU4ICAxNC40OTgxN1xuQlJDQSAgICAgICAgICAgICAgICAgICAyOSAgICAgICAgICAgICAgICAgICAgIDEwICAgNS41ODAwMFxuQ09BRCAgICAgICAgICAgICAgICAgICA5OCAgICAgICAgICAgICAgICAgICAgIDM2ICA0MS4zMDAwMFxuRVNDQSAgICAgICAgICAgICAgICAgICA2NSAgICAgICAgICAgICAgICAgICAgIDI0ICAgOC44MDAwMFxuR0JNICAgICAgICAgICAgICAgICAgIDEwMyAgICAgICAgICAgICAgICAgICAgIDQyICAgNS41ODAwMFxuSE5TQyAgICAgICAgICAgICAgICAgIDEyNiAgICAgICAgICAgICAgICAgICAgIDQ4ICAgNy45MDAwMFxuS0lSQyAgICAgICAgICAgICAgICAgIDE2MSAgICAgICAgICAgICAgICAgICAgIDYxICAgNC45MjAwMFxuTElIQyAgICAgICAgICAgICAgICAgICAzOCAgICAgICAgICAgICAgICAgICAgIDE1ICAgNy4wMDAwMFxuTlNDTEMgICAgICAgICAgICAgICAgIDU4MCAgICAgICAgICAgICAgICAgICAgMjIwICAxMS40MDAwMFxuT1YgICAgICAgICAgICAgICAgICAgICAyMCAgICAgICAgICAgICAgICAgICAgICA4ICAgNS4zMDAwMFxuUEFBRCAgICAgICAgICAgICAgICAgICAyMyAgICAgICAgICAgICAgICAgICAgICA4ICAgMy45MDAwMFxuU0FSQyAgICAgICAgICAgICAgICAgICA0NyAgICAgICAgICAgICAgICAgICAgIDIxICAgMy41MDAwMFxuU0tDTSAgICAgICAgICAgICAgICAgIDE1NiAgICAgICAgICAgICAgICAgICAgIDU2ICAyNy4yMDAwMFxuVUNFQyAgICAgICAgICAgICAgICAgICA0NiAgICAgICAgICAgICAgICAgICAgIDE4ICAyOS44MDAwMFxuIn0= -->

```
      less_than_threshold greater_than_threshold threshold
BLCA                  160                     58  14.49817
BRCA                   29                     10   5.58000
COAD                   98                     36  41.30000
ESCA                   65                     24   8.80000
GBM                   103                     42   5.58000
HNSC                  126                     48   7.90000
KIRC                  161                     61   4.92000
LIHC                   38                     15   7.00000
NSCLC                 580                    220  11.40000
OV                     20                      8   5.30000
PAAD                   23                      8   3.90000
SARC                   47                     21   3.50000
SKCM                  156                     56  27.20000
UCEC                   46                     18  29.80000
```



<!-- rnb-output-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


<!-- Functions needed-->
<!--Update: in original analysis we did not use the argument th, please uncomment the former function (code) and comment the latter function (code) when you perform the analysis based on TMB high >= 10 mut/MB -->

<!--Analysis: Reviewer 3 - R4, repeat the analysis at different percentile (10, 20 percentile)-->
<!--Update: use of argument "th" in function for the making the percentile based TMB threshold instead of 10 mut/MB -->


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuIyMjIyMgQ2FsY3VsYXRlcyBUTUIgYW5kIFJlc3BvbnNlIGFzc29jYWl0aW9uXG5cbkNhbGN1bGF0ZV9UTUJfUmVzcG9uc2VfYXNzb2NpYXRpb248LWZ1bmN0aW9uKGluZnVuY19kZj0gbXNrY2NfY29tYmluZWQsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBDT0k9XCJOU0NMQ1wiLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVzcG9uc2VfbWVhc3VyZT0nT1JSJyl7XG4gIGluZnVuY19kZl90bWI9IGluZnVuY19kZlsoKGluZnVuY19kZiRDYW5jZXJfVHlwZV9hY3JvbnltID09IENPSSkpLF1cbiAgI2luZnVuY19kZl90bWI9IGluZnVuY19kZlsoKGluZnVuY19kZiRDYW5jZXJfVHlwZSA9PSBDT0kpKSxdXG5cbiAgaWYocmVzcG9uc2VfbWVhc3VyZT09J09SUicpe1xuICAgIGluZnVuY19kZl90bWI9aW5mdW5jX2RmX3RtYlshaXMubmEoaW5mdW5jX2RmX3RtYiRPUlIpLF1cblxuICAgICMgQ29udGlnZW5jeSBtYXRyaXhcbiAgICBjb250X21hdHJpeD10YWJsZShpbmZ1bmNfZGZfdG1iJFRNQiA+PSAxMCwgaW5mdW5jX2RmX3RtYiRPUlIpXG4gICAgIyBQZXJmb3JtIGZpc2hlciB0ZXN0XG4gICAgZmlzaGVyX3Rlc3RfcmVzdWx0c19yYXc9ZmlzaGVyLnRlc3QoY29udF9tYXRyaXgpXG4gICAgdG9fcmV0dXJuPWMoZWZmZWN0X3NpemU9dW5saXN0KGZpc2hlcl90ZXN0X3Jlc3VsdHNfcmF3JGVzdGltYXRlKSxcbiAgICAgICAgICAgICAgICBQPWZpc2hlcl90ZXN0X3Jlc3VsdHNfcmF3JHAudmFsdWUpXG4gIH0gZWxzZSBpZihyZXNwb25zZV9tZWFzdXJlID09J09TJykge1xuICAgIGluZnVuY19kZl90bWI9IGluZnVuY19kZl90bWJbIWlzLm5hKGluZnVuY19kZl90bWIkT3ZlcmFsbF9zdXJ2aXZhbF9tb250aHMpLF1cblxuICAgICMgUGVyZm9ybSBjb3hwaCB0ZXN0XG4gICAgY294cGhfbW9kZWwgPC0gY294cGgoU3Vydih0aW1lID0gT3ZlcmFsbF9zdXJ2aXZhbF9tb250aHMsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBldmVudCA9IE92ZXJhbGxfc3Vydml2YWxfc3RhdHVzKSB+IChUTUIgPj0gMTApICxcbiAgICAgICAgICAgICAgICAgICAgICAgICBkYXRhID0gaW5mdW5jX2RmX3RtYilcbiAgICB0b19yZXR1cm49YyhlZmZlY3Rfc2l6ZT1zdW1tYXJ5KGNveHBoX21vZGVsKSRjb2VmZmljaWVudHNbMSxjKDIpXSxcbiAgICAgICAgICAgICAgICBQPXN1bW1hcnkoY294cGhfbW9kZWwpJGNvZWZmaWNpZW50c1sxLGMoNSldKVxuICB9ICBlbHNlIGlmKHJlc3BvbnNlX21lYXN1cmU9PSdQRlMnKSB7XG4gICAgaW5mdW5jX2RmX3RtYj0gaW5mdW5jX2RmX3RtYlshaXMubmEoaW5mdW5jX2RmX3RtYiRQRlNfbW9udGhzKSxdXG5cbiAgICBjb3hwaF9tb2RlbCA8LSBjb3hwaChTdXJ2KHRpbWUgPSBQRlNfbW9udGhzLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXZlbnQgPSBQRlNfc3RhdHVzKSB+IChUTUIgPj0gMTApICxcbiAgICAgICAgICAgICAgICAgICAgICAgICBkYXRhID0gaW5mdW5jX2RmX3RtYilcbiAgICB0b19yZXR1cm49YyhlZmZlY3Rfc2l6ZT1zdW1tYXJ5KGNveHBoX21vZGVsKSRjb2VmZmljaWVudHNbMSxjKDIpXSxcbiAgICAgICAgICAgICAgICBQPXN1bW1hcnkoY294cGhfbW9kZWwpJGNvZWZmaWNpZW50c1sxLGMoNSldKVxuICB9XG4gIG5hbWVzKHRvX3JldHVybik9YygnZWZmZWN0X3NpemUnLCAnUCcpXG4gIHRvX3JldHVyblxufVxuXG4jIENhbGN1bGF0ZV9UTUJfUmVzcG9uc2VfYXNzb2NpYXRpb248LWZ1bmN0aW9uKGluZnVuY19kZj0gbXNrY2NfY29tYmluZWQsXG4jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIENPST1cIk5TQ0xDXCIsXG4jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJlc3BvbnNlX21lYXN1cmU9J09SUicsXG4jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoPSByYXRpb19UTUJfSF92c19MKjEwMCl7XG4jICAgaW5mdW5jX2RmX3RtYj0gaW5mdW5jX2RmWygoaW5mdW5jX2RmJENhbmNlcl9UeXBlX2Fjcm9ueW0gPT0gQ09JKSksXVxuIyAgICNpbmZ1bmNfZGZfdG1iPSBpbmZ1bmNfZGZbKChpbmZ1bmNfZGYkQ2FuY2VyX1R5cGUgPT0gQ09JKSksXVxuIyAgIFxuIyAgIGlmKHJlc3BvbnNlX21lYXN1cmU9PSdPUlInKXtcbiMgICAgIGluZnVuY19kZl90bWI9aW5mdW5jX2RmX3RtYlshaXMubmEoaW5mdW5jX2RmX3RtYiRPUlIpLF1cbiMgICAgIHRocmVzaG9sZD1zb3J0KGluZnVuY19kZl90bWIkVE1CLCBkZWNyZWFzaW5nID0gVClbcm91bmQobnJvdyhpbmZ1bmNfZGZfdG1iKSoodGgvMTAwKSldXG4jICAgICBcbiMgICAgICMgQ29udGlnZW5jeSBtYXRyaXhcbiMgICAgIGNvbnRfbWF0cml4PXRhYmxlKGluZnVuY19kZl90bWIkVE1CID49IHRocmVzaG9sZCwgaW5mdW5jX2RmX3RtYiRPUlIpXG4jICAgICAjIFBlcmZvcm0gZmlzaGVyIHRlc3RcbiMgICAgIGZpc2hlcl90ZXN0X3Jlc3VsdHNfcmF3PWZpc2hlci50ZXN0KGNvbnRfbWF0cml4KVxuIyAgICAgdG9fcmV0dXJuPWMoZWZmZWN0X3NpemU9dW5saXN0KGZpc2hlcl90ZXN0X3Jlc3VsdHNfcmF3JGVzdGltYXRlKSxcbiMgICAgICAgICAgICAgICAgIFA9ZmlzaGVyX3Rlc3RfcmVzdWx0c19yYXckcC52YWx1ZSlcbiMgICB9IGVsc2UgaWYocmVzcG9uc2VfbWVhc3VyZSA9PSdPUycpIHtcbiMgICAgIGluZnVuY19kZl90bWI9IGluZnVuY19kZl90bWJbIWlzLm5hKGluZnVuY19kZl90bWIkT3ZlcmFsbF9zdXJ2aXZhbF9tb250aHMpLF1cbiMgICAgIHRocmVzaG9sZD1zb3J0KGluZnVuY19kZl90bWIkVE1CLCBkZWNyZWFzaW5nID0gVClbcm91bmQobnJvdyhpbmZ1bmNfZGZfdG1iKSoodGgvMTAwKSldXG4jICAgICBcbiMgICAgICMgUGVyZm9ybSBjb3hwaCB0ZXN0XG4jICAgICBjb3hwaF9tb2RlbCA8LSBjb3hwaChTdXJ2KHRpbWUgPSBPdmVyYWxsX3N1cnZpdmFsX21vbnRocyxcbiMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXZlbnQgPSBPdmVyYWxsX3N1cnZpdmFsX3N0YXR1cykgfiAoVE1CID49IHRocmVzaG9sZCkgLFxuIyAgICAgICAgICAgICAgICAgICAgICAgICAgZGF0YSA9IGluZnVuY19kZl90bWIpXG4jICAgICB0b19yZXR1cm49YyhlZmZlY3Rfc2l6ZT1zdW1tYXJ5KGNveHBoX21vZGVsKSRjb2VmZmljaWVudHNbMSxjKDIpXSxcbiMgICAgICAgICAgICAgICAgIFA9c3VtbWFyeShjb3hwaF9tb2RlbCkkY29lZmZpY2llbnRzWzEsYyg1KV0pXG4jICAgfSAgZWxzZSBpZihyZXNwb25zZV9tZWFzdXJlPT0nUEZTJykge1xuIyAgICAgaW5mdW5jX2RmX3RtYj0gaW5mdW5jX2RmX3RtYlshaXMubmEoaW5mdW5jX2RmX3RtYiRQRlNfbW9udGhzKSxdXG4jICAgICB0aHJlc2hvbGQ9c29ydChpbmZ1bmNfZGZfdG1iJFRNQiwgZGVjcmVhc2luZyA9IFQpW3JvdW5kKG5yb3coaW5mdW5jX2RmX3RtYikqKHRoLzEwMCkpXVxuIyAgICAgXG4jICAgICBjb3hwaF9tb2RlbCA8LSBjb3hwaChTdXJ2KHRpbWUgPSBQRlNfbW9udGhzLFxuIyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBldmVudCA9IFBGU19zdGF0dXMpIH4gKFRNQiA+PSB0aHJlc2hvbGQpICxcbiMgICAgICAgICAgICAgICAgICAgICAgICAgIGRhdGEgPSBpbmZ1bmNfZGZfdG1iKVxuIyAgICAgdG9fcmV0dXJuPWMoZWZmZWN0X3NpemU9c3VtbWFyeShjb3hwaF9tb2RlbCkkY29lZmZpY2llbnRzWzEsYygyKV0sXG4jICAgICAgICAgICAgICAgICBQPXN1bW1hcnkoY294cGhfbW9kZWwpJGNvZWZmaWNpZW50c1sxLGMoNSldKVxuIyAgIH1cbiMgICBuYW1lcyh0b19yZXR1cm4pPWMoJ2VmZmVjdF9zaXplJywgJ1AnKVxuIyAgIHRvX3JldHVyblxuIyB9XG5gYGAifQ== -->

```r
##### Calculates TMB and Response assocaition

Calculate_TMB_Response_association<-function(infunc_df= mskcc_combined,
                                             COI="NSCLC",
                                             response_measure='ORR'){
  infunc_df_tmb= infunc_df[((infunc_df$Cancer_Type_acronym == COI)),]
  #infunc_df_tmb= infunc_df[((infunc_df$Cancer_Type == COI)),]

  if(response_measure=='ORR'){
    infunc_df_tmb=infunc_df_tmb[!is.na(infunc_df_tmb$ORR),]

    # Contigency matrix
    cont_matrix=table(infunc_df_tmb$TMB >= 10, infunc_df_tmb$ORR)
    # Perform fisher test
    fisher_test_results_raw=fisher.test(cont_matrix)
    to_return=c(effect_size=unlist(fisher_test_results_raw$estimate),
                P=fisher_test_results_raw$p.value)
  } else if(response_measure =='OS') {
    infunc_df_tmb= infunc_df_tmb[!is.na(infunc_df_tmb$Overall_survival_months),]

    # Perform coxph test
    coxph_model <- coxph(Surv(time = Overall_survival_months,
                              event = Overall_survival_status) ~ (TMB >= 10) ,
                         data = infunc_df_tmb)
    to_return=c(effect_size=summary(coxph_model)$coefficients[1,c(2)],
                P=summary(coxph_model)$coefficients[1,c(5)])
  }  else if(response_measure=='PFS') {
    infunc_df_tmb= infunc_df_tmb[!is.na(infunc_df_tmb$PFS_months),]

    coxph_model <- coxph(Surv(time = PFS_months,
                              event = PFS_status) ~ (TMB >= 10) ,
                         data = infunc_df_tmb)
    to_return=c(effect_size=summary(coxph_model)$coefficients[1,c(2)],
                P=summary(coxph_model)$coefficients[1,c(5)])
  }
  names(to_return)=c('effect_size', 'P')
  to_return
}

# Calculate_TMB_Response_association<-function(infunc_df= mskcc_combined,
#                                              COI="NSCLC",
#                                              response_measure='ORR',
#                                              th= ratio_TMB_H_vs_L*100){
#   infunc_df_tmb= infunc_df[((infunc_df$Cancer_Type_acronym == COI)),]
#   #infunc_df_tmb= infunc_df[((infunc_df$Cancer_Type == COI)),]
#   
#   if(response_measure=='ORR'){
#     infunc_df_tmb=infunc_df_tmb[!is.na(infunc_df_tmb$ORR),]
#     threshold=sort(infunc_df_tmb$TMB, decreasing = T)[round(nrow(infunc_df_tmb)*(th/100))]
#     
#     # Contigency matrix
#     cont_matrix=table(infunc_df_tmb$TMB >= threshold, infunc_df_tmb$ORR)
#     # Perform fisher test
#     fisher_test_results_raw=fisher.test(cont_matrix)
#     to_return=c(effect_size=unlist(fisher_test_results_raw$estimate),
#                 P=fisher_test_results_raw$p.value)
#   } else if(response_measure =='OS') {
#     infunc_df_tmb= infunc_df_tmb[!is.na(infunc_df_tmb$Overall_survival_months),]
#     threshold=sort(infunc_df_tmb$TMB, decreasing = T)[round(nrow(infunc_df_tmb)*(th/100))]
#     
#     # Perform coxph test
#     coxph_model <- coxph(Surv(time = Overall_survival_months,
#                               event = Overall_survival_status) ~ (TMB >= threshold) ,
#                          data = infunc_df_tmb)
#     to_return=c(effect_size=summary(coxph_model)$coefficients[1,c(2)],
#                 P=summary(coxph_model)$coefficients[1,c(5)])
#   }  else if(response_measure=='PFS') {
#     infunc_df_tmb= infunc_df_tmb[!is.na(infunc_df_tmb$PFS_months),]
#     threshold=sort(infunc_df_tmb$TMB, decreasing = T)[round(nrow(infunc_df_tmb)*(th/100))]
#     
#     coxph_model <- coxph(Surv(time = PFS_months,
#                               event = PFS_status) ~ (TMB >= threshold) ,
#                          data = infunc_df_tmb)
#     to_return=c(effect_size=summary(coxph_model)$coefficients[1,c(2)],
#                 P=summary(coxph_model)$coefficients[1,c(5)])
#   }
#   names(to_return)=c('effect_size', 'P')
#   to_return
# }
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-frame-begin eyJtZXRhZGF0YSI6eyJjbGFzc2VzIjpbImRhdGEuZnJhbWUiXSwibnJvdyI6MjMsIm5jb2wiOjM5fSwicmRmIjoiSDRzSUFBQUFBQUFBQnUyYVBXL1RRQmpIM2J5MEpPcDdFUkVDVmQwS1EwOU5BSWtORWlmUXFIRVNrclRxaGk3MjFiR3c3eUw3RE0zRXhCZmhBekIzNStPd01ESVZIcitja3pobGdhRVpMcEoxai8vUHkvM3VkWEY2OVl0bnhZdWlvaWhaSmFka2xHd2VUR1ZWN1pZckx5cUtrc3ZBMndwNENrRjdCVkY3WUJ6Q3N3bFA2ZFczNjNjL3Z1eGZmLzRaWksxOVhkcjIxM3dyK0YrWGxmQjM1M3oveUgvblhKSi9PZmdrLzNLM2tsL3lTMzdKTC9rbHYrU1gvSkpmOGt0K3lYL1hYSkovT2Znay8zSzNrbC95UzM3Skwva2x2K1NYL1AvTlAvZGhOVSt4UXp3d3RwWGc0Mm9rWmp1OVhtenVhRDdIM0dJVTI2am11d2Foc2FOZ003TjhqTFFhaW9VdGRjS1pQZUdXamp5ZHVTU1dIdzJRVG13Ymthc1I5cjJnRXZJc2syTHVKeUdielRkdGMwRjkyTGppaEJyRVFKYmorSlRNQkNoaHdFWXRxa3p4ZC9SUlpBblJJUTV6SjdHNDNyV3g1K0RRNHdsTnJiOUVhQkJyVWNVOXRmNGN4ZlVTVnhSK1AzUzVCRVpBelpRdlNzTTZ0eGJTSXRlSTJHUGlwbHlyQXlobmlyZmRlSnBNN0FDb1FXeU9ZODkyTCs2MGZUcVh2MVdOT2t6SkJZMVJwazg0RWNLR2Rvd2NyTHRzUE1KbU1rMWErVGF4c2lpV1JQZXc5SVpyQmNzNzI5MkRtT0oyNzY1SWRyREg1enc3Y2Q2Q1k3M0JQSXNDZ2pXanRZblAzWGt0Mnh5Y0NNUnV2VlZHWTVkeFlsSFlhR05ZSmc4Mm1saTYwRzBTMkVJTHZyMXUvVyt1M0NYNEJHMmJNRXk1QlpGb09Ic0tIcDlNakFDTURTM2Q0aFBFTGhGTlF1T1kvYUQvZ3ljNmM0WVdKY2JCR0FZWWpQMGdQQ1pQeGVRUDFCNHlRSGJCbTJ6Y2dRL2JHSTE5TjlEbVQyN0JaWi9RN09rdGlabXBxcW9ZUTYyblZvV3ROdnBDdjZkMnF2WDNXcitaZXUrTDJETzFrZFNBTkZFais3YW1DZm1rblpUTHRab25pZDAvVlpNWXJkSHZpTlN6ODBSdW5WWHJVenNwayttY0M3VmJuVVowZTFQN3RObWJkbFNkMnJYV3pEZzdTWHdlR0Z0cStzclQ0VFlRa3liRW9vRTVScGN1ekNlODNhUlMxdGc0dUxrZ0tSUDhDU1dmU2w1eFU4SzJUNE9WTVk3MGtVOC9IRldDLzNvVVEzLzBiTVJ0YWNZK2pQck0vSTVyNWNVOVFhZ0orMGJBMjNoSWJIRnh3aFlJZHdCc2ZvdHlNUlJRUGNRWnh5S3VxRE5iS09IZ2xKcy9QVmQvcm4wakFBQT0ifQ== -->

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["ORR"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Mutational.Burden"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["log10.MB."],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Cytolytic.score"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["T.cell.exhaustion.signature"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["IFNg.signature"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Extended.immune.signature"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["B.cell.naÃ.ve"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["B.cell.memory"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["Plasma.cells"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["CD8..T.cells"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["CD4..naÃ.ve.T.cells"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["CD4..resting.T.cells"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["CD4..active.T.cells"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["CD4..helper.T.cells"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["T.regs"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["T.cell.gamma.delta"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["Resting.NK.cells"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["Active.NK.cells"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["Monocytes"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["M0.macrophage"],"name":[21],"type":["dbl"],"align":["right"]},{"label":["M1.macrophage"],"name":[22],"type":["dbl"],"align":["right"]},{"label":["M2.macrophage"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["Resting.dendritic.cells"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["Active.dendritic.cells"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["Resting.mast.cells"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["Active.mast.cells"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["Eosinophills"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["Neutrophills"],"name":[29],"type":["dbl"],"align":["right"]},{"label":["ITH"],"name":[30],"type":["dbl"],"align":["right"]},{"label":["PDL1.protein.expression"],"name":[31],"type":["dbl"],"align":["right"]},{"label":["PDL1.gene.expression"],"name":[32],"type":["dbl"],"align":["right"]},{"label":["PD1.gene.expression"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["fPD1"],"name":[34],"type":["dbl"],"align":["right"]},{"label":["Neoantigen.burden"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["Hydrophobicity.of.neoantigen"],"name":[36],"type":["dbl"],"align":["right"]},{"label":["PDL1 (combined positive score)"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["TCR.diversity"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["Tumor.purity"],"name":[39],"type":["dbl"],"align":["right"]}],"data":[{"1":"0.06","2":"17","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"ACC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"BRCA"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"CESC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"COAD_MSI"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"COAD_MSS"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"UCEC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"ESCA"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"GBM"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"HNSC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"LIHC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"SKCM"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"MESO"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"UVM"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"LUAD"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"LUSC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"OV"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"PAAD"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"PRAD"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"KIRC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"SARC"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"BLCA"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"COAD"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA","25":"NA","26":"NA","27":"NA","28":"NA","29":"NA","30":"NA","31":"NA","32":"NA","33":"NA","34":"NA","35":"NA","36":"NA","37":"NA","38":"NA","39":"NA","_rn_":"NSCLC"}],"options":{"columns":{"min":{},"max":[10],"total":[39]},"rows":{"min":[10],"max":[10],"total":[23]},"pages":{}}}
  </script>
</div>

<!-- rnb-frame-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuY3JlYXRlX3NjYXR0ZXJfcGxvdDwtIGZ1bmN0aW9uKGluZnVuY19jYW5jZXJfdHlwZXM9YWxsY2FuY2VyX3R5cGVzLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGluZnVuY19pbW11bmVfbWF0cml4PWltbXVuZV9mYWN0b3IsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW5mdW5fVG1iX1Jlc3BfQXNzb2NpYXRpb24gPSBPU19kaWZmZXJlbmNlLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJlc3BvbnNlX3R5cGU9J09TJyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zaWRlcl9jYW5jZXJfdHlwZT0nYWxsX2NhbmNlclR5cGVzJywgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW5mdW5jX3RpdGxlPSdBbGwgY2FuY2VyVHlwZXMnLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGltbXVuZV9mZWF0dXJlX29mX2ludGVyZXN0PSBjb2xuYW1lcyhpbmZ1bmNfaW1tdW5lX21hdHJpeClbMzddKXtcbiAgZGYycGxvdD1kYXRhLmZyYW1lKGluZnVuX1RtYl9SZXNwX0Fzc29jaWF0aW9uW2luZnVuY19jYW5jZXJfdHlwZXMsXSxcbiAgICAgICAgICAgICBmZWF0dXJlc19yZXNwPSBpbmZ1bmNfaW1tdW5lX21hdHJpeFtpbmZ1bmNfY2FuY2VyX3R5cGVzLGltbXVuZV9mZWF0dXJlX29mX2ludGVyZXN0XSlcbiAgZGYycGxvdD1uYS5vbWl0KGRmMnBsb3QpXG4gIFBhbmVsMyA8LSBnZ3Bsb3QoZGYycGxvdCwgYWVzKHg9cmFuayhlZmZlY3Rfc2l6ZSksIHk9cmFuayhmZWF0dXJlc19yZXNwKSwgc2l6ZT0gLWxvZyhQLCAxMCkgKSkgKyBcbiAgICBzdGF0X3Ntb290aChtZXRob2Q9J2xtJykrXG4gICAgZ2VvbV9wb2ludCgpK1xuICAgIHRoZW1lX2J3KGJhc2Vfc2l6ZSA9IDE1KStcbiAgICAjIHRoZW1lKGxlZ2VuZC5wb3NpdGlvbiA9ICdub25lJykrXG4gICAgbGFicyh4PSdQb3dlciBvZiBUTUIgKHJhbmspJyxcbiAgICAgICAgIHk9cGFzdGUoZ3N1YignXFxcXC4nLCcgJyxpbW11bmVfZmVhdHVyZV9vZl9pbnRlcmVzdCksICAnKHJhbmspJyksIHNpemU9Jy1sb2cxMChQKScpK1xuICAgIHN0YXRfY29yKGxhYmVsLnkgPSAwLCBsYWJlbC54ID0gNSwgbWV0aG9kID0gJ3AnLCBjb3IuY29lZi5uYW1lID0gJ3JobycsIHNpemU9NSkrXG4gICAgZ2VvbV9sYWJlbF9yZXBlbChhZXMobGFiZWw9cm93bmFtZXMoZGYycGxvdCksIHNpemU9MC41KSwgc2hvdy5sZWdlbmQgPSBGKStcbiAgICBjb29yZF9mbGlwKClcbiAgZ2dzYXZlKHBhc3RlKCcuLi9SZXN1bHRfZmd1cmVzL3RtYi1yZXNwb25zZVZTJyxcbiAgICAgICAgICAgICAgIGltbXVuZV9mZWF0dXJlX29mX2ludGVyZXN0LFxuICAgICAgICAgICAgICAgY29uc2lkZXJfY2FuY2VyX3R5cGUsJ18nLFxuICAgICAgICAgICAgICAgcmVzcG9uc2VfdHlwZSwnLnBkZicsIHNlcCA9JycgKSxcbiAgICAgICAgIFBhbmVsMywgaGVpZ2h0PTUsIHdpZHRoID0gNSwgdW5pdHMgPSAnaW4nLCBkcGkgPSA1MDApXG4gICMgbGlzdChjb3JyZWxhdGlvbl9tYXRyaXgsIFBhbmVsMylcbn1cbmBgYCJ9 -->

```r
create_scatter_plot<- function(infunc_cancer_types=allcancer_types,
                               infunc_immune_matrix=immune_factor,
                               infun_Tmb_Resp_Association = OS_difference,
                               response_type='OS',
                               consider_cancer_type='all_cancerTypes', 
                               infunc_title='All cancerTypes',
                               immune_feature_of_interest= colnames(infunc_immune_matrix)[37]){
  df2plot=data.frame(infun_Tmb_Resp_Association[infunc_cancer_types,],
             features_resp= infunc_immune_matrix[infunc_cancer_types,immune_feature_of_interest])
  df2plot=na.omit(df2plot)
  Panel3 <- ggplot(df2plot, aes(x=rank(effect_size), y=rank(features_resp), size= -log(P, 10) )) + 
    stat_smooth(method='lm')+
    geom_point()+
    theme_bw(base_size = 15)+
    # theme(legend.position = 'none')+
    labs(x='Power of TMB (rank)',
         y=paste(gsub('\\.',' ',immune_feature_of_interest),  '(rank)'), size='-log10(P)')+
    stat_cor(label.y = 0, label.x = 5, method = 'p', cor.coef.name = 'rho', size=5)+
    geom_label_repel(aes(label=rownames(df2plot), size=0.5), show.legend = F)+
    coord_flip()
  ggsave(paste('../Result_fgures/tmb-responseVS',
               immune_feature_of_interest,
               consider_cancer_type,'_',
               response_type,'.pdf', sep ='' ),
         Panel3, height=5, width = 5, units = 'in', dpi = 500)
  # list(correlation_matrix, Panel3)
}
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Cmd+Option+I*.

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Cmd+Shift+K* to preview the HTML file). 

The preview shows you a rendered HTML copy of the contents of the editor. Consequently, unlike *Knit*, *Preview* does not run any R code chunks. Instead, the output of the chunk when it was last run in the editor is displayed.



<!-- rnb-text-end -->

