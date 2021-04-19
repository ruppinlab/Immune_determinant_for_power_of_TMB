nlr_ratio=readxl::read_xlsx('/Users/sinhas8/Downloads/41467_2021_20935_MOESM3_ESM.xlsx')
cor.test(aggregate(NLR ~ `Cancer type`, nlr_ratio, mean)[c(4, 7, 8, 9, 1, 11),2],
         immune_factors_with_resp_HR$odd_ratio)
nlr_ratio_df=data.frame(nlr_ratio)
nlr_ratio_df$vital_status_numeric=as.numeric(!grepl('alive',nlr_ratio_df$Vital.status, ignore.case = T))
nlr_ratio_df$progression_status=as.numeric(grepl('Yes',nlr_ratio_df$Progression, ignore.case = T))
nlr_ratio_df$high_tmb=nlr_ratio_df$TMB..Mutations.Mb.>= 10
nlr_df_for_cox=do.call(rbind, lapply(split(nlr_ratio_df, nlr_ratio_df$Cancer.type), function(x)
  data.frame(x, highTMB_top20Percentile=x$TMB..Mutations.Mb. > sort(x$TMB..Mutations.Mb., decreasing = T)[nrow(x)*0.2]) ))
################################################################################
# Compute OS HR in TMB-high for each cancer type
################################################################################
nlr_df_for_cox$NLR_quantile=xtile(nlr_df_for_cox$NLR, K)
df2plot=data.frame(do.call(rbind, lapply(1:K, function(x) 
  cbind(summary(coxph(Surv(Progression.Free.Survival..Months.,
           progression_status) ~ highTMB_top20Percentile,
      data = nlr_df_for_cox[nlr_df_for_cox$NLR_quantile==x,]))$coefficients,
   summary(coxph(Surv(Progression.Free.Survival..Months.,
                      progression_status) ~ high_tmb,
                 data = nlr_df_for_cox[nlr_df_for_cox$NLR_quantile==x,]))$conf.int)
  )))

colnames(df2plot)[5]='log-Rank P'
p1 <- ggplot(df2plot, aes(x=factor(1:K), y=exp.coef.)) + 
  geom_line() +
  geom_point(aes(size= -log(`log-Rank P`, 10)) )+
  geom_errorbar(aes(ymin=lower..95, ymax=upper..95), width=.2)+
  theme_bw(base_size = 20)+
  theme(legend.position = 'top')+
  labs(x='NTL ratio Tertile', y='Association btw TMB-OS', size='-log10(P)')
################################################################################
# by cancer type:: Using Overall Survival
################################################################################
Cancer_types_available=levels(factor(nlr_df_for_cox$Cancer.type))
summary(coxph(Surv(Overall.Survival..Months.,
                   vital_status_numeric) ~ high_tmb,
                    data = nlr_df_for_cox[nlr_df_for_cox$Cancer.type==x,]))$conf.int
df2plot=data.frame(do.call(rbind, lapply(Cancer_types_available, function(x) 
  cbind(summary(coxph(Surv(Overall.Survival..Months.,
                           vital_status_numeric) ~ high_tmb,
                      data = nlr_df_for_cox[nlr_df_for_cox$Cancer.type==x,]))$coefficients,
  summary(coxph(Surv(Overall.Survival..Months.,
                     vital_status_numeric) ~ high_tmb,
                data = nlr_df_for_cox[nlr_df_for_cox$Cancer.type==x,]))$conf.int)
  )))
rownames(df2plot)=Cancer_types_available
colnames(df2plot)[5]='log-Rank P'
df2plot$Mean_NLR=aggregate(nlr_df_for_cox$NLR~ nlr_df_for_cox$Cancer.type,nlr_df_for_cox,  mean)[,2]
df2plot=na.omit(df2plot)
p2 <- ggplot(df2plot, aes(y=rank(exp.coef.), x=rank(Mean_NLR))) + 
  stat_smooth(method='lm')+
  geom_point(aes(size= -log(`log-Rank P`, 10)) )+
  # geom_errorbar(aes(ymin=lower..95, ymax=upper..95), width=.2)+
  theme_bw(base_size = 20)+
  theme(legend.position = 'none')+
  labs(x='Mean blood-NLR (Rank)', y='Hazard Ratio of OS in TMB-high group\n (Association btw TMB-OS)', size='-log10(P)')+
  stat_cor(label.y = 13, method = 'p', cor.coef.name = 'rho', size=6)+
  geom_label_repel(aes(label=rownames(df2plot), size=2))
  # ylim(... = c(0, 2.5))
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure0A_OS.tiff', height=600, width = 600)
p2
dev.off()

################################################################################
# by cancer type:: Using PFS
################################################################################
Cancer_types_available=levels(factor(nlr_df_for_cox$Cancer.type))
summary(coxph(Surv(Progression.Free.Survival..Months.,
                   progression_status) ~ high_tmb,
              data = nlr_df_for_cox[nlr_df_for_cox$Cancer.type==x,]))$conf.int
