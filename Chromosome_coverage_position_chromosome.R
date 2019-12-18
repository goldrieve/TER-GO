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

filelist = list.files(pattern = ".*.txt")
datalist = lapply(filelist, function(x)read.table(x, header=T)) 
desc <- read.csv(file.choose()) #needed to add genes which all have duplications

datalist$Clone2 <- (datalist[[1]]) # rename the df in the list
datalist$Clone3 <- (datalist[[2]]) # rename the df in the list
datalist$Clone4 <- (datalist[[3]]) # rename the df in the list
datalist$Clone5 <- (datalist[[4]]) # rename the df in the list
datalist$Pooled <- (datalist[[5]]) # rename the df in the list

datalist$Clone2$Description=desc$description # add the description of genes which all have duplications
datafr <- bind_rows(datalist$Clone2, datalist$Clone3, datalist$Clone4, datalist$Clone5, datalist$Pooled, .id = 'Cell_line') # Bind the rows to make a long df
#datafr$start<- datafr$start / 1000 # Divide the start length to get kb value

datafr$Description[datafr$Description == "#N/A"] <- " " # Remove the na so the graph looks pretty
datafr$Cell_line[datafr$Cell_line == 1] <- "Clone 2"  # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 2] <- "Clone 3" # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 3] <- "Clone 4" # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 4] <- "Clone 5" # rename the DF to meaningful 
datafr$Cell_line[datafr$Cell_line == 5] <- "Pooled" # rename the DF to meaningful 

reduced <- datafr # Creating a new df to add column to datafr
reduced$log2[reduced$log2 < 0.585 & reduced$log2 > -1] <- NA #Removed all values inside threshold
datafr$Duplicated=reduced$log2 # Add the new column, with genes which have aneuploidy, to datafr
datafr$Duplicated[datafr$Duplicated < 0.585 | datafr$Duplicated > -1] <- 1 # Change the actual log value to 1, used to make graph pretty
split_df <- split(datafr, with(datafr, interaction(chromosome)), drop = TRUE) #Split up the DF into chromosomes

split_df$Tb927_02_v4$start <- split_df$Tb927_02_v4$start + 988120
split_df$Tb927_02_v4$end <- split_df$Tb927_02_v4$end + 988120

tail (split_df$Tb927_10_v5)

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

ggplot(re_datafr, mapping = aes(x = start/1000, y = log2)) + 
  geom_hline(yintercept=-1, linetype="dashed",
             color = "black", size=.5) +
  geom_hline(yintercept=0.585, linetype="dashed",
             color = "black", size=.5) +
  geom_line(aes(color=Cell_line, group = Cell_line), size = 0.3) +
  xlab("Genomic position (kbp)") +
  theme (axis.text.x = element_text(size = 15),
         axis.text.y = element_text(size= 15),
         axis.title.y = element_text(size= 15),
         axis.title.x = element_text(size= 15),
         legend.text = element_text(size=15),
         legend.title = element_text(size=15)) +
  ylab ("log2 ratio") +
  ggtitle("") +
  geom_point(aes(size = re_datafr$Duplicated, colour = re_datafr$Cell_line), show.legend = FALSE) +
  scale_size_continuous(range = c(1.5,1.5)) +
  geom_label_repel(aes(label=Description), segment.size = 0.5, hjust=0, vjust=0)

##############################################################################################################################################################
# This section is only used to create some df for different analysis

wide <- reshape(datafr, idvar = "gene", timevar = "Cell_line", direction = "wide") 

