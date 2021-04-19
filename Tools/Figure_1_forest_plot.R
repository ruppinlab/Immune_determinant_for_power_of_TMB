library(forestplot)

#################################################################
# Forest plot for OS vs TMB >= 10 all cancer type
#################################################################
all_cancertype = samples_by_cancer_type[,1][samples_by_cancer_type[,2]> 1]
cox_results_of_TMB_plot= cox_results_of_TMB
cox_results_of_TMB_plot= cox_results_of_TMB_plot[all_cancertype,]# remove cancer type less than 50
cox_results_of_TMB_plot= na.omit(cox_results_of_TMB_plot)
cox_results_of_TMB_plot=cox_results_of_TMB_plot[
            order(cox_results_of_TMB_plot$exp.coef., decreasing = F),]

cox_results_of_TMB_plot= cox_results_of_TMB_plot[!(rownames(cox_results_of_TMB_plot)== c('Renal')),]
cox_results_of_TMB_plot= cox_results_of_TMB_plot[!(rownames(cox_results_of_TMB_plot)== c('Pancreatic')),]
colnames(cox_results_of_TMB_plot)[5] = "pval"
### number of Samples 
no_of_samples_os= samples_by_cancer_type[samples_by_cancer_type[,2]> 1,]
no_of_samples_os = no_of_samples_os[match(rownames(cox_results_of_TMB_plot),no_of_samples_os$Cancer_Type),]

### plot ###
tabletext_OS= cbind(c("Cancer Type",
                   rownames(cox_results_of_TMB_plot)),
                   c("# Samples", 
                     no_of_samples_os$ID),
                 c("pval",
                   round(cox_results_of_TMB_plot$pval/2, 5)))
## data
HR_OS=(cox_results_of_TMB_plot)
HR_OS$pvalue= ifelse((HR_OS$pval/2)<0.1, "True","False")
### styles for color according to pval
styles_OS <- fpShapesGp(
  lines = list(gpar(col ="Blue"),
               gpar(col = ifelse((HR_OS$pval/2)[1] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[2] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[3] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[4] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[5] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[6] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[7] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[8] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[9] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[10] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[11] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[12] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[13] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[14] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[15] <0.1, "blue", "red"))
  ),
  box = list(gpar(fill = "blue"),
             gpar(fill = ifelse((HR_OS$pval/2)[1] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[2] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[3] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[4] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[5] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[6] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[7] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[8] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[9] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[10] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[11] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[12] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[13] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[14] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[15] <0.1, "blue", "red"))
             )
)
tiff('/Users/neelamf2/Documents/GitHub/Immune_determinant_for_power_of_TMB/Result_fgures/boxplot1_HR_TMB.tiff',
     width = 750, height=900)
# plot.new()
forestplot(tabletext_OS,
           boxsize = .35, # We set the box size to better visualize the type
           line.margin = .30, # We need to add this to avoid crowding
           mean = c(NA,
                    HR_OS$exp.coef.),
           lower =c(NA,
                    HR_OS$lower..95),
           upper = c(NA,
                     HR_OS$upper..95),
           clip=c(0,1,1),
           lty.ci = c(1),
           ci.vertices = TRUE,
           graph.pos=3, # position of the box plot
           graphwidth = unit(13,"cm"),
           colgap = unit(0.75,"mm"),
           xlab="Hazard Ratio",
           ylab= "Cancer Types",
           shapes_gp= styles_OS,
           txt_gp = fpTxtGp(label = list(gpar(fontface = 1,cex= 1.5),
                                         gpar(fontface = 1, cex= 1.5), 
                                         gpar(fontface = 1,cex=1.5)),
                            ticks=gpar(cex=1.25),
                            xlab = gpar(cex=1.25),
                            title = gpar(fontface = 2,cex= 1.48)),
           grid = structure(c(1), gp = gpar(lty = 2, col = "#CCCCFF")),
           title = 'HR of Overall Survival between TMB high(>= 10 mut/MB) and TMB low ')
dev.off()
#################################################################
# Forest plot for OS vs TMB >= 10 cancer type with sample more than 50
#################################################################
cancertype_less_50 = samples_by_cancer_type[,1][samples_by_cancer_type[,2]> 50]
cox_results_of_TMB_plot= cox_results_of_TMB
cox_results_of_TMB_plot= cox_results_of_TMB_plot[cancertype_less_50,]# remove cancer type less than 50
cox_results_of_TMB_plot= na.omit(cox_results_of_TMB_plot)
cox_results_of_TMB_plot=cox_results_of_TMB_plot[
  order(cox_results_of_TMB_plot$exp.coef., decreasing = F),]

cox_results_of_TMB_plot= cox_results_of_TMB_plot[!(rownames(cox_results_of_TMB_plot)== 'Renal'),]
colnames(cox_results_of_TMB_plot)[5] = "pval"
### number of Samples 
no_of_samples_os= samples_by_cancer_type[samples_by_cancer_type[,2]> 50,]
no_of_samples_os = no_of_samples_os[match(rownames(cox_results_of_TMB_plot),no_of_samples_os$Cancer_Type),]

