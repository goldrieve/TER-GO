data <- read.csv(file.choose())

library(ggplot2)
library(ggpubr)
library(ggrepel)

plot1 <- ggplot(data, aes(x=Day, y=Parasitemia, group=Mouse)) + 
  geom_line(aes(color=Line)) + 
  theme(legend.position="") + ylab("Parasites/mL") + xlab("Hours post infection") +
  theme_minimal() +
  ggtitle("(b)") +
  geom_point()

plot2 <- ggplot(data, aes(x=Day, y=P_stumpy, group=Mouse)) + 
  geom_line(aes(color=Line)) + 
  theme(legend.position="") + ylab("Percentage stumpy") + xlab("Hours post infection") +
  theme_minimal() +
  ggtitle("(c)") +
  geom_point()

plot3 <- ggplot(data, aes(x=Day, y=P_1k1n, group=Mouse)) + 
  geom_line(aes(color=Line)) + 
  theme(legend.position="") + ylab("Percentage 1K1N") + xlab("Hours post infection") + 
  theme_minimal() +
  ggtitle("(d)") +
  geom_point()

plot4 <- ggplot(data, aes(x=Day, y=P_2K1N, group=Mouse)) + 
  geom_line(aes(color=Line)) + 
  theme(legend.position="") + ylab("Percentage 2K1N") + xlab("Hours post infection") +
  theme_minimal() +
  ggtitle("(e)") +
  geom_point()

plot5 <- ggplot(data, aes(x=Day, y=P_2K2N, group=Mouse)) + 
  geom_line(aes(color=Line)) + 
  theme(legend.position="") + ylab("Percentage 2K2N") + xlab("Hours post infection") + 
  theme_minimal() +
  ggtitle("(f)") +
  geom_point()

plot6 <- ggplot(data, aes(x=Day, y=P_1K2N, group=Mouse)) + 
  geom_line(aes(color=Line)) + 
  theme(legend.position="") + ylab("Percentage other KN") + xlab("Hours post infection") + 
  theme_minimal() +
  ggtitle("()") +
  geom_point()

qpcr <- ggplot(data, aes(x=Line, y=Ratio, fill=Line)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=Ratio-Ratio_error, ymax=Ratio+Ratio_error), width=.2,
                position=position_dodge(.9)) +
  theme(legend.position="") + ylab("Relative ratio (ZC3H20)") + 
  theme_minimal() +
  xlab("Cell line") +
  ggtitle("(g)") +
  geom_point() 

ggarrange(plot1, plot2, plot3, plot4, plot5, qpcr, nrow = 3, ncol = 2, common.legend = FALSE)
