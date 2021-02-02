setwd("/Users/s1886853/GATK/Tcomp_GATK")
dat <- read.csv("Genome_stats.csv",header=TRUE)

df <- subset(dat, Name!="TREU_927")
library(ggplot2)
library(ggrepel)

ggplot(dat, aes(x=Chromosome, y=Variants.rate)) + 
  geom_col(aes(fill=Chromosome)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_bw (base_size = 20)

ggplot(dat, aes(x=Chromosome, y=Variants.rate, colour="black")) + 
  geom_col(aes(fill="spacegrey")) +
  theme_bw() +
  theme(text = element_text(size=16,  family="Oxygen")) +
  theme(axis.text.x=element_text(angle = 45, hjust = 1, size=16,  family="Oxygen")) +
  theme (legend.position = "none")
