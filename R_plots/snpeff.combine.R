setwd("/Users/s1886853/GATK/Tcomp_GATK/calls_v2/Lineage.vcf/Gene_lists")
file_list <- list.files(pattern="*.csv")       
library(dplyr)

data <- lapply(file_list, read.csv)
names(data) <- gsub("\\_snpEff_genes.csv$", "", file_list)

data$Equi_A <- data$Equi_A %>% rename_at(vars(-(1)), ~ paste0(., '_Equi_A'))
data$Equi_B <- data$Equi_B %>% rename_at(vars(-(1)), ~ paste0(., '_Equi_B'))
data$Equi <- data$Equi %>% rename_at(vars(-(1)), ~ paste0(., '_Equi'))
data$Evansi_A <- data$Evansi_A %>% rename_at(vars(-(1)), ~ paste0(., '_Evansi_A'))
data$Evansi_B <- data$Evansi_B %>% rename_at(vars(-(1)), ~ paste0(., '_Evansi_B'))
data$Evansi <- data$Evansi %>% rename_at(vars(-(1)), ~ paste0(., '_Evansi'))
data$Mono <- data$Mono %>% rename_at(vars(-(1)), ~ paste0(., '_Mono'))

require(tidyverse)

comb_df <- reduce(data, full_join, by = "X.GeneName")

write.csv(as.data.frame(comb_df), 
          file="bound.csv")

#Venn diagram
library(VennDiagram)
gene_list <- read.csv("shared_genes.csv",header=TRUE)

venn.diagram(
  x = list(gene_list$GeneId_Equi_A, gene_list$GeneId_Equi_B),
  filename = '14_venn_diagramm.png',
  output=TRUE)
