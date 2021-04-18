#### Association of other immune factors on TMB ####
######
#libraries#
#####
library(caret)
source('/Users/neelamf2/Downloads/Eytan/myCustom_functions.R')
setwd('/Users/neelamf2/Downloads/Eytan/fda-tmbCriteria-Power-vs-age-sex/Data/')

#####
# Dataset and preprocessing#
#####
immune_factor= read.csv("immune_factors_response_joo.csv", row.names = 1)
colnames(immune_factor)
f1=18/(18+31)
f2=1-f1
immune_factor$COAD= sapply(seq(1:nrow(immune_factor)), function (x) 
  (immune_factor[x,'COAD_MSI']* f1 + immune_factor[x,'COAD_MSS']* f2))

immune_factor$NSCLC= sapply(seq(1:nrow(immune_factor)), function (x) 
  (immune_factor[x,'LUAD']* 0.5 + immune_factor[x,'LUAD']* 0.5))

immune_factor= t(immune_factor)
#####
# Combined dataset of mskcc and Valero
#####
mskcc_combined= rbind(data.frame(ID= mskcc_sup_no_overlap$Sample.ID,
                                             Age= mskcc_sup_no_overlap$Age_decade,
                                             Cancer_Type= mskcc_sup_no_overlap$Cancer.Type,
                                             Sex= mskcc_sup_no_overlap$GENDER,
                                             TMB= mskcc_sup_no_overlap$TMB,
                                             drug= mskcc_sup_no_overlap$Drug_class,
                                             MSI= NA,
                                             year_in_ici= mskcc_sup_no_overlap$Imm_yearbin,
                                             Overall_survival_status= mskcc_sup_no_overlap$SURVIVAL_EVENT,
                                             Overall_survival_months= mskcc_sup_no_overlap$SURVIVAL_MONTHS), 
                                  data.frame(ID= Valero_ICI_pd1$ID,
                                             Age= Valero_ICI_pd1$Age.at.ICI.start,
                                             Cancer_Type= Valero_ICI_pd1$Cancer.type,
                                             Sex= Valero_ICI_pd1$Sex,
                                             TMB= Valero_ICI_pd1$TMB,
                                             drug= Valero_ICI_pd1$ICI.drug.class,
                                             MSI= Valero_ICI_pd1$MSI.type,
                                             year_in_ici= Valero_ICI_pd1$Year.of.ICI.treatment.start,
                                             Overall_survival_status= Valero_ICI_pd1$Overall_survival_status,
                                             Overall_survival_months= Valero_ICI_pd1$Overall_survival_months))
#####
(mskcc_combined[mskcc_combined$Cancer_Type== "Colorectal",])
table(mskcc_combined$Cancer_Type)
sum((mskcc_combined$Cancer_Type == "Colorectal") & (mskcc_combined$MSI == "Unstable"), na.rm = T)
sum((mskcc_combined$Cancer_Type == "Colorectal") & (mskcc_combined$MSI == "Stable"), na.rm = T)

mskcc_combined$Cancer_Type_acronym=NA
mskcc_combined$Cancer_Type=factor(mskcc_combined$Cancer_Type)
mskcc_combined$Cancer_Type_acronym=mskcc_combined$Cancer_Type
levels(mskcc_combined$Cancer_Type_acronym)=c('BLCA', 'BRCA','COAD', 'UCEC', 'ESCA', 'STAD',
                                             'GBM', 'HNSC', 'LIHC', 'SKCM', 'MESO','NSCLC',
                                             'OV', 'PAAD', 'KIRC', 'SARC', 'SCLC', 'Unknown-Primary')

######
  
samples_by_cancer_type = aggregate(ID ~ Cancer_Type,mskcc_combined, length)
cancerTypes_of_Interest = samples_by_cancer_type[,1][samples_by_cancer_type[,2]> 1]

##### 
# function for cox regression for survival vs TMB
#####
cox_by_cancer_type_and_TMB<-function(infunc_df= mskcc_combined, 
                                            COI='Renal'){
  infunc_df_tmb=infunc_df[((infunc_df$Cancer_Type == COI)),]
  infunc_df_tmb= infunc_df_tmb[!is.na(infunc_df_tmb$Overall_survival_months),]
  model <- coxph(Surv(time = Overall_survival_months,
                      event = Overall_survival_status) ~ (TMB>=10) ,
                 data = infunc_df_tmb)
  model_sum=summary(model)
  # model_sum$coefficients[1,c(2, 5)]
  cbind(model_sum$coef,model_sum$conf.int)
}

