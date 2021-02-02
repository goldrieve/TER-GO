setwd("/Users/s1886853/TERGO/Monomorph/Tcomp/Genome_stats")
dat <- read.csv("Mono_genome_db.csv",header=TRUE)

df <- subset(dat, Name!="TREU_927")
library(ggplot2)
library(ggrepel)

ggplot(df, aes(x=Ts.Tv, y=Het.Hom, fill=Strain, label = Name)) +
  geom_point(aes(colour = Strain), size = 4) +
  xlab("Transitions/Transversions") +
  ylab ("Heterozygous/Homozygous") +
  geom_label_repel() +
  theme_bw(base_size = 20)