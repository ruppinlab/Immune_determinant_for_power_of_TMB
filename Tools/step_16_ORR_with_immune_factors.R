################################################################################
# Step 0: Preprocess Immune factors
################################################################################
##### Response rate with immune factors
cor.test(immune_factor$lymphocytes_not_Scaled,
         immune_factor$CD8..T.cells.)
immune_factor=immune_factor[,!grepl('purity',colnames(immune_factor))]
immune_factor$lymphocytes_not_Scaled=rowMeans(apply(immune_factor[,colnames(immune_factor) %in% c('B.cell.naïve.', 'B.cell.memory.', 'Plasma.cells.', 'CD8..T.cells.', 'CD4..naïve.T.cells.',
                                                                                                  'CD4.Memory.cells', 'CD4..active.T.cells.', 'CD4..helper.T.cells.', 'T.regs.', 'T.cell.gamma.delta.',
                                                                                                  'Resting.NK.cells.', 'Active.NK.cells.')],
                                                    2, function(x) scale(x)), na.rm = T)

immune_factor$lymphocytes_not_Scaled=rowMeans(apply(immune_factor[,colnames(immune_factor) %in% c('B.cell.naïve.', 'B.cell.memory.', 'Plasma.cells.', 'CD8..T.cells.', 'CD4..naïve.T.cells.',
                                                                                                  'CD4.Memory.cells', 'CD4..active.T.cells.', 'CD4..helper.T.cells.', 'T.regs.', 'T.cell.gamma.delta.',
                                                                                                  'Resting.NK.cells.', 'Active.NK.cells.')],
                                                    2, function(x) x), na.rm = T)
immune_factor$non_lymphocytes=rowMeans(apply(immune_factor[,colnames(immune_factor) %in% c('Monocytes.', 'M0.macrophage.', 'M1.macrophage.',
                                                                                       'M2.macrophage.', 'Eosinophills.', 'Neutrophills.')],
                                         2, function(x) scale(x)), na.rm = T)
################################################################################
# Step 1: Load and Preprocess
################################################################################
output_fisher_test<-function(infunc_df=mskcc_combined, COI= "NSCLC"){
  
  infunc_df_tmb= infunc_df[((infunc_df$Cancer_Type == COI)),]
  infunc_df_tmb=infunc_df_tmb[!is.na(infunc_df_tmb$ORR),]
  # Contigency matrix
  cont_matrix=table( infunc_df_tmb$TMB>=10, infunc_df_tmb$ORR)
  # Perform fisher test
  fisher_test_results_raw=fisher.test(cont_matrix)
  to_return= c(fisher_test_results_raw$estimate,
               pval = fisher_test_results_raw$p.value,
               min = fisher_test_results_raw$conf.int[1],
                max = fisher_test_results_raw$conf.int[2])
}

response_result_with_TMB= data.frame(row.names = cancerTypes_of_Interest,
                                do.call(rbind, lapply(cancerTypes_of_Interest, function(x) 
                                  err_handle(output_fisher_test(infunc_df = mskcc_combined, COI = x)))))

response_result_with_TMB$cancer_acorymn= c('BLCA', 'BRCA','COAD', 'UCEC', 'ESCA', 'STAD',
                                           'GBM', 'HNSC', 'LIHC', 'SKCM', 'MESO','NSCLC',
                                           'OV', 'PAAD', 'KIRC', 'SARC', 'SCLC', 'Unknown-Primary')
response_result_with_TMB=na.omit(response_result_with_TMB)
colnames(response_result_with_TMB)[c(1,2)]= c("P", "odd_ratio")

rownames(response_result_with_TMB)= response_result_with_TMB$cancer_acorymn
################################################################################
# Step 2: Considering all cancer types
################################################################################
cancer_of_interest = intersect(rownames(immune_factor), rownames(response_result_with_TMB))
cancer_of_interest= cancer_of_interest[!(cancer_of_interest %in% "COAD")] ## results are driven by colerectal
immune_factors_with_resp_HR= data.frame(response_result_with_TMB[cancer_of_interest,-3],
                                        immune_factor[cancer_of_interest,])
# immune_factors_with_resp_HR$cancer_name = rownames(immune_factors_with_resp_HR)
target_resp= immune_factors_with_resp_HR[,"odd_ratio"]
features_resp= immune_factors_with_resp_HR[ ,-(1:2)]
correlation_with_resp_hr= data.frame(t(apply(features_resp, 2, function(x)
  unlist(cor.test(x, target_resp, method = 'spearman')[c(3, 4)]))))
