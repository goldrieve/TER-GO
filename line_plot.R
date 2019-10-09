Passage_db <- read.csv(file.choose())

library(ggplot2)
library(ggpubr)
library(ggrepel)

ggplot(Passage_db, aes(x=Day, y=Growth, Group = Isolate)) + 
  theme(legend.position="") + 
  ylab("Parasites/mL") + 
  xlab("Days") +
  geom_line(aes(color=Line)) +
  geom_point(color = "gray25") +
  ggtitle("") +
  theme_minimal() +
  geom_vline(xintercept =3.38, linetype="dashed",
             color = "gray25", size=0.5) +
  geom_vline(xintercept =3.5, linetype="dashed",
           color = "gray25", size=0.5) +
  geom_vline(xintercept =3.25, linetype="dashed",
             color = "gray25", size=0.5)
