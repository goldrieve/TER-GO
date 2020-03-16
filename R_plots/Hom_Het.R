setwd("/Users/s1886853/TERGO/Monomorph/Tcomp")
dat <- read.csv("Mono_genome_db.csv",header=TRUE)

df <- subset(dat, Name!="TREU_927")

library(ggplot2)
library (plyr)
library (ggpubr)
library(ggrepel)

ggplot(dat, aes(x=Ts, y=Het.Hom, colour=SubStrain)) + 
  geom_col(aes(fill=SubStrain)) +
  theme_bw() + 
  xlab ("Genome") +
  ylab ("Home/Het") +
  theme(text=element_text(size=16,  family="Oxygen"))

ggplot(df, aes(x=Ts.Tv, y=Het.Hom, fill=SubStrain, label = Name)) +
  geom_point(aes(colour = SubStrain), size = 4) +
  geom_label_repel()