rownames(correlation_with_resp_hr) = colnames(immune_factor)
correlation_with_resp_hr=na.omit(correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]), decreasing = T),])
correlation_with_resp_hr[order(correlation_with_resp_hr[,2], decreasing = T),]
correlation_with_resp_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_resp_hr)))

Panel2 <- ggplot(data=correlation_with_resp_hr, aes(x=reorder(immune_factors, estimate.rho),
                                               y=estimate.rho,
                                               color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 15)+
  theme(axis.text.y = element_blank())+
  scale_color_manual(values = c('grey', 'blue'))
Panel3 <- ggplot(data=immune_factors_with_resp_HR, aes(x=CD4..resting.T.cells.,
                                                  y=odd_ratio,
                                                  label=cancer_name))+
  theme_bw(base_size = 15)+
  geom_label()+
  geom_point()+
  stat_smooth(method='lm')

Panel2
################################################################################
# Step 3: Considering all sig cancer types ##6/8
################################################################################
cancer_of_interest = intersect(rownames(immune_factor), rownames(response_result_with_TMB))
cancer_of_interest= cancer_of_interest[!(cancer_of_interest %in% "COAD")] ## results are driven by colerectal
cancer_of_interest_sig=cancer_of_interest[which(response_result_with_TMB[cancer_of_interest,-3]$P/2 < 0.1)]

immune_factors_with_resp_HR= data.frame(response_result_with_TMB[cancer_of_interest_sig,-3],
                                        immune_factor[cancer_of_interest_sig,])

target_resp= immune_factors_with_resp_HR[,"odd_ratio"]
features_resp= immune_factors_with_resp_HR[ ,-(1:2)]
correlation_with_resp_hr= data.frame(t(apply(features_resp, 2, function(x)
  unlist(cor.test(x, target_resp, method = 'spearman')[c(3, 4)]))))
rownames(correlation_with_resp_hr) = colnames(immune_factor)
correlation_with_resp_hr=na.omit(correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]),
                                                                decreasing = T),])
correlation_with_resp_hr[order(correlation_with_resp_hr[,2], decreasing = T),]
correlation_with_resp_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_resp_hr)))


