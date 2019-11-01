# Setting up the session/ data
library(ggplot2)
library(ggpubr)
library(ggrepel)
library(reshape2)
library(plotly)
library(dplyr)
library(tidyr)
library(qwraps2)

desc <- read.csv(file.choose())

desc$Mean_307 <- rowMeans(desc[,9:11])
desc$Mean_208 <- rowMeans(desc[,12:14])
desc$Mean_END <- rowMeans(desc[,15:17])
desc$Mean_START <- rowMeans(desc[,18:20])

ggplot(desc, mapping = aes(x = Mean_END, y = Mean_START)) + 
  xlab("Genomic position (kbp)") +
  ylab ("log2 ratio") +
  ggtitle("") +
  geom_point(aes(colour = SNP), show.legend = TRUE) +
  scale_size_continuous(range = c(1.5,1.5))
