liu_demo$Dendritic.cells.activated_quantile=xtile(liu_demo$Dendritic.cells.activated, 2)
liu_demo$Dendritic.cells.resting_quantile=xtile(liu_demo$Dendritic.cells.resting, 2)
liu_demo$TMB=liu_demo$total_muts/50
liu_demo$TMB_high=liu_demo$TMB>10
df2plot=aggregate(BR ~ Dendritic.cells.activated_quantile+TMB_high, liu_demo, function(x) sum(x=='R')/length(x) )
df2plot$Dendritic.cells.activated_quantile=
  factor(df2plot$Dendritic.cells.activated_quantile, labels = c('Low', 'High'))
p1 <- ggplot(df2plot, aes(x=factor(Dendritic.cells.activated_quantile),y=BR, fill=TMB_high ))+
  geom_bar(stat='identity', position=position_dodge())+
  theme_bw(base_size = 15)+
  labs(x='Dendritic Cell Activated', y='% responders')+
  annotate("text", x = 'Low', y = 0.55,
           label = paste('OR=',round(df2plot[3,3]/df2plot[1,3], 2)) )+
  annotate("text", x = 'High', y = 0.40,
           label =  paste('OR=',round(df2plot[4,3]/df2plot[2,3], 2)) )
  

###################
# 
###################
liu_demo$Dendritic.cells.resting_quantile=xtile(liu_demo$Dendritic.cells.resting, 2)

df2plot=aggregate(BR ~ Dendritic.cells.resting_quantile+TMB_high, liu_demo, function(x) sum(x=='R')/length(x) )
df2plot$Dendritic.cells.resting_quantile=
  factor(df2plot$Dendritic.cells.resting_quantile, labels = c('Low', 'High'))

p2 <- ggplot(df2plot, aes(x=factor(Dendritic.cells.resting_quantile),y=BR, fill=TMB_high ))+
  geom_bar(stat='identity', position=position_dodge())+
  theme_bw(base_size = 15)+
  labs(x='Dendritic Cell resting', y='% responders')+
  annotate("text", x = 'Low', y = 0.55,
           label = paste('OR=',round(df2plot[3,3]/df2plot[1,3], 2)) )+
  annotate("text", x = 'High', y = 0.50,
           label =  paste('OR=',round(df2plot[4,3]/df2plot[2,3], 2)) )

integrated_p=ggarrange(p1, p2, nrow = 2, common.legend = T)

ggsave('/Users/neelamf2/Documents/GitHub/fda-tmbCriteria-Power-vs-age-sex/Results_Figures/Figure for PPT/Panel_4.tiff',
       integrated_p, height=6, width = 3, units = 'in', dpi = 500)