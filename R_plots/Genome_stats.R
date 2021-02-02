setwd("/Users/r/OneDrive - University of Edinburgh/PHDZLE/TERGO/Monomorph/Tcomp")
dat <- read.csv("Mono_genome_db.csv",header=TRUE)

df <- subset(dat, Name!="TREU_927")

library(ggplot2)
library (plyr)
library (ggpubr)
library(ggrepel)
library(plotly)

#2D plots

GC.HH <- ggplot(df, aes(x=GC, y=Het.Hom, fill=Strain, label = Name)) +
  geom_point(aes(colour = Strain), size = 4) +
  xlab ("GC %") +
  ylab ("Heterozygous/Homozygous") +
  geom_label_repel()

GC.TT <- ggplot(df, aes(x=GC, y=Ts.Tv, fill=Strain, label = Name)) +
  geom_point(aes(colour = Strain), size = 4) +
  xlab ("GC %") +
  ylab ("Transitions/Transversions") +
  geom_label_repel()

TT.HH <- ggplot(df, aes(x=Ts.Tv, y=Het.Hom, fill=Strain, label = Name)) +
  geom_point(aes(colour = Strain), size = 4) +
  xlab ("Transitions/Transversions") +
  ylab ("Heterozygous/Homozygous") +
  geom_label_repel()

ggarrange(GC.HH, GC.TT, TT.HH, ncol = 3, nrow =1, common.legend = TRUE, legend="top")

#PLOTLY 3D#

mtcars$am[which(mtcars$am == 0)] <- 'Automatic'
mtcars$am[which(mtcars$am == 1)] <- 'Manual'
mtcars$am <- as.factor(mtcars$am)

fig <- plot_ly(df, x = ~GC, y = ~Ts.Tv, z = ~Het.Hom, color = ~Strain)
fig <- fig %>% add_markers()
fig <- fig %>% layout(scene = list(xaxis = list(title = 'GC %'),
                                   yaxis = list(title = 'Ts/Tv'),
                                   zaxis = list(title = 'Heterozygous/Homozygous')))
fig
htmlwidgets::saveWidget(fig, "genome_stats.html")
