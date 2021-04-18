##################################
# Figures for Immune determinants at patient level
##################################

HR_output_modulator_low_vs_high = data.frame(do.call(rbind,Hr_result_two_group))
HR_output_modulator_low_vs_high$modulators= c('Signature.7','Signature.7', 
                                              'master_purity_R1','master_purity_R1',
                                              "Signature.4","Signature.4", 
                                              "treg.score.danaher","treg.score.danaher")
HR_output_modulator_low_vs_high$group= c("low", "high",
                                         "low", "high",
                                         "low", "high",
                                         "low", "high")

Hr_dfplot= HR_output_modulator_low_vs_high$exp.coef.
Plot2= ggplot(data=Hr_dfplot[5:8,],aes(x=factor(modulators),
                               y= exp.coef., fill= group))+
  geom_bar(stat="identity", color="black", position=position_dodge())+
  # geom_errorbar(aes(ymin= lower_95, ymax=upper_95), size= 1,width=.4,
  #               position=position_dodge(.9))+
  theme_bw(base_size = 15)+
  theme(axis.text.y = element_text(size=13))+
  theme(axis.text.x = element_text(size=13))+
  labs(x='Modulators', y='Hazard Ratio')+
  ggtitle("Sanity check for positive modulator")
ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/Sanity_check_HR_diff_by_group_negative.tiff',
       Plot2, height=6, width = 6, units = 'in', dpi = 500)


##################################
# Figures for Immune determinants at patient level by within cohorts
##################################

##########################################################
#Volcano plot
##########################################################

df_plot= melanoma_new_result_all_modulators
df_plot= na.omit(df_plot[order(df_plot[,1]),])
df_plot$rank= seq(1, nrow(df_plot))
df_plot$log10HR= log10(df_plot$exp.coef.)

volcano_plt_kevin= EnhancedVolcano(df_plot,
                                   lab = rownames(df_plot),
                                   x= "log10HR",
                                   y= 'Pr...z..',
                                   xlab = "HR",
                                   pCutoff = 0.5,
                                   FCcutoff = 0.2,
                                   pointSize = 2.0,
                                   labSize = 4.0,
                                   drawConnectors = TRUE,
                                   widthConnectors = 0.75,
                                   xlim = c(-4,4),
                                   ylim = c(-1,3))

ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/immune_determinant/volcano_plot_kevin.tiff',
       volcano_plt_kevin, height=6, width = 9, units = 'in', dpi = 500)

df_plot= melanoma_liu_result_all_modulators
df_plot= na.omit(df_plot[order(df_plot[,1]),])
df_plot$rank= seq(1, nrow(df_plot))
df_plot$log10HR= log10(df_plot$exp.coef.)
volcano_plt_liu= EnhancedVolcano(df_plot,
                                 lab = rownames(df_plot),
                                 x= ("log10HR"),
                                 y= 'Pr...z..',
                                 pCutoff = 1,
                                 FCcutoff = 0.5,
                                 pointSize = 3.0,
                                 labSize = 4.0,
                                 xlim = c(-5,5),
                                 ylim = c(-1,3),
                                 drawConnectors = TRUE,
                                 widthConnectors = 0.75) 
ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/immune_determinant/volcano_plot_liu_etal.tiff',
       volcano_plt_liu, height=6, width = 9, units = 'in', dpi = 500)

##############################################################################
#Bar plots for HR Ratio
##############################################################################
##################### Bar plot for Liu et al

FOI_liu= c('Macrophages.M1','Dendritic.cells.activated','Dendritic.cells.resting')
Ratio_HR_OS_liu$FOI= ifelse((row.names(Ratio_HR_OS_liu) %in% FOI_liu), T, F) 
bar_plot3= ggplot(Ratio_HR_OS_liu, aes(x= HR_Ratio, 
                                       y= reorder(rownames(Ratio_HR_OS_liu), HR_Ratio),
                                       fill=FOI))+
  geom_bar(stat="identity")+
  geom_vline(xintercept = 1, linetype=4, 
             color = "blue", size=0.5)+
  scale_fill_manual(values=c("grey", "blue"))
ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/immune_determinant/Bar_plot_liu.tiff',
       bar_plot3, height=10, width = 7, units = 'in', dpi = 300)

##################### Bar plot for Liu et al Objective response rate
HR_ratio_df_OR$FOI= ifelse((row.names(HR_ratio_df_OR) %in% FOI_liu), T, F) 
bar_plot4= ggplot(HR_ratio_df_OR, aes(x= ORR_Ratio, 
                                      y= reorder(rownames(HR_ratio_df_OR), ORR_Ratio),
                                      fill=FOI))+
  geom_bar(stat="identity")+
  geom_vline(xintercept = 1, linetype=4, 
             color = "blue", size=0.5)+
  scale_fill_manual(values=c("grey", "blue"))
ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/immune_determinant/Bar_plot_liu_ORR.tiff',
       bar_plot4, height=10, width = 7, units = 'in', dpi = 300)


#####################  Bar plot for Scaled data
FOI= c('Signature.7','dend.score.danaher', 'master_purity_R1', "macrophage.score.danaher", "CD274")
Ratio_HR_OS_kevin$FOI= ifelse((row.names(Ratio_HR_OS_kevin) %in% FOI), T, F)
Ratio_HR_OS_kevin= na.omit(Ratio_HR_OS_kevin)
bar_plot1= ggplot(Ratio_HR_OS_kevin, aes(x= HR_Ratio, 
                                         y= reorder(rownames(Ratio_HR_OS_kevin), HR_Ratio),
                                         fill= FOI))+ geom_bar(stat="identity")+
  geom_vline(xintercept = 1, linetype=4, 
             color = "blue", size=0.5)+
  scale_fill_manual(values=c("grey", "blue"))

ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/immune_determinant/Bar_plot_kevin.tiff',
       bar_plot1, height=10, width = 7, units = 'in', dpi = 300)

#####################  Bar plot for Scaled data
Ratio_HR_OS_scaled$FOI= ifelse((row.names(Ratio_HR_OS_scaled) %in% FOI), T, F)    
Ratio_HR_OS_scaled= na.omit(Ratio_HR_OS_scaled)

bar_plot2= ggplot(Ratio_HR_OS_scaled, aes(x= HR_Ratio, 
                                          y= reorder(rownames(Ratio_HR_OS_scaled), HR_Ratio),
                                          fill= FOI))+
  geom_bar(stat="identity")+
  geom_vline(xintercept = 1, linetype=4, 
             color = "blue", size=0.5)+
  scale_fill_manual(values=c("grey", "blue"))

ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/immune_determinant/Bar_plot_scaled_kevin.tiff',
       bar_plot2, height=10, width = 7, units = 'in', dpi = 300)






