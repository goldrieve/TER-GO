#This script uses gene counts to create chromsome wide coverage plots of each gene. Each gene is split into one of 11
#chromosomes and a line is plotted for each sample

# Setting up the session/ data
library(ggplot2)
library(ggpubr)
library(ggrepel)
library(reshape2)
library(plotly)
library(dplyr)
library(tidyr)
library(qwraps2)

filelist = list.files(pattern = "*sorted.targetcoverage.cnn")
datalist = lapply(filelist, function(x)read.table(x, header=T, stringsAsFactors=F, na.strings=c(NA,"NA"," NA"))) 
#desc <- read.csv(file.choose()) #needed to add genes which all have duplications

datalist$Clone2 <- (datalist[[1]]) # rename the df in the list
datalist$Clone2$depth[datalist$Clone2$depth < 0.00003] <- ""  #Removed all values inside threshold
datalist$Clone2 <- na.exclude(datalist$Clone2)
datalist$Clone2$depth2 <- log2(as.numeric(datalist$Clone2$depth) / as.numeric(median(datalist$Clone2$depth)))

datalist$Clone3 <- (datalist[[2]]) # rename the df in the list
datalist$Clone3$depth[datalist$Clone3$depth < 0.00003] <- ""  #Removed all values inside threshold
datalist$Clone3 <- na.exclude(datalist$Clone3)
datalist$Clone3$depth2 <- log2(as.numeric(datalist$Clone3$depth) / as.numeric(median(datalist$Clone3$depth)))

datalist$Clone4 <- (datalist[[3]]) # rename the df in the list
datalist$Clone4$depth[datalist$Clone4$depth < 0.00003] <- ""  #Removed all values inside threshold
datalist$Clone4 <- na.exclude(datalist$Clone4)
datalist$Clone4$depth2 <- log2(as.numeric(datalist$Clone4$depth) / as.numeric(median(datalist$Clone4$depth)))

datalist$Clone5 <- (datalist[[4]]) # rename the df in the list
datalist$Clone5$depth[datalist$Clone5$depth < 0.00003] <- ""  #Removed all values inside threshold
datalist$Clone5 <- na.exclude(datalist$Clone5)
datalist$Clone5$depth2 <- log2(as.numeric(datalist$Clone5$depth) / as.numeric(median(datalist$Clone5$depth)))

datalist$END <- (datalist[[5]]) # rename the df in the list
datalist$END$depth[datalist$END$depth < 0.00003] <- ""  #Removed all values inside threshold
datalist$END <- na.exclude(datalist$END)
datalist$END$depth2 <- log2(as.numeric(datalist$END$depth) / as.numeric(median(datalist$END$depth)))

datalist$START <- (datalist[[6]]) # rename the df in the list
datalist$START$depth[datalist$START$depth < 0.00003] <- ""  #Removed all values inside threshold
datalist$START <- na.exclude(datalist$START)
datalist$START$depth2 <- log2(as.numeric(datalist$START$depth) / as.numeric(median(datalist$START$depth)))


datafr <- bind_rows(datalist$Clone2, datalist$Clone3, datalist$Clone4, datalist$Clone5, datalist$END, datalist$START, .id = 'Cell_line') # Bind the rows to make a long df

#datafr$start<- datafr$start / 1000 # Divide the start length to get kb value

#datafr$Description[datafr$Description == "#N/A"] <- " " # Remove the na so the graph looks pretty
datafr$Cell_line[datafr$Cell_line == 1] <- "Clone 2"  # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 2] <- "Clone 3" # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 3] <- "Clone 4" # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 4] <- "Clone 5" # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 5] <- "END" # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 6] <- "START" # rename the DF to meaningful 

reduced <- datafr # Creating a new df to add column to datafr
reduced$depth2[reduced$depth2 < 0.585 & reduced$depth2 > -1] <- 1 #Removed all values inside threshold
datafr$Duplicated=reduced$depth2 # Add the new column, with genes which have aneuploidy, to datafr
split_df <- split(datafr, with(datafr, interaction(chromosome)), drop = TRUE) #Split up the DF into chromosomes