dup_datalist <- datalist # new df for that purpose
dup_datalist$Clone2$log2[dup_datalist$Clone2$log2 < 0.585 & dup_datalist$Clone2$log2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$Clone3$log2[dup_datalist$Clone3$log2 < 0.585 & dup_datalist$Clone3$log2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$Clone4$log2[dup_datalist$Clone4$log2 < 0.585 & dup_datalist$Clone4$log2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$Clone5$log2[dup_datalist$Clone5$log2 < 0.585 & dup_datalist$Clone5$log2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes
dup_datalist$Pooled$log2[dup_datalist$Pooled$log2 < 0.585 & dup_datalist$Pooled$log2 > -1] <- NA #Removed all values above 10to enable chromsome wide changes

dup_datalist$Clone2 <- na.omit(dup_datalist$Clone2) # Omit genes which show no variation in any cell line 
dup_datalist$Clone3 <- na.omit(dup_datalist$Clone3) # Omit genes which show no variation in any cell line
dup_datalist$Clone4 <- na.omit(dup_datalist$Clone4) # Omit genes which show no variation in any cell line
dup_datalist$Clone5 <- na.omit(dup_datalist$Clone5) # Omit genes which show no variation in any cell line
dup_datalist$Pooled <- na.omit(dup_datalist$Pooled) # Omit genes which show no variation in any cell line

dup_datafr <- bind_rows(dup_datalist$Clone2, dup_datalist$Clone3, dup_datalist$Clone4, dup_datalist$Clone5, dup_datalist$Pooled, .id = 'Cell_line') # bind into a long format
dup_datafr = subset(dup_datafr, select = -c(Description) ) # Remove description column, excess NA's

dup_datafr$Cell_line[dup_datafr$Cell_line == 1] <- "Clone 2"  # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 2] <- "Clone 3" # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 3] <- "Clone 4" # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 4] <- "Clone 5" # rename the DF to meaningful 
dup_datafr$Cell_line[dup_datafr$Cell_line == 5] <- "Pooled" # rename the DF to meaningful 

dup_wide <- reshape(dup_datafr, idvar = "gene", timevar = "Cell_line", direction = "wide")
dup_table<- as.data.frame (table (dup_wide$`chromosome.Clone 2`))

protein <- as.data.frame(list(protein_no = c(1064672,1193948,1653225,1590432,1608198,1618915,2205233,2481190,3057547,4054025,5261801)))

dup_table$Freq <- dup_table$Freq/protein$protein_no
ggplot(dup_table, aes(x = Var1, y=Freq)) +
  geom_col() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylab("CNV/ chromosome length") +
  xlab("Chromosome")

write.csv(wide, file = "wide.csv")
write.csv(datafr, file = "datafr.csv")
write.csv(dup_wide, file = "dup_wide.csv")

#Mutation locations within the genome 

chr <- read.csv(file.choose()) #choose the snps v 927
chr <- subset(chr, CHROM == "Tb927_01_v5.1" | CHROM == "Tb927_02_v5.1" | CHROM == "Tb927_03_v5.1" | CHROM == "Tb927_04_v5.1" | CHROM == "Tb927_05_v5.1" | CHROM == "Tb927_06_v5.1" | CHROM == "Tb927_07_v5.1" | CHROM == "Tb927_08_v5.1" | CHROM == "Tb927_09_v5.1" | CHROM == "Tb927_10_v5.1" | CHROM == "Tb927_11_v5.1")
df <- as.data.frame (table (chr$CHROM))
df <- subset(df, Var1 == "Tb927_01_v5.1" | Var1 == "Tb927_02_v5.1" | Var1 == "Tb927_03_v5.1" | Var1 == "Tb927_04_v5.1" | Var1 == "Tb927_05_v5.1" | Var1 == "Tb927_06_v5.1" | Var1 == "Tb927_07_v5.1" | Var1 == "Tb927_08_v5.1" | Var1 == "Tb927_09_v5.1" | Var1 == "Tb927_10_v5.1" | Var1 == "Tb927_11_v5.1")

df$Freq2 <- df$Freq/protein$protein_no

ggplot(df, aes(x = Var1, y=Freq2)) +
  geom_col() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylab("Count") +
  ylab("Nucleotide polymorphisms/ chromosome length") +
  xlab("Chromosome")

