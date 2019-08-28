Passage_db <- read.csv(file.choose())

library(ggplot2)
library(ggpubr)
library(ggrepel)

ggplot(Passage_db, aes(x=Day, y=Pop, Group = Cell, color = Cell_line)) + 
  theme(legend.position="") + 
  ylab("Parasites/mL") + 
  xlab("Days") +
  geom_line(aes(color=Cell_line)) +
  geom_point(color = "gray25") +
  ggtitle("") +
  theme_minimal() 
