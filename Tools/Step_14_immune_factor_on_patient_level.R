## Step 14 Checking top immune factors in Liu et al, on patient level
#####
# libraries
#####
source('/Users/neelamf2/Downloads/Eytan/myCustom_functions.R')
setwd('/Users/neelamf2/Downloads/Eytan/fda-tmbCriteria-Power-vs-age-sex/Data/')
#############################
# Datasets and preprocessing
#############################
liu_demogrphics= read.csv('liu_demographics.csv', row.names = 1)
head(liu_demogrphics) 

liu_cybersort=data.frame(read_excel('Liu_cybersort_data.xlsx', sheet = 5))
rownames(liu_cybersort)= liu_cybersort$Patient
common_patients= intersect(rownames(liu_demogrphics), rownames(liu_cybersort))
# liu_cybersort[common_patients, 'T.cells.CD4.memory.resting']
liu_cybersort$T.cells.CD8
head(liu_cybersort)
liu_demogrphics= liu_demogrphics[common_patients,]

COI_liu= c("total_muts","OS","dead","PFS", "progressed","BR")
liu_demo=cbind(liu_demogrphics[,COI_liu],liu_cybersort[common_patients, 12:34])

table(liu_demo$BR)
liu_demo$BR=ifelse((liu_demo$BR == "CR" | liu_demo$BR == "PR"), 
       "R", 
       "NR")
liu_demo$TMB= liu_demo$total_muts/50
liu_demo$OS= liu_demo$OS/30
#####
#functions
#####
cox_by_TMB_and_immunefactor<-function(infunc_df= liu_demo,
                         infunc_immune_factor= "Neutrophils",
                         parts=2,
                         group=2){
  # infunc_df= infunc_df[!(infunc_df$CD4_memory_resting_TCell == 0),]
  
  infunc_df$group= xtile(infunc_df[,infunc_immune_factor], parts)
  
  infunc_df_tmb= infunc_df[order(infunc_df[,infunc_immune_factor], decreasing = T),]
  table(infunc_df_tmb$group)
  infunc_df_tmb= infunc_df[infunc_df$group == group,]
  model <- coxph(Surv(time = (OS),
                      event =dead) ~ (TMB >= 10)
                # + (tmb >= 10)* xtile(CD4_memory_resting_TCell,3)
                 , data = infunc_df_tmb)
  model_sum=summary(model)
  model_sum$coefficients[1,c(2, 5)]
}

cox_by_TMB_and_immunefactor_PFS<-function(infunc_df= liu_demo,
                                      infunc_immune_factor= "Neutrophils",
                                      parts=2,
                                      group=2){
  # infunc_df= infunc_df[!(infunc_df$CD4_memory_resting_TCell == 0),]
  
  infunc_df$group= xtile(infunc_df[,infunc_immune_factor], parts)
  
  infunc_df_tmb= infunc_df[order(infunc_df[,infunc_immune_factor], decreasing = T),]
  table(infunc_df_tmb$group)
  infunc_df_tmb= infunc_df[infunc_df$group == group,]
  model <- coxph(Surv(time = (PFS/30),
                      event = progressed) ~ (total_muts/50) >= 10
                 , data = infunc_df_tmb)
  model_sum=summary(model)
  model_sum$coefficients[1,c(2, 5)]
}

cox_by_TMB_and_immunefactor_ORR<-function(infunc_df= liu_demo,
                                          infunc_immune_factor= "T.cells.CD4.memory.resting",
                                          parts=2,
                                          group=2){
  # infunc_df= infunc_df[!(infunc_df$CD4_memory_resting_TCell == 0),]
  
  infunc_df$group= xtile(infunc_df[,infunc_immune_factor], parts)
  
  infunc_df_tmb= infunc_df[order(infunc_df[,infunc_immune_factor], decreasing = T),]
  table(infunc_df_tmb$group)
  infunc_df_tmb= infunc_df[infunc_df$group == group,]
  cont_matrix=aggregate(BR~ (total_muts/50) >=10, infunc_df_tmb, table)
  fisher_test_results_raw=fisher.test(as.matrix(cont_matrix)[,-1])
  # fisher_summary= summary(fisher_test_results_raw)
  c(pval = fisher_test_results_raw$p.value,
    fisher_test_results_raw$estimate)
}



