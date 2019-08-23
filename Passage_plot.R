library(ggplot2)
library(ggpubr)
library(ggrepel)

Passage_db <- read.csv(file.choose())
Increase <- read.csv(file.choose())

Growth_cruve <- ggplot(Passage_db, aes(x=Day, y=Count, Group = Passage_1, color = Passage)) + 
  theme(legend.position="") + 
  ylab("Parasites/mL") + 
  xlab("Days") +
  geom_point(aes(color=Passage)) +
  geom_line(color = "gray25") +
  ggtitle("(a)") +
  theme_minimal() +
  scale_color_manual(values=c('#619CFF', '#F8766D', '#00BA38')) +
  geom_label_repel(aes(label = Condition),
                 force=1, point.padding=unit(1,'lines'),
                 vjust=1,
                 direction='y',
                 segment.size=0.2) 

Increase_plot <- ggplot(Increase, aes(x=Passage, y=Growth_day, color = Misc)) + 
  geom_bar(stat="identity", color = "black", position=position_dodge()) +
  theme(legend.position="") + 
  ylab("Population increase/mL per day") + 
  xlab("Passage") +
  ggtitle("(b)") +
  theme_minimal() +
  geom_point() +
  scale_color_manual(values=c('#F8766D','#619CFF')) +
  geom_label_repel(aes(label = Condition),
                 force=1, point.padding=unit(1,'lines'),
                 vjust=1,
                 direction='y',
                 segment.size=0.2) 

ggarrange(Growth_curve, Increase_plot, ncol = 1, nrow =2, common.legend = FALSE, legend="right")
