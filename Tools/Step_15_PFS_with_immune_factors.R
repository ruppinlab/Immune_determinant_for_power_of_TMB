##### PFS with immune factor correaltion
colnames(immune_factor)[grep('resting',colnames(immune_factor))]='CD4 Memory cells'
################################################################################
# Step 1: Load & Preprocess #### repeat step from code of step 10 in case of confusion
################################################################################

samples_each_cancer_type=aggregate(ID ~ Cancer.type, Valero_ICI_pd1, length)
cancerTypes_of_Interest_PFS=samples_each_cancer_type[,1][samples_each_cancer_type[,2]>1]

cox_by_cancer_type_PFS<-function(infunc_df=Valero_ICI_pd1, COI= "Sarcoma"){
  infunc_df_tmb=infunc_df[((infunc_df$Cancer_Type == COI)),]
  
  infunc_df_tmb= infunc_df_tmb[!is.na(infunc_df_tmb$Overall_survival_months),]
  dim(infunc_df_tmb)
  model <- coxph(Surv(PFS_months,
                      PFS_status) ~ (TMB >=10),
                 data = infunc_df_tmb)
  model_sum=summary(model)
  # model_sum$coefficients[c(2, 5)]
  cbind(model_sum$coef,model_sum$conf.int)
}


PFS_result_with_TMB = data.frame(row.names = cancerTypes_of_Interest,
                               do.call(rbind, lapply(cancerTypes_of_Interest, function(x) 
                                 (cox_by_cancer_type_PFS(infunc_df = mskcc_combined, COI = x)))))
PFS_result_with_TMB$cancer_acorymn= c('BLCA', 'BRCA','COAD', 'UCEC', 'ESCA', 'STAD',
                                     'GBM', 'HNSC', 'LIHC', 'SKCM', 'MESO','NSCLC',
                                     'OV', 'PAAD', 'KIRC', 'SARC', 'SCLC', 'Unknown-Primary')



PFS_result_with_TMB=na.omit(PFS_result_with_TMB)
colnames(PFS_result_with_TMB)[c(1,2)]= c("HR", "P")
cancertype_less_50 = samples_each_cancer_type[,1][samples_each_cancer_type[,2]>50]
PFS_result_with_TMB = na.omit(PFS_result_with_TMB[((rownames(PFS_result_with_TMB) %in% cancertype_less_50)),])
rownames(PFS_result_with_TMB) = PFS_result_with_TMB$cancer_acorymn
PFS_result_with_TMB= PFS_result_with_TMB[PFS_result_with_TMB$cancer_acorymn!='KIRC',]
PFS_result_with_TMB=PFS_result_with_TMB[,-3]
################################################################################
# Step 2: Considering all cancer types
################################################################################
cancer_of_interest = intersect(rownames(immune_factor), rownames(PFS_result_with_TMB))
immune_factors_with_PFS_HR= data.frame(PFS_result_with_TMB[cancer_of_interest,],
                                       immune_factor[cancer_of_interest,])

target_PFS= immune_factors_with_PFS_HR[,"HR"]
features_PFS= immune_factors_with_PFS_HR[ ,-(1:2)]
correlation_with_PFS_hr= data.frame(t(apply(features_PFS, 2, function(x)
  unlist(cor.test(x, target_PFS, method = 'spearman')[c(3, 4)]))))
