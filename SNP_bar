data <- read.csv(file.choose())
data2 <- data[30:34,]
data3 <- data[1:29,]
data4 <- read.csv(file.choose())

library(ggplot2)
library(ggrepel)
library(ggpubr)

modules1 <- ggplot(data3, aes(x= reorder(moduleColor, -P_SNPS), y=P_SNPS)) + 
  geom_bar(stat="identity", color ="black", position=position_dodge()) +
  theme(legend.title = element_blank()) + 
  ylab("") + 
  theme_minimal() +
  ggtitle("(b)") +
  xlab("") +
  geom_point() +
  ylim(0, 80) +
  geom_hline(yintercept=12.29795674, linetype="dashed") +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  geom_label_repel(aes(label = Interest),
                   force=1, point.padding=unit(1,'lines'),
                   vjust=1,
                   direction='y',
                   segment.size=0.2) 

pathways <- ggplot(data2, aes(x= reorder(moduleColor, -P_SNPS), y=P_SNPS)) + 
  geom_bar(stat="identity", color = "black", width = 0.3, position=position_dodge()) +
  theme(legend.title = element_blank()) + 
  ylab("Genes with SNPs (%)") + 
  theme_minimal() +
  xlab("") +
  ggtitle("(c)") +
  geom_point() +
  geom_hline(yintercept=12.29795674, linetype="dashed") +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  geom_label_repel(aes(label = Interest),
                   force=1, point.padding=unit(1,'lines'),
                   vjust=1,
                   direction='y',
                   segment.size=0.2) 

module_rep <- ggplot(data=data4, aes(x=moduleColor, y=P_SNPS, fill=Color)) +
  geom_bar(stat="identity", position=position_dodge()) + 
  scale_fill_grey() + 
  theme_minimal() +
  ggtitle ("(a)") +
  ylab("Module representation (%)") +
  xlab("")

plot <- "hello"

ggarrange(module_rep, plot, modules1, pathways, nrow = 2, ncol = 2, common.legend = TRUE, legend="none")