split_df$Tb927_02_v4$start <- split_df$Tb927_02_v4$start + 988120
split_df$Tb927_02_v4$end <- split_df$Tb927_02_v4$end + 988120

split_df$Tb927_03_v4$start <- split_df$Tb927_03_v4$start + 3137048
split_df$Tb927_03_v4$end <- split_df$Tb927_03_v4$end + 3137048

split_df$Tb927_04_v4$start <- split_df$Tb927_04_v4$start + 4739877
split_df$Tb927_04_v4$end <- split_df$Tb927_04_v4$end + 4739877

split_df$Tb927_05_v4$start <- split_df$Tb927_05_v4$start + 6207145
split_df$Tb927_05_v4$end <- split_df$Tb927_05_v4$end + 6207145

split_df$Tb927_06_v4$start <- split_df$Tb927_06_v4$start + 7573740
split_df$Tb927_06_v4$end <- split_df$Tb927_06_v4$end + 7573740

split_df$Tb927_07_v4$start <- split_df$Tb927_07_v4$start + 8987773
split_df$Tb927_07_v4$end <- split_df$Tb927_07_v4$end + 8987773

split_df$Tb927_08_v4$start <- split_df$Tb927_08_v4$start + 11163514
split_df$Tb927_08_v4$end <- split_df$Tb927_08_v4$end + 11163514

split_df$Tb927_09_v4$start <- split_df$Tb927_09_v4$start + 13639547
split_df$Tb927_09_v4$end <- split_df$Tb927_09_v4$end + 13639547

split_df$Tb927_10_v5$start <- split_df$Tb927_10_v5$start + 16034534
split_df$Tb927_10_v5$end <- split_df$Tb927_10_v5$end + 16034534

split_df$Tb927_11_01_v4$start <- split_df$Tb927_11_01_v4$start + 20024274
split_df$Tb927_11_01_v4$end <- split_df$Tb927_11_01_v4$end + 20024274

re_datafr <- bind_rows(split_df$Tb927_01_v4, split_df$Tb927_02_v4, split_df$Tb927_03_v4, split_df$Tb927_04_v4, split_df$Tb927_05_v4, split_df$Tb927_06_v4, split_df$Tb927_07_v4, split_df$Tb927_08_v4, split_df$Tb927_09_v4, split_df$Tb927_10_v5, split_df$Tb927_11_01_v4,) # Bind the rows to make a long df

# Plot the chromosome graphs 

sort(re_datafr$depth2)