### plot ###
tabletext_OS= cbind(c("Cancer Type",
                      rownames(cox_results_of_TMB_plot)),
                    c("# Samples", 
                      no_of_samples_os$ID),
                    c("pval",
                      round(cox_results_of_TMB_plot$pval/2, 5)))
## data
HR_OS=(cox_results_of_TMB_plot)
HR_OS$pvalue= ifelse((HR_OS$pval/2)<0.1, "True","False")
### styles for color according to pval
styles_OS <- fpShapesGp(
  lines = list(gpar(col ="Blue"),
               gpar(col = ifelse((HR_OS$pval/2)[1] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[2] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[3] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[4] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[5] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[6] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[7] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[8] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[9] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[10] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[11] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_OS$pval/2)[12] <0.1, "blue", "red"))
  ),
  box = list(gpar(fill = "blue"),
             gpar(fill = ifelse((HR_OS$pval/2)[1] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[2] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[3] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[4] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[5] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[6] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[7] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[8] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[9] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[10] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[11] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_OS$pval/2)[12] <0.1, "blue", "red"))
  )
  
)

tiff('/Users/neelamf2/Documents/GitHub/Immune_determinant_for_power_of_TMB/Result_fgures/boxplot2_HR_vs_TMB_gr_50.tiff',
     width = 750, height=900)
# plot.new()
forestplot(tabletext_OS,
           boxsize = .35, # We set the box size to better visualize the type
           line.margin = .30, # We need to add this to avoid crowding
           mean = c(NA,
                    HR_OS$exp.coef.),
           lower =c(NA,
                    HR_OS$lower..95),
           upper = c(NA,
                     HR_OS$upper..95),
           clip=c(0,1,1),
           lty.ci = c(1),
           ci.vertices = TRUE,
           graph.pos=3, # position of the box plot
           graphwidth = unit(13,"cm"),
           colgap = unit(0.75,"mm"),
           # col=fpColors(box=c("blue")),
           xlab="Hazard Ratio",
           ylab= "Cancer Types",
           shapes_gp= styles_OS,
           txt_gp = fpTxtGp(label = list(gpar(fontface = 1,cex= 1.5),
                                         gpar(fontface = 1, cex= 1.5), 
                                         gpar(fontface = 1,cex=1.5)),
                            ticks=gpar(cex=1.25),
                            xlab = gpar(cex=1.25),
                            title = gpar(fontface = 2,cex= 1.48)),
           grid = structure(c(1), gp = gpar(lty = 2, col = "#CCCCFF")),
           title = 'HR of Overall Survival between TMB high(>= 10 mut/MB) and TMB low ')
# legend("topright",legend = c("TRUE", "FALSE"),ncol = 2,title="Pvalues", 
#                border="#CCCCCC", box.lwd=1.5, 
#                col=c("blue", "red"))
dev.off()
#################################################################
# Forest plot for ORR vs TMB cancer type with sample more than 50
#################################################################
cancertype_less_50 = samples_each_cancer_type[,1][samples_each_cancer_type[,2]> 50]
response_result_with_TMB= response_result_with_TMB[rownames(response_result_with_TMB) %in% cancertype_less_50,] # remove cancer type less than 50
response_result_with_TMB= na.omit(response_result_with_TMB)
response_result_with_TMB= response_result_with_TMB[!(rownames(response_result_with_TMB) == "Renal"),]
response_result_with_TMB= response_result_with_TMB[!(rownames(response_result_with_TMB) == "Colorectal"),]
response_result_with_TMB=response_result_with_TMB[order(response_result_with_TMB$odds.ratio, decreasing = F),]

no_of_samples= samples_each_cancer_type[samples_by_cancer_type$ID >50,]
no_of_samples= no_of_samples[match(rownames(response_result_with_TMB),no_of_samples$Cancer.type),]
### plot ###
tabletext_ORR= cbind(c("Cancer Type",
                   rownames(response_result_with_TMB)), 
                 c("# patient",
                   no_of_samples$ID),
                 c("pval",
                   c(round(response_result_with_TMB$pval[1],5),
                   round(response_result_with_TMB$pval[2:8]/2, 5))))

HR_ORR=response_result_with_TMB
styles <- fpShapesGp(
  lines = list(gpar(fill = ifelse((HR_ORR$pval/2) <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[1] <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[2] <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[3] <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[4] <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[5] <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[6] <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[7] <0.1, "blue", "red")),
                                gpar(col = ifelse((HR_ORR$pval/2)[8] <0.1, "blue", "red"))
               ),
  box = list(gpar(fill = ifelse((HR_ORR$pval/2) <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[1] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[2] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[3] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[4] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[5] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[6] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[7] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_ORR$pval/2)[8] <0.1, "blue", "red")))
)
tiff('/Users/neelamf2/Documents/GitHub/Immune_determinant_for_power_of_TMB/Result_fgures/boxplot4_ORR_vs_TMB_gr_50.tiff',
     width = 750, height=650)