Panel2 <- ggplot(data=correlation_with_resp_hr, aes(x=reorder(immune_factors, estimate.rho),
                                                    y=estimate.rho,
                                                    color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 15)+
  theme(axis.text.y = element_blank())+
  scale_color_manual(values = c('grey', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')
immune_factors_with_resp_HR$cancer_name=rownames(immune_factors_with_resp_HR)
Panel3 <- ggplot(data=immune_factors_with_resp_HR, aes(x=rank(CD8..T.cells.),
                                                       y=rank(odd_ratio),
                                                       label=cancer_name))+
  theme_bw(base_size = 15)+
  geom_label()+
  geom_point()+
  stat_smooth(method='lm')
Panel2
################################################################################
# Step 4: Add ratios of top features
################################################################################
cancer_of_interest_sig=cancer_of_interest[which(response_result_with_TMB[cancer_of_interest,-3]$P/2 < 0.1)]

immune_factors_with_resp_HR= data.frame(response_result_with_TMB[cancer_of_interest_sig,-3],
                                        immune_factor[cancer_of_interest_sig,])
# # New features:: Ratio of top features
immune_factors_with_resp_HR$CD8_by_Plasma=immune_factors_with_resp_HR$CD8..T.cells./immune_factors_with_resp_HR$Plasma.cells.
immune_factors_with_resp_HR$CD8_by_Neutrophils=immune_factors_with_resp_HR$CD8..T.cells./(immune_factors_with_resp_HR$Neutrophills.+1)

target_resp= immune_factors_with_resp_HR[,"odd_ratio"]
features_resp= immune_factors_with_resp_HR[ ,-(1:2)]
correlation_with_resp_hr= data.frame(t(apply(features_resp, 2, function(x)
  unlist(cor.test(x, target_resp, method = 'p')[c(3, 4)]))))
rownames(correlation_with_resp_hr) = colnames(immune_factor)
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
  theme_bw(base_size = 15)+
  theme(axis.text.y = element_blank())+
  scale_color_manual(values = c('grey', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')
Panel3 <- ggplot(data=immune_factors_with_resp_HR, aes(x=CD8..T.cells.,
                                                       y=odd_ratio,
                                                       label=cancer_name))+
  theme_bw(base_size = 15)+
  geom_label()+
  geom_point()+
  stat_smooth(method='lm')
Panel2

################################################################################
# Only Chart for Immune abundances
################################################################################
cancer_of_interest = intersect(rownames(Immune_Cell_abundance), rownames(response_result_with_TMB))
cancer_of_interest= cancer_of_interest[!(cancer_of_interest %in% "COAD")] ## results are driven by colerectal
# cancer_of_interest_sig=cancer_of_interest[which(response_result_with_TMB[cancer_of_interest,-3]$P/2 < 0.1)]
cancer_of_interest_sig=cancer_of_interest

<- function(infunc_cancer_types=cancer_of_interest_sig){
  immune_factors_with_resp_HR= data.frame(response_result_with_TMB[cancer_of_interest_sig,-3],
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
  scale_color_manual(values = c('black', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')
Panel3 <- ggplot(immune_factors_with_resp_HR, aes(y=rank(odd_ratio), x=rank(NTL))) + 
  stat_smooth(method='lm')+
  geom_point(aes(size= -log(P, 10)) )+
  # geom_errorbar(aes(ymin=lower..95, ymax=upper..95), width=.2)+
  theme_bw(base_size = 15)+
  theme(legend.position = 'none')+
  labs(x='Mean tumor-NLR (Rank)', y='Odds Ratio of response\n in TMB-high group (rank) ', size='-log10(P)')+
  stat_cor(label.y = 6, label.x = 3, method = 'p', cor.coef.name = 'rho', size=6)+
  geom_label_repel(aes(label=rownames(immune_factors_with_resp_HR), size=2))

}

tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure1A_byORR.tiff',
     height=700, width = 500)
Panel2
dev.off()

tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure4A_OR.tiff', height=340, width = 350)
Panel3
dev.off()


################################################################################
# Immune-signature abundance
################################################################################
cancer_of_interest = intersect(rownames(Immune_Signature_abundance), rownames(response_result_with_TMB))
cancer_of_interest= cancer_of_interest[!(cancer_of_interest %in% "COAD")] ## results are driven by colerectal
# cancer_of_interest_sig=cancer_of_interest
cancer_of_interest_sig=cancer_of_interest[which(response_result_with_TMB[cancer_of_interest,-3]$P/2 < 0.1)]
immune_factors_with_resp_HR= data.frame(response_result_with_TMB[cancer_of_interest_sig,-3],
                                        Immune_Signature_abundance[cancer_of_interest_sig,])
# # # New features:: Ratio of top features
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
  theme(axis.text.y = element_blank(), legend.position="none")+
  scale_color_manual(values = c('black', 'blue'))+
  labs(x='Immune Factors', y='Spearman Corr Rho')+
  ylim(... = c(-0.7, 0.7))
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure2B_byORR.tiff',
     height=300, width = 450)
Panel2
dev.off()
################################################################################
# Non-Immune-Factors abundance
################################################################################
cancer_of_interest = intersect(rownames(nonImmune_Signature_abundance), rownames(response_result_with_TMB))
cancer_of_interest= cancer_of_interest[!(cancer_of_interest %in% "COAD")] ## results are driven by colerectal
# cancer_of_interest_sig=cancer_of_interest
cancer_of_interest_sig=cancer_of_interest[which(response_result_with_TMB[cancer_of_interest,-3]$P/2 < 0.1)]
immune_factors_with_resp_HR= data.frame(response_result_with_TMB[cancer_of_interest_sig,-3],
                                        nonImmune_Signature_abundance[cancer_of_interest_sig,])
# # # New features:: Ratio of top features
target_resp= immune_factors_with_resp_HR[,1]
features_resp= immune_factors_with_resp_HR[,-(1:2)]

correlation_with_resp_hr= data.frame(t(apply(features_resp, 2, function(x)
  unlist(cor.test(x, target_resp, method = 's')[c(3, 4)]))))
correlation_with_resp_hr=na.omit(correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]),
                                                                decreasing = T),])
correlation_with_resp_hr[order(abs(correlation_with_resp_hr[,2]), decreasing = T),]
correlation_with_resp_hr$immune_factors=gsub('\\.',' ',gsub('\\.\\.',' ',rownames(correlation_with_resp_hr)))
correlation_with_resp_hr$immune_factors[grep('Homolog',correlation_with_resp_hr$immune_factors)]='HRD'
Panel2 <- ggplot(data=correlation_with_resp_hr, aes(x=reorder(immune_factors, estimate.rho),
                                                    y=estimate.rho,
                                                    color=p.value<0.05))+
  geom_bar(stat="identity", fill='white')+
  coord_flip() + # horizontal bars  
  geom_text(aes(y = 0, label = immune_factors, hjust = as.numeric(estimate.rho > 0))) +  # label text based on value
  theme_bw(base_size = 20)+
  theme(axis.text.y = element_blank(), legend.position="none")+
  scale_color_manual(values = c('black', 'blue'))+
  labs(x='non-Immune Factors', y='Spearman Corr Rho')
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure2C_byORR.tiff',
     height=300, width = 450)
Panel2
dev.off()

