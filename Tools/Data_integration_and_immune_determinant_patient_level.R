############################
# test immune determeinants to patient level
############################

############################
#library
############################
# 
# if (!requireNamespace('BiocManager', quietly = TRUE))
#   install.packages('BiocManager')
# 
# BiocManager::install('EnhancedVolcano')
library(EnhancedVolcano)

require("survival")
library(readxl)
require(scran)
library(dplyr)
library(statar)
require("survminer")
source('/Users/neelamf2/Downloads/Eytan/myCustom_functions.R')
setwd('/Users/neelamf2/Downloads/Eytan/fda-tmbCriteria-Power-vs-age-sex/Data/')

############################
# Datasets and Preprocessing
############################
## CPI 1000 response data
cpi1000_res= read.csv('Data_for_immune_determinants/cpi1000_response_labels.csv')
dim(cpi1000_res)
table(cpi1000_res$Study)

## Ploidy of 984 patients
ploidy= read.csv('Data_for_immune_determinants/PLoidy_data.csv')
head(ploidy)

## immune cells/ modulators expression in 564 patients 
signature_data= read.csv('Data_for_immune_determinants/CPI_danaher_signatures.txt', 
                         sep = '\t')
colnames(signature_data)[1]= c("Patient") ## rename Samples column to Patient to have unique colname
head(signature_data)

## metaanalysis of 1008 patients with TMB, immune cell, sex etc.
meta_analysis= read.csv('Data_for_immune_determinants/meta_analysis_input_data.txt', 
                         sep = '\t')
colnames(meta_analysis)[1]= c("Patient") ## rename "case" column to "Patient" to have unique colname
head(meta_analysis)
## Sanity check as all columns were NA other than last few columns
# li= c("U_MAR10362","U_MAR10374","U_MCD20622842683425", "U_MCD257224995390969","V_MSK389","V_MSK499")
# meta_analysis[meta_analysis$Patient %in% li,]
# intersect(cpi1000_res$Patient,signature_data$Patient)


############################
# integrating the 4 datasets
############################
## five modulators : CD274(PDL1), M1 macrophages, tumor purity, active and resting dendrtic celss
## library dplr to use Join we can also use merge function from library data.table

integrated_cpi1000_with_all_var= full_join(full_join(full_join(cpi1000_res, signature_data, by="Patient"),
                                                     ploidy, by= 'Patient'),
                                           meta_analysis, by= 'Patient')
dim(integrated_cpi1000_with_all_var)
table(integrated_cpi1000_with_all_var$Study)
sum(is.na(integrated_cpi1000_with_all_var))
########################################################
# Scaling the datasets by Study type
########################################################
scaling_by_cohort<- function(infunc_df=integrated_cpi1000_with_all_var,
                             study= "SNYDER_NEJM_2014"){
  new_df= infunc_df[(infunc_df$Study== study) & !is.na(infunc_df$Study),]
  # column wise scaling
  cols_numeric=colnames(new_df[,sapply(new_df, class) == 'numeric' | 
                                 sapply(new_df, class) == 'integer'])
  new_df[,c(cols_numeric[4:36], cols_numeric[42:55])] = scale(new_df[,c(cols_numeric[4:36], 
                                                                        cols_numeric[42:55])],
                                                              center= T, 
                                                              scale = T)
  new_df
}

cohorts_name= unique(integrated_cpi1000_with_all_var$Study)[1:11]

Scaled_df_cohort=do.call(rbind, lapply(cohorts_name, function (x) scaling_by_cohort(infunc_df=integrated_cpi1000_with_all_var,
                                                    study= x)))

####################################################################################
# Functions: To see which modulator affects the Association between TMB and survial(OS)
####################################################################################

cox_by_TMB_and_modulators <-function(infunc_df= integrated_cpi1000_with_all_var,
                                   var_2= "master_purity_R1"){
  new_df = infunc_df[,c('TMB',
                        'OS_time_months',
                        'OS_censor',
                        'study',
                        var_2,
                        "histology")]
  colnames(new_df)[5]='modulator'
  new_df=na.omit(new_df)
  # table(new_df$histology)
  # new_df = new_df[!is.na(new_df[,5]),]
  # new_df= new_df[!is.na(new_df$OS_time_months), ]
  # new_df= new_df[!is.na(new_df$TMB),]
  new_df$OS_time_months= as.numeric(new_df$OS_time_months)
  model1 <- coxph(Surv(time = OS_time_months,
                       event = OS_censor) ~ (TMB >= 10) + modulator + study
                    + ((TMB >= 10)*(modulator)),
                  data = new_df)
  model_sum=summary(model1)
  err_handle(model_sum$coefficients[grep('TMB >= 10TRUE:modulator',rownames(model_sum$coefficients)),
                                    c(2,5)])
}

modulators_of_interest=c(colnames(melanoma_data)[c(19, 21, 45, 80)])

cox_result_all_modulators= data.frame(row.names = colnames(integrated_cpi1000_with_all_var)[14:80], 
                                      do.call(rbind, lapply(seq(14,80), 
                                     function (x) err_handle(cox_by_TMB_and_modulators(integrated_cpi1000_with_all_var,
                                                           var_2 = colnames(integrated_cpi1000_with_all_var)[x]))
                                      )))

cox_result_all_modulators_melanama= data.frame(row.names = modulators_of_interest,
                                               do.call(rbind, lapply(c(19, 21, 45, 80), 
                                                 function (x) err_handle(cox_by_TMB_and_modulators(melanoma_data,
                                                            var_2 = colnames(melanoma_data)[x]))
                                      )))
cox_result_all_modulators= data.frame(row.names = modulators_of_interest,
                                      do.call(rbind, lapply(c(19, 21, 45, 80), 
                                      function (x) cox_by_TMB_and_modulators(integrated_cpi1000_with_all_var,
                                      var_2 = colnames(integrated_cpi1000_with_all_var)[x]))))


####################################################################################
# Functions: To see which modulator affects the Association between TMB and survial(ORR)
####################################################################################
lm_by_TMB_and_ORR_with_modulator <-function(infunc_df= integrated_cpi1000_with_all_var,
                                     var_2= "master_purity_R1"){
  new_df = infunc_df[,c('TMB',
                        'Response_responder',
                        'Response_RECIST',
                        'study',
                        var_2,
                        "histology")]
  colnames(new_df)[5]='modulator'
  colnames(new_df)[2]='Best_response'
  
  new_df=na.omit(new_df)
  new_df$Best_response= ifelse(new_df$Best_response == "response", 1,0)
  dim(new_df)
  
  lm_model= lm(Best_response ~ (TMB >= 10) + modulator + study + ((TMB >=10) * modulator), data= new_df)
  lm_model_sum=summary(lm_model)
  lm_model_sum$coefficients[grep('TMB >= 10TRUE:modulator',rownames(lm_model_sum$coefficients)), c(1,4)]
  
  # cont_matrix=aggregate(Best_response ~ (TMB >=10) * (modulator), new_df, table)
  # fisher_test_results_raw=fisher.test(as.matrix(cont_matrix)[,-1])
  # c(pval = fisher_test_results_raw$p.value,
  #   fisher_test_results_raw$estimate)
}


lm_result_all_modulators= data.frame(row.names = colnames(integrated_cpi1000_with_all_var)[14:80], 
                                      do.call(rbind, lapply(seq(14,80), 
                                    function (x) err_handle(lm_by_TMB_and_ORR_with_modulator(integrated_cpi1000_with_all_var,
                                                            var_2 = colnames(integrated_cpi1000_with_all_var)[x]))
                                      )))

########################################################
#function for Sanity Check
########################################################
table( integrated_cpi1000_with_all_var$Tum_Type
      )
cox_by_TMB_sanity_check<-function(infunc_df= integrated_cpi1000_with_all_var,
                                      infunc_immune_factor= "Signature.7",
                                      parts=2,
                                      group=2){
  new_df = infunc_df[,c('TMB', 'OS_time_months', 'OS_censor',
                        'study', infunc_immune_factor,
                        "histology")]
  new_df= na.omit(new_df)
  new_df$OS_time_months= as.numeric(new_df$OS_time_months)
  new_df$group= xtile(new_df[,infunc_immune_factor], parts)
  
  new_df_tmb= new_df[order(new_df[,infunc_immune_factor], decreasing = T),]
  new_df_tmb= new_df[new_df$group == group,]
  model <- coxph(Surv(time = OS_time_months,
                      event = OS_censor) ~ (TMB >= 10) + study+ histology
                 , data = new_df_tmb)
  model_sum=summary(model)
  model_sum$coefficients["TMB >= 10TRUE",c(2, 5)]
}

no_of_group= 2
immune_factors_of_interest= colnames(melanoma_data)[14:80]
  #c('dend.score.danaher', 'master_purity_R1', "macrophage.score.danaher", "CD274")

Hr_result_two_group=lapply(immune_factors_of_interest,function (y) data.frame(do.call(rbind,
                                   (lapply(seq(no_of_group), function(x) 
                                    err_handle(cox_by_TMB_sanity_check(infunc_df = integrated_cpi1000_with_all_var,
                                                            infunc_immune_factor = y,
                                                            parts = no_of_group,
                                                            group = x)))))))
names(Hr_result_two_group) = immune_factors_of_interest
Hr_result_two_group_df=data.frame(t(sapply(Hr_result_two_group, function(x) x[,1])))



Continous_vs_distinct=data.frame(from_quantiled=Hr_result_two_group_df,
  from_cont=cox_result_all_modulators[
  match(rownames(Hr_result_two_group_df), rownames(cox_result_all_modulators)),1])
Continous_vs_distinct$direction=Continous_vs_distinct$from_quantiled.X1 > Continous_vs_distinct$from_quantiled.X2
ggplot(Continous_vs_distinct, aes(x=direction, y=from_cont))+
  geom_point()
####################################################################################
# Figures : Volcano Plot (OS and ORR)
####################################################################################
df_plot= cox_result_all_modulators
df_plot[order(df_plot[,1]),]
EnhancedVolcano(df_plot,
                lab = rownames(df_plot),
                x= "exp.coef.",
                y= 'Pr...z..',
                pCutoff = 0.1,
                pointSize = 3.0,
                labSize = 3.0)

#### volcano plot for ORR
df_plot= lm_result_all_modulators
df_plot[order(df_plot[,2]),]
EnhancedVolcano(df_plot,
                lab = rownames(df_plot),
                x = 'Estimate',
                y = 'Pr...t..',
                pCutoff = 0.1,
                pointSize = 3.0,
                labSize = 3.0)

#########################
#  Extra : testing snippet for integrating data
########################
a <- data.frame(id=letters[1:4], age=c(18,NA,9,NA), sex=c("M","F","F","M"))
row.names(a)= a$id
b <- data.frame(id=c("a","b","d","e"), sal=c(18000,32000,20000,17000))
row.names(b)= b$id
c <- data.frame(id=c("a","b","d"), number=c(1,2,3))
row.names(c)= c$id
cbind(a,b)

full_join((full_join(a,b, by="id")),c, by= 'id')

### in merge function we can do join using "all" argument
merge((merge(a,b, by="id", all= TRUE)),c, by= 'id', all= TRUE) 