forestplot(tabletext_ORR,
           boxsize = .30, # We set the box size to better visualize the type
           line.margin = .30, # We need to add this to avoid crowding
           mean = c(NA,
                    HR_ORR$odds.ratio),
           lower =c(NA,
                    HR_ORR$min),
           upper = c(NA,
                     HR_ORR$max),
           clip=c(0,5),
           lty.ci = c(1),
           ci.vertices = TRUE,
           graph.pos=3, # position of the box plot
           graphwidth = unit(12,"cm"),
           colgap = unit(1.5,"mm"),
           col=fpColors(box=c("blue")),
           xlab="Odd ratio",
           ylab= "Cancer Types",
           txt_gp = fpTxtGp(label = list(gpar(fontface = 1,cex= 1.5),
                                         gpar(fontface = 1, cex= 1.5), 
                                         gpar(fontface = 1,cex=1.5)),
                            ticks=gpar(cex=1.25),
                            xlab = gpar(cex=1.25),
                            title = gpar(fontface = 2,cex= 1.48)),
           shapes_gp = styles,
           grid = structure(c(1),gp = gpar(lty = 2, col = "#CCCCFF")),
           title = 'The odd ratio of response between high and low TMB group',)


dev.off()
#################################################################
# Forest plot for PFS vs TMB cancer type with sample more than 50
#################################################################
cancertype_less_50 = samples_each_cancer_type[,1][samples_each_cancer_type[,2]> 50]

PFS_result_with_TMB_plot= PFS_result_with_TMB
PFS_result_with_TMB_plot= PFS_result_with_TMB_plot[rownames(PFS_result_with_TMB_plot) 
                                                   %in% cancertype_less_50,]# remove cancer type less than 50
PFS_result_with_TMB_plot= na.omit(PFS_result_with_TMB_plot)
PFS_result_with_TMB_plot=PFS_result_with_TMB_plot[
  order(PFS_result_with_TMB_plot$exp.coef., decreasing = F),]

PFS_result_with_TMB_plot= PFS_result_with_TMB_plot[!(rownames(PFS_result_with_TMB_plot)== 'Renal'),]
colnames(PFS_result_with_TMB_plot)[5] = "pval"
### number of Samples 
no_of_samples_PFS= samples_each_cancer_type[samples_by_cancer_type$ID >50,]
no_of_samples_PFS = no_of_samples_PFS[match(rownames(PFS_result_with_TMB_plot),no_of_samples_PFS$Cancer.type),]

### plot ###
tabletext_PFS= cbind(c("Cancer Type",
                      rownames(PFS_result_with_TMB_plot)),
                    c("# Samples", 
                      no_of_samples_PFS$ID),
                    c("pval",
                      round(PFS_result_with_TMB_plot$pval/2, 8)))
## data
HR_PFS=PFS_result_with_TMB_plot
# HR_PFS$pvalue= ifelse((HR_OS$pval/2)<0.1, "True","False")
### styles for color according to pval
styles_PFS <- fpShapesGp(
  lines = list(gpar(col ="Blue"),
               gpar(col = ifelse((HR_PFS$pval/2)[1] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[2] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[3] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[4] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[5] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[6] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[7] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[8] <0.1, "blue", "red")),
               gpar(col = ifelse((HR_PFS$pval/2)[9] <0.1, "blue", "red"))
  ),
  box = list(gpar(fill = "blue"),
             gpar(fill = ifelse((HR_PFS$pval/2)[1] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[2] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[3] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[4] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[5] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[6] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[7] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[8] <0.1, "blue", "red")),
             gpar(fill = ifelse((HR_PFS$pval/2)[9] <0.1, "blue", "red"))
  )
  
)

tiff('/Users/neelamf2/Documents/GitHub/Immune_determinant_for_power_of_TMB/Result_fgures/boxplot4_PFS_vs_TMB_gr_50.tiff',
     width = 750, height=900)
# plot.new()
forestplot(tabletext_PFS,
           boxsize = .2, # We set the box size to better visualize the type
           line.margin = .25, # We need to add this to avoid crowding
           mean = c(NA,
                    HR_PFS$exp.coef.),
           lower =c(NA,
                    HR_PFS$lower..95),
           upper = c(NA,
                     HR_PFS$upper..95),
           clip=c(0,1,2),
           lty.ci = c(1),
           ci.vertices = TRUE,
           graph.pos=3, # position of the box plot
           graphwidth = unit(13,"cm"),
           colgap = unit(0.75,"mm"),
           xlab="Hazard Ratio",
           ylab= "Cancer Types",
           shapes_gp= styles_PFS,
           txt_gp = fpTxtGp(label = list(gpar(fontface = 1,cex= 1.5),
                                         gpar(fontface = 1, cex= 1.5), 
                                         gpar(fontface = 1,cex=1.5)),
                            ticks=gpar(cex=1.25),
                            xlab = gpar(cex=1.25),
                            title = gpar(fontface = 2,cex= 1.48)),
           grid = structure(c(1), gp = gpar(lty = 2, col = "#CCCCFF")),
           title = 'HR of Progresssion free survival between TMB high(>= 10 mut/MB) & TMB low ')
dev.off()
