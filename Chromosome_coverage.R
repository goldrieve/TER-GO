#This script uses gene counts to create chromsome wide coverage plots of each gene. Each gene is split into one of 11
#chromosomes and a line is plotted for each sample. 

library(ggplot2)
library(ggpubr)
library(ggrepel)
library(reshape2)
library(plotly)
library(dplyr)

DNA <- read.csv(file.choose())

DNA_int <- DNA [6:14]
DNA_Melt = melt(DNA_int, measure.vars = c("NEK_END","NEK_START","TbruceiTREU927","Clone_2","Clone_3","Clone_4","Clone_5","ERR005858"),
             variable.name = "Cell_line", value.name = "Count")

cell_line <- (as.character(DNA_Melt$Cell_line))
out <- split(DNA_Melt , f = DNA_Melt$Chr)

C1 <- ggplot(data = out$Tb927_01_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_01_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C2 <- ggplot(data = out$Tb927_02_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_02_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C3 <- ggplot(data = out$Tb927_03_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_03_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C4 <- ggplot(data = out$Tb927_04_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_04_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C5 <- ggplot(data = out$Tb927_05_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") + 
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_05_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C6 <- ggplot(data = out$Tb927_06_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_06_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C7 <- ggplot(data = out$Tb927_07_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_07_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C8 <- ggplot(data = out$Tb927_08_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_08_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C9 <- ggplot(data = out$Tb927_09_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_09_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C10 <- ggplot(data = out$Tb927_10_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_10_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

C11 <- ggplot(data = out$Tb927_11_v5.1, mapping = aes(x=Geneid, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Gene") +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_11_v5.1") +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

ggarrange(C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, nrow = 6, ncol = 2, common.legend = TRUE)