ggplot(re_datafr, mapping = aes(x = start/1000, y = depth2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color = Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)") +
  ylab ("log2 ratio") +
  ggtitle("") 


  geom_point(aes(size = Duplicated, colour = Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) 

geom_label_repel(aes(label=Description), segment.size = 0.5, hjust=0, vjust=0)

C1 <- ggplot(split_df$Tb927_01_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)") +
  ylab ("log2 ratio") +
  ggtitle("Tb927_01_v4") +
  geom_point(aes(size = split_df$Tb927_01_v4$Duplicated, colour = split_df$Tb927_01_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), segment.size = 0.5, hjust=0, vjust=0)
  

C2 <- ggplot(split_df$Tb927_02_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_02_v4") +
  geom_point(aes(size = split_df$Tb927_02_v4$Duplicated, colour = split_df$Tb927_02_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)


C3 <- ggplot(split_df$Tb927_03_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_03_v4") +
  geom_point(aes(size = split_df$Tb927_03_v4$Duplicated, colour = split_df$Tb927_03_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)


C4 <- ggplot(split_df$Tb927_04_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_04_v4") +
  geom_point(aes(size = split_df$Tb927_04_v4$Duplicated, colour = split_df$Tb927_04_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)



C5 <- ggplot(split_df$Tb927_05_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_05_v4") +
  geom_point(aes(size = split_df$Tb927_05_v4$Duplicated, colour = split_df$Tb927_05_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)



C6 <- ggplot(split_df$Tb927_06_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_06_v4") +
  geom_point(aes(size = split_df$Tb927_06_v4$Duplicated, colour = split_df$Tb927_06_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)



C7 <- ggplot(split_df$Tb927_07_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_07_v4") +
  geom_point(aes(size = split_df$Tb927_07_v4$Duplicated, colour = split_df$Tb927_07_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)

C8 <- ggplot(split_df$Tb927_08_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_08_v4") +
  geom_point(aes(size = split_df$Tb927_08_v4$Duplicated, colour = split_df$Tb927_08_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)


C9 <-ggplot(split_df$Tb927_09_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_09_v4") +
  geom_point(aes(size = split_df$Tb927_09_v4$Duplicated, colour = split_df$Tb927_09_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)

C10 <- ggplot(split_df$Tb927_10_v5, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")   +
  ylab ("log2 ratio") +
  ggtitle("Tb927_10_v4") +
  geom_point(aes(size = split_df$Tb927_10_v5$Duplicated, colour = split_df$Tb927_10_v5$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), hjust=0, vjust=0, segment.size = 0.5)
  

C11 <- ggplot(split_df$Tb927_11_01_v4, mapping = aes(x = start, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)")  +
  ylab ("log2 ratio") +
  ggtitle("Tb927_11.01_v4") +
  geom_point(aes(size = split_df$Tb927_11_01_v4$Duplicated, colour = split_df$Tb927_11_01_v4$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description),hjust=0, vjust=0, segment.size = 0.5)

ggplot(dup_datafr, aes(chromosome)) +
  geom_bar(aes(fill=Cell_line)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylab("Count")
  
  
ggarrange(C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, Summ, nrow = 6, ncol = 2, common.legend = TRUE)

##############################################################################################################################################################
# This section is only used to create some df for different analysis

wide <- reshape(re_datafr, idvar = "gene", timevar = "Cell_line", direction = "wide") 

dup_datalist <- datalist # new df for that purpose
dup_datalist$Clone2$depth2[dup_datalist$Clone2$depth2 < 0.585 & dup_datalist$Clone2$depth2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$Clone3$depth2[dup_datalist$Clone3$depth2 < 0.585 & dup_datalist$Clone3$depth2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$Clone4$depth2[dup_datalist$Clone4$depth2 < 0.585 & dup_datalist$Clone4$depth2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$Clone5$depth2[dup_datalist$Clone5$depth2 < 0.585 & dup_datalist$Clone5$depth2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$START$depth2[dup_datalist$START$depth2 < 0.585 & dup_datalist$START$depth2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$END$depth2[dup_datalist$END$depth2 < 0.585 & dup_datalist$END$depth2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes

dup_datalist$Clone2 <- na.omit(dup_datalist$Clone2) # Omit genes which show no variation in any cell line 
dup_datalist$Clone3 <- na.omit(dup_datalist$Clone3) # Omit genes which show no variation in any cell line
dup_datalist$Clone4 <- na.omit(dup_datalist$Clone4) # Omit genes which show no variation in any cell line
dup_datalist$Clone5 <- na.omit(dup_datalist$Clone5) # Omit genes which show no variation in any cell line
dup_datalist$START <- na.omit(dup_datalist$START) # Omit genes which show no variation in any cell line
dup_datalist$END <- na.omit(dup_datalist$END) # Omit genes which show no variation in any cell line

dup_datafr <- bind_rows(dup_datalist$Clone2, dup_datalist$Clone3, dup_datalist$Clone4, dup_datalist$Clone5, dup_datalist$START, dup_datalist$END, .id = 'Cell_line') # bind into a long format
dup_datafr = subset(dup_datafr, select = -c(Description) ) # Remove description column, excess NA's

dup_datafr$Cell_line[dup_datafr$Cell_line == 1] <- "Clone 2"  # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 2] <- "Clone 3" # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 3] <- "Clone 4" # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 4] <- "Clone 5" # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 5] <- "Pooled" # rename the DF to meaningful 

dup_wide <- reshape(dup_datafr, idvar = "gene", timevar = "Cell_line", direction = "wide")

write.csv(wide, file = "wide.csv")
write.csv(datafr, file = "datafr.csv")
write.csv(dup_wide, file = "dup_wide.csv")