immune_factors_of_interest= colnames(liu_demo[,7:28])
no_of_group= 2
#####
#HR RATIO when HR is calculated between OS AND TMB groups
#####

HR_results_all_immune_factors= lapply(immune_factors_of_interest,function (y) data.frame(do.call(rbind,
                                    (lapply(seq(no_of_group), function(x) 
                                      cox_by_TMB_and_immunefactor(liu_demo,y, no_of_group, x))))))
names(HR_results_all_immune_factors)= immune_factors_of_interest

HR_ratio_df= data.frame(row.names = immune_factors_of_interest,
                        HR_Ratio= do.call(rbind,lapply(immune_factors_of_interest, function (x)
              ratio=HR_results_all_immune_factors[[x]]$exp.coef.[2]/ HR_results_all_immune_factors[[x]]$exp.coef.[1]
            )))

HR_ratio_df$rank=NA
HR_ratio_df=HR_ratio_df[order(HR_ratio_df$HR_Ratio, decreasing = F),]
HR_ratio_df$rank= seq(1,22)
HR_ratio_df
#write.csv(HR_ratio_df, file = 'HR_Ratio_mat.csv')

######
#HR RATIO when HR is calculated between PFS AND TMB groups
#####
HR_results_all_immune_factors_with_PFS= lapply(immune_factors_of_interest,function (y) 
                                        data.frame(do.call(rbind,(lapply(seq(no_of_group), function(x) 
                                        cox_by_TMB_and_immunefactor_PFS(liu_demo,y, no_of_group, x))))))
names(HR_results_all_immune_factors_with_PFS)= immune_factors_of_interest

HR_ratio_df_PFS= data.frame(row.names = immune_factors_of_interest, 
                            HR_Ratio= do.call(rbind,lapply(immune_factors_of_interest, function (x)
          HR_results_all_immune_factors_with_PFS[[x]]$exp.coef.[2]/ HR_results_all_immune_factors_with_PFS[[x]]$exp.coef.[1]
)))

HR_ratio_df_PFS$rank=NA
HR_ratio_df_PFS=HR_ratio_df_PFS[order(HR_ratio_df_PFS$HR_Ratio, decreasing = F),]
HR_ratio_df_PFS$rank= seq(1,22)
HR_ratio_df_PFS 
#write.csv(HR_ratio_df_PFS, file = 'HR_Ratio_PFS_mat.csv')
######
#HR RATIO when HR is calculated between ORR AND TMB groups
######
HR_results_all_immune_factors_with_OR= lapply(immune_factors_of_interest,
                                              function (y) data.frame(do.call(rbind, lapply(seq(no_of_group), 
                                             function(x) cox_by_TMB_and_immunefactor_ORR(liu_demo,y, no_of_group, x)))))
names(HR_results_all_immune_factors_with_OR)= immune_factors_of_interest

HR_ratio_df_OR= data.frame(row.names = immune_factors_of_interest, 
                          ORR_Ratio= do.call(rbind, lapply(immune_factors_of_interest, function (x)
  HR_results_all_immune_factors_with_OR[[x]]$odds.ratio[2]/ HR_results_all_immune_factors_with_OR[[x]]$odds.ratio[1])))
# HR_results_all_immune_factors_with_OR[['Neutrophils']]$odds.ratio[2]

HR_ratio_df_OR$rank=NA
HR_ratio_df_OR=HR_ratio_df_OR[order(HR_ratio_df_OR$ORR_Ratio, decreasing = T),]
HR_ratio_df_OR$rank= seq(1,22)
HR_ratio_df_OR
#write.csv(HR_ratio_df_OR, file = 'HR_ratio_df_OR.csv')

#########################################
#Plotting
#########################################
