setwd("/Users/s1886853/OneDrive - University of Edinburgh/PHDZLE/Monomorph_wet/UPA_selection/UPA_P32_DC")
dat <- read.csv("Drug_GC.csv",header=TRUE)

library(ggplot2)
library (plyr)
library (ggpubr)

df <- dlply(dat, .(Line))

Antat <- ggplot(df$`AnTat_1.1.90:13`, aes(x=Hour,y=(log10(Density)), colour=Treatment)) +
  stat_smooth(method="loess", span=1, se=TRUE, aes(fill=Treatment), alpha=0.2) +
  theme_bw() + ggtitle ("AnTat_1.1.90:13") + xlab ("Hours in culture") +
  ylab ("Parasites / ml (10^x)") + aes (xmax=96) +
  theme(text=element_text(size=16,  family="Oxygen"))

UPA_P32 <- ggplot(df$UPA_P32, aes(x=Hour,y=(log10(Density)), colour=Treatment)) +
  stat_smooth(method="loess", span=1, se=TRUE, aes(fill=Treatment), alpha=0.2) +
  theme_bw() + ggtitle ("UPA_P32") + xlab ("Hours in culture") +
  ylab ("Parasites / ml (10^x)") + aes (xmax=96) +
  theme(text=element_text (size=16,  family="Oxygen"))

UPA_P32_ZT <- ggplot(df$UPA_P32_ZT, aes(x=Hour,y=(log10(Density)), colour=Treatment)) +
  stat_smooth(method="loess", span=1, se=TRUE, aes(fill=Treatment), alpha=0.2) +
  theme_bw() + ggtitle ("UPA_P32_ZT") + xlab ("Hours in culture") +
  ylab ("Parasites / ml (10^x)") + aes (xmax=96) +
  theme(text=element_text(size=16,  family="Oxygen"))

ggarrange (Antat, UPA_P32, UPA_P32_ZT, nrow = 1, ncol = 3, common.legend = TRUE)