correlation_with_PFS_hr=na.omit(correlation_with_PFS_hr[order(abs(correlation_with_PFS_hr[,2]), decreasing = T),])
correlation_with_PFS_hr[order(abs(correlation_with_PFS_hr[,2]), decreasing = T),]
correlation_with_PFS_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_PFS_hr)))
Panel2 <- ggplot(data=correlation_with_PFS_hr, aes(x=reorder(immune_factors, estimate.rho),
                                               y=estimate.rho,
                                               color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 15)+
  theme(axis.text.y = element_blank())+
  scale_color_manual(values = c('grey', 'blue'))
Panel3 <- ggplot(data=immune_factors_with_PFS_HR, aes(x=IFNg.signature.,
                                                  y=HR,
                                                  label=cancer_name))+
  theme_bw(base_size = 15)+
  geom_label()+
  geom_point()+
  stat_smooth(method='lm')
Panel2
################################################################################
# Step 3: Considering sig cancer types only # Six cancer TYpes
################################################################################
cancer_of_interest = intersect(rownames(immune_factor), rownames(PFS_result_with_TMB))
cancer_of_interest_sig=cancer_of_interest[which(PFS_result_with_TMB[cancer_of_interest,]$P/2 <0.1)]
immune_factors_with_PFS_HR= data.frame(PFS_result_with_TMB[cancer_of_interest_sig,],
                                       immune_factor[cancer_of_interest_sig,])
# New features:: Ratio of top features
# immune_factors_with_PFS_HR$Neutro_by_CD4_memory=immune_factors_with_PFS_HR$Neutrophills./immune_factors_with_PFS_HR$CD4.Memory.cells
# immune_factors_with_PFS_HR$Neutro_by_CD4_memory_norm=(1+immune_factors_with_PFS_HR$Neutrophills.)/immune_factors_with_PFS_HR$CD4.Memory.cells

target_PFS= immune_factors_with_PFS_HR[,"HR"]
features_PFS= immune_factors_with_PFS_HR[ ,-(1:2)]
correlation_with_PFS_hr= data.frame(t(apply(features_PFS, 2, function(x)
  unlist(cor.test(x, target_PFS, method = 'spearman')[c(3, 4)]))))
correlation_with_PFS_hr=na.omit(correlation_with_PFS_hr[order(abs(correlation_with_PFS_hr[,2]), decreasing = T),])
correlation_with_PFS_hr[order(abs(correlation_with_PFS_hr[,2]), decreasing = T),]
correlation_with_PFS_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_PFS_hr)))
Panel2 <- ggplot(data=correlation_with_PFS_hr, aes(x=reorder(immune_factors, estimate.rho),
                                                   y=estimate.rho,
                                                   color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 15)+
  theme(axis.text.y = element_blank())+
  scale_color_manual(values = c('grey', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')
Panel3 <- ggplot(data=immune_factors_with_PFS_HR, aes(x=IFNg.signature.,
                                                      y=HR,
                                                      label=cancer_name))+
  theme_bw(base_size = 15)+
  geom_label()+
  geom_point()+
  stat_smooth(method='lm')
Panel2
################################################################################
# Step 4: Add top features ratios
################################################################################
cancer_of_interest = intersect(rownames(immune_factor), rownames(PFS_result_with_TMB))
cancer_of_interest_sig=cancer_of_interest[which(PFS_result_with_TMB[cancer_of_interest,]$P/2 <0.1)]
immune_factors_with_PFS_HR= data.frame(PFS_result_with_TMB[cancer_of_interest_sig,],
                                       immune_factor[cancer_of_interest_sig,])
# New features:: Ratio of top features
immune_factors_with_PFS_HR$Neutro_by_CD4_memory=immune_factors_with_PFS_HR$Neutrophills./immune_factors_with_PFS_HR$CD4.Memory.cells
immune_factors_with_PFS_HR$Neutro_by_CD4_memory_norm=(1+immune_factors_with_PFS_HR$Neutrophills.)/immune_factors_with_PFS_HR$CD4.Memory.cells

target_PFS= immune_factors_with_PFS_HR[,"HR"]
features_PFS= immune_factors_with_PFS_HR[ ,-(1:2)]
correlation_with_PFS_hr= data.frame(t(apply(features_PFS, 2, function(x)
  unlist(cor.test(x, target_PFS, method = 'spearman')[c(3, 4)]))))
correlation_with_PFS_hr=na.omit(correlation_with_PFS_hr[order(abs(correlation_with_PFS_hr[,2]), decreasing = T),])
correlation_with_PFS_hr[order(abs(correlation_with_PFS_hr[,2]), decreasing = T),]
correlation_with_PFS_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_PFS_hr)))
Panel2 <- ggplot(data=correlation_with_PFS_hr, aes(x=reorder(immune_factors, estimate.rho),
                                                   y=estimate.rho,
                                                   color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 15)+
  theme(axis.text.y = element_blank())+
  scale_color_manual(values = c('grey', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')
Panel3 <- ggplot(data=immune_factors_with_PFS_HR, aes(x=IFNg.signature.,
                                                      y=HR,
                                                      label=cancer_name))+
  theme_bw(base_size = 15)+
  geom_label()+
  geom_point()+
  stat_smooth(method='lm')
Panel2
immune_factor=data.frame(immune_factor)

summary(lm(immune_factor$ORR. ~
             immune_factor$Mutational.Burden.*immune_factor$Neutrophills.))

model <- lm(immune_factor$ORR. ~
              immune_factor$Mutational.Burden.+immune_factor$CD8..T.cells.)
model1 <- lm(immune_factor$ORR. ~
               immune_factor$Mutational.Burden.+immune_factor$CD8..T.cells.+
               immune_factor$Mutational.Burden.*immune_factor$CD8..T.cells.)
diff_model=anova(model, model1)
diff_model$`Pr(>F)`[2]

sort(apply(immune_factor[,colnames(immune_factor) %!in% c('ORR.', 'Mutational.Burden.')],
      2, function(x) summary(lm(immune_factor$ORR. ~
             immune_factor$Mutational.Burden.*x))$coefficients[,4][4]))

cor.test(immune_factor$ORR.[xtile(immune_factor$Neutrophills., 2)==1],
             immune_factor$Mutational.Burden.[xtile(immune_factor$Neutrophills., 2)==1],
         method='spearman')
cor.test(immune_factor$ORR.[xtile(immune_factor$Neutrophills., 2)==2],
         immune_factor$Mutational.Burden.[xtile(immune_factor$Neutrophills., 2)==2],
         method='spearman')
################################################################################
# Only Chart for Immune abundances
################################################################################
cancer_of_interest = intersect(rownames(Immune_Cell_abundance), rownames(PFS_result_with_TMB))
cancer_of_interest_sig=cancer_of_interest[which(PFS_result_with_TMB[cancer_of_interest,-3]$P/2 < 0.1)]
immune_factors_with_resp_HR= data.frame(PFS_result_with_TMB[cancer_of_interest_sig,-3],
                                        Immune_Cell_abundance[cancer_of_interest_sig,])
# # # New features:: Ratio of top features
immune_factors_with_resp_HR$NTL=immune_factors_with_resp_HR$Neutrophils/immune_factors_with_resp_HR$Lymphocytes
immune_factors_with_resp_HR$NT_CD8=immune_factors_with_resp_HR$Neutrophils/(immune_factors_with_resp_HR$T.Cells.CD8)
immune_factors_with_resp_HR$NT_CD_gamma=immune_factors_with_resp_HR$Neutrophils/(immune_factors_with_resp_HR$T.Cells.gamma.delta)
target_resp= immune_factors_with_resp_HR[,1]
features_resp= immune_factors_with_resp_HR[,-(1:2)]

correlation_with_resp_hr= data.frame(t(apply(features_resp, 2, function(x)
  unlist(cor.test(x, target_resp, method = 's')[c(3, 4)]))))
correlation_with_resp_hr=na.omit(correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]),
                                                                decreasing = T),])
# correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]), decreasing = T),]
correlation_with_resp_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_resp_hr)))

Panel2 <- ggplot(data=correlation_with_resp_hr, aes(x=reorder(immune_factors, estimate.rho),
                                                    y=estimate.rho,
                                                    color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 20)+
  theme(axis.text.y = element_blank(), legend.position="top")+
  scale_color_manual(values = c('grey', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure1C_byPFS.tiff',
     height=700, width = 500)
Panel2
dev.off()

################################################################################
# Immune-signature abundance
################################################################################
cancer_of_interest = intersect(rownames(Immune_Signature_abundance), rownames(PFS_result_with_TMB))
cancer_of_interest= cancer_of_interest[!(cancer_of_interest %in% "COAD")] ## results are driven by colerectal
cancer_of_interest_sig=cancer_of_interest[which(PFS_result_with_TMB[cancer_of_interest,-3]$P/2 < 0.1)]
immune_factors_with_resp_HR= data.frame(PFS_result_with_TMB[cancer_of_interest_sig,-3],
                                        Immune_Signature_abundance[cancer_of_interest_sig,])
# # # New features:: Ratio of top features
# immune_factors_with_resp_HR$NTL=immune_factors_with_resp_HR$Neutrophils/immune_factors_with_resp_HR$Lymphocytes
# immune_factors_with_resp_HR$NT_CD8=immune_factors_with_resp_HR$Neutrophils/(immune_factors_with_resp_HR$T.Cells.CD8)
# immune_factors_with_resp_HR$NT_CD_gamma=immune_factors_with_resp_HR$Neutrophils/(immune_factors_with_resp_HR$T.Cells.gamma.delta)
target_resp= immune_factors_with_resp_HR[,1]
features_resp= immune_factors_with_resp_HR[,-(1:2)]

correlation_with_resp_hr= data.frame(t(apply(features_resp, 2, function(x)
  unlist(cor.test(x, target_resp, method = 's')[c(3, 4)]))))
correlation_with_resp_hr=na.omit(correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]),
                                                                decreasing = T),])
correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]), decreasing = T),]
correlation_with_resp_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_resp_hr)))


Panel2 <- ggplot(data=correlation_with_resp_hr, aes(x=reorder(immune_factors, estimate.rho),
                                                    y=estimate.rho,
                                                    color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 20)+
  theme(axis.text.y = element_blank(), legend.position="top")+
  scale_color_manual(values = c('grey', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')+
  ylim(... = c(-0.45, 1.1))
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure2C_byPFS.tiff', height=300, width = 600)
Panel2
dev.off()