cox_results_of_TMB= data.frame(row.names = cancerTypes_of_Interset,
                                          do.call(rbind, lapply(cancerTypes_of_Interset, function(x) 
                                          (cox_by_cancer_type_and_TMB(infunc_df = mskcc_combined, COI = x)))))

cox_results_of_TMB$cancer_acorymn= c('BLCA', 'BRCA','COAD', 'UCEC', 'ESCA', 'STAD',
                                     'GBM', 'HNSC', 'LIHC', 'SKCM', 'MESO','NSCLC',
                                     'OV', 'PAAD', 'KIRC', 'SARC', 'SCLC', 'Unknown-Primary')

colnames(cox_results_of_TMB)[c(1,2)]= c("HR", "P")
cox_results_of_TMB

# rownames(cox_results_of_TMB)= cox_results_of_TMB$cancer_acorymn
# dim(cox_results_of_TMB)
# cox_results_of_TMB= na.omit(cox_results_of_TMB[-15,-3])

## putting condition on selection of cancertype
cancertype_less_50 = samples_by_cancer_type[,1][samples_by_cancer_type[,2]> 50]
cox_results_of_TMB_sig = na.omit(cox_results_of_TMB[((cox_results_of_TMB$P <= 0.05 ) |
                                           (rownames(cox_results_of_TMB) %in% cancertype_less_50)),])

rownames(cox_results_of_TMB_sig)= cox_results_of_TMB_sig$cancer_acorymn
dim(cox_results_of_TMB_sig)
cox_results_of_TMB_sig= cox_results_of_TMB_sig[-12,-3]

#####
#####
#Correlation 
#####
cancer_of_interest = intersect(rownames(immune_factor), rownames(cox_results_of_TMB_sig))
cancer_of_interest=cancer_of_interest[!(cancer_of_interest %in% 'PAAD')]
immune_factors_with_HR= data.frame(cox_results_of_TMB_sig[cancer_of_interest,],
                                   immune_factor[cancer_of_interest,])

# significant_associted_cancer_Types=which(immune_factors_with_HR$P<0.05)
# immune_factors_with_HR=immune_factors_with_HR[significant_associted_cancer_Types,]
target= immune_factors_with_HR[,"HR"]
features= immune_factors_with_HR[ ,3:41]
immune_factors_with_HR$cancer_name=rownames(immune_factors_with_HR)

ggplot(immune_factors_with_HR, aes(x=HR, y=CD4..resting.T.cells., label=cancer_name))+
  geom_point()+
  stat_smooth(method='lm')+
  geom_label()

correlation_with_hr= data.frame(t(apply(features, 2, function(x) unlist(cor.test(x, target)[c(3, 4)]))))
rownames(correlation_with_hr) = colnames(immune_factor)

correlation_with_hr=na.omit(correlation_with_hr[order(abs(correlation_with_hr[,2]), decreasing = T),])
correlation_with_hr[order(abs(correlation_with_hr$estimate.cor),decreasing = T),]

##### 
# Bar plot for correlation
#####
correlation_with_hr$immune_factors = factor(rownames(correlation_with_hr), 
                                      levels = rownames(correlation_with_hr)[order(correlation_with_hr$estimate.cor, 
                                                                                   decreasing = F)])
colnames(correlation_with_hr)[c(1,2)]= c("P","correlation")
tiff('/Users/neelamf2/Downloads/Eytan/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/Results_Figures/fig_2_Barplot_immune_factors.tiff',
     width =650, height=950)
OS_plot=ggplot(data=correlation_with_hr, aes(x=immune_factors, y=correlation, color = P< 0.05))+
  geom_bar(stat="identity", fill="white")+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = ifelse( correlation< 0, 0.01, -0.01), label = immune_factors, 
                hjust = as.numeric(correlation > 0)), color= "black") +  # label text based on value
  theme_classic2(base_size = 20)+
  theme(axis.text.y = element_blank())+
  scale_color_manual(values=c("grey", "blue"))+ 
  # ggtitle("Strength of Immune factors for association of OS and TMB")+
  theme(plot.title = element_text(size=15))
  
dev.off()
#####
#####
# linear regression
#####
FOI=rownames(correlation_with_hr[order(abs(correlation_with_hr[,2]), decreasing = T),])[1:10]

fitControl <- trainControl(method = "LOOCV")

model.cv <- train(HR ~ .,
                  data = immune_factors_with_HR[,c(FOI,"HR")],
                  method = "glmnet",
                  trControl = fitControl,
                  keepX= T)  
model.cv


cor.test(model.cv$pred$pred, model.cv$pred$obs)