df2plot=data.frame(do.call(rbind, lapply(Cancer_types_available, function(x) 
  cbind(summary(coxph(Surv(Progression.Free.Survival..Months.,
                           progression_status) ~ high_tmb,
                      data = nlr_df_for_cox[nlr_df_for_cox$Cancer.type==x,]))$coefficients,
        summary(coxph(Surv(Progression.Free.Survival..Months.,
                           progression_status) ~ high_tmb,
                      data = nlr_df_for_cox[nlr_df_for_cox$Cancer.type==x,]))$conf.int)
)))
rownames(df2plot)=Cancer_types_available
colnames(df2plot)[5]='log-Rank P'
df2plot$Mean_NLR=aggregate(nlr_df_for_cox$NLR~ nlr_df_for_cox$Cancer.type,nlr_df_for_cox,  mean)[,2]
df2plot=na.omit(df2plot)
p2 <- ggplot(df2plot, aes(y=rank(exp.coef.), x=rank(Mean_NLR))) + 
  stat_smooth(method='lm')+
  geom_point(aes(size= -log(`log-Rank P`, 10)) )+
  # geom_errorbar(aes(ymin=lower..95, ymax=upper..95), width=.2)+
  theme_bw(base_size = 20)+
  theme(legend.position = 'none')+
  labs(x='Mean blood-NLR (Rank)', y='Hazard Ratio of PFS in TMB-high group\n (Association btw TMB-PFS)', size='-log10(P)')+
  stat_cor(label.y = 13, method = 'p', cor.coef.name = 'rho', size=6)+
  geom_label_repel(aes(label=rownames(df2plot), size=2))
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure0A_PFS.tiff', height=600, width = 600)
p2
dev.off()
################################################################################
# by cancer type:: Using radiological-response
################################################################################
response_result_with_TMB= data.frame(row.names = cancerTypes_ofInterset,
                                     do.call(rbind, lapply(cancerTypes_ofInterset, function(x) 
                                       err_handle(output_fisher_test(infunc_df = Valero_pd1, COI = x)))))
response_result_with_TMB$cancer_acorymn= c('BLCA', 'BRCA','COAD', 'UCEC', 'ESCA', 'STAD',
                                           'GBM', 'HNSC', 'LIHC', 'SKCM', 'MESO','NSCLC',
                                           'OV', 'PAAD', 'KIRC', 'SARC', 'SCLC', 'Unknown-Primary')

Mean_NLR=aggregate(nlr_df_for_cox$NLR~ nlr_df_for_cox$Cancer.type,nlr_df_for_cox,  mean, na.action = NULL)
rownames(Mean_NLR)=Mean_NLR$`nlr_df_for_cox$Cancer.type`
df2plot=data.frame(response_result_with_TMB[match(intersect(Mean_NLR$`nlr_df_for_cox$Cancer.type`, rownames(response_result_with_TMB)), rownames(response_result_with_TMB)),],
           Mean_NLR=Mean_NLR[rownames(response_result_with_TMB[match(intersect(Mean_NLR$`nlr_df_for_cox$Cancer.type`, rownames(response_result_with_TMB)), rownames(response_result_with_TMB)),]),2])

df2plot=na.omit(df2plot)
colnames(df2plot)[c(1,2)]= c("P", "odd_ratio")
rownames(df2plot)=df2plot$cancer_acorymn

df2plot=df2plot[rownames(df2plot) %!in% c('Colorectal', 'Gastric'),]
p2 <- ggplot(df2plot, aes(y=rank(odd_ratio), x=rank(Mean_NLR))) + 
  stat_smooth(method='lm')+
  geom_point(aes(size= -log(`P`, 10)) )+
  theme_bw(base_size = 20)+
  theme(legend.position = 'none')+
  labs(x='Mean blood-NLR (Rank)', y='Odds Ratio of response in TMB-high group (rank)\n (Association btw TMB-ORR)', size='-log10(P)')+
  stat_cor(label.y = 13, method = 'p', cor.coef.name = 'rho', size=6)+
  geom_label_repel(aes(label=rownames(df2plot), size=2))
# ylim(... = c(0, 2.5))
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure0A_ORR.tiff', height=600, width = 600)
p2
dev.off()

# Only sig cancer types
p2 <- ggplot(df2plot[rownames(immune_factors_with_resp_HR),], aes(y=rank(odd_ratio), x=rank(Mean_NLR))) + 
  stat_smooth(method='lm')+
  geom_point(aes(size= -log(`P`, 10)) )+
  theme_bw(base_size = 20)+
  theme(legend.position = 'none')+
  labs(x='Mean blood-NLR (Rank)', y='Odds Ratio of response in TMB-high group (rank)\n (Association btw TMB-ORR)', size='-log10(P)')+
  stat_cor(label.y = 7, method = 'p', cor.coef.name = 'rho', size=6)+
  geom_label_repel(aes(label=rownames(immune_factors_with_resp_HR), size=2))
tiff('/Users/sinhas8/approve_tmbCriteria_vs_age_Sex/Results_Figures/ppt_figure0A_ORR_only_Sig.tiff', height=350, width = 350)
p2
dev.off()