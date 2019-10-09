Passage_db <- read.csv(file.choose())
line_db <- read.csv(file.choose())

library(ggplot2)
library(ggpubr)
library(ggrepel)

growth_plot <- ggplot(Passage_db, aes(x=Day, y=Growth, Group = Isolate)) + 
  theme(legend.position="") + 
  ylab("Parasites/mL") + 
  xlab("Days") +
  geom_line(aes(color=Line)) +
  geom_point(color = "gray25") +
  ggtitle("(b)") +
  theme_minimal() 

creation_plot <- ggplot(line_db, aes(x=Day, y=Count)) + 
  theme(legend.position="") + 
  ylab("Parasites/mL") + 
  xlab("Days") +
  geom_point(color="gray25") +
  geom_line(color = "gray25") +
  ggtitle("(a)") +
  theme_minimal() +
  geom_label_repel(aes(label = Condition),
                   force=1, point.padding=unit(1,'lines'),
                   vjust=1,
                   direction='y',
                   segment.size=0.2) +
  scale_fill_manual(values = setNames(line_db$Condition, levels(line_db$Condition))) +
  scale_color_manual(values = setNames(line_db$Condition, levels(line_db$Condition)))

ggarrange(creation_plot, growth_plot, ncol = 2, nrow = 1, common.legend = FALSE, legend="right")

