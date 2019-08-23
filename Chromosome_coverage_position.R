#This script uses gene counts to create chromsome wide coverage plots of each gene. Each gene is split into one of 11
#chromosomes and a line is plotted for each sample. 

library(ggplot2)
library(ggpubr)
library(ggrepel)
library(reshape2)
library(plotly)
library(dplyr)

DNA <- read.csv(file.choose())

DNA_int <- DNA [3:11]
DNA_Melt = melt(DNA_int, measure.vars = c("END","START","TbruceiTREU927","Clone_2","Clone_3","Clone_4","Clone_5"),
                variable.name = "Cell_line", value.name = "Count")

DNA_Melt$Count[DNA_Melt$Count > 10] <- NA #Removed all values above 10to enable chromsome wide changes

cell_line <- (as.character(DNA_Melt$Cell_line))
out <- split(DNA_Melt , f = DNA_Melt$chr)

C1 <- ggplot(data = out$Tb927_01_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_01_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)

ggplot(data = out$Tb927_02_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  scale_x_discrete(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_02_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C3 <- ggplot(data = out$Tb927_03_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_03_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C4 <- ggplot(data = out$Tb927_04_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_04_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C5 <- ggplot(data = out$Tb927_05_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") + 
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_05_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C6 <- ggplot(data = out$Tb927_06_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_06_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C7 <- ggplot(data = out$Tb927_07_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_07_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C8 <- ggplot(data = out$Tb927_08_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_08_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C9 <- ggplot(data = out$Tb927_09_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_09_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C10 <- ggplot(data = out$Tb927_10_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_10_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


C11 <- ggplot(data = out$Tb927_11_v5.1, mapping = aes(x=start, y=Count)) + 
  theme(legend.position="") + 
  ylab("Relative read depth") + 
  xlab("Genomic position (bp)") +
  scale_y_continuous(limits=c(0, 10)) +
  geom_line(aes(color=Cell_line, group = Cell_line)) +
  ggtitle("Tb927_11_v5.1") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept=1, linetype="dashed", 
             color = "black", size=1)


ggarrange(C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, nrow = 6, ncol = 2, common.legend = TRUE)
