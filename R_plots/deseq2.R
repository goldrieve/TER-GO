#Running DESEQ2

#Installing required packages
#if (!requireNamespace("BiocManager", "RColorBrewer", "DESeq2", "ggplot2", quietly = TRUE))
#  install.packages(c("BiocManager", "RColorBrewer", "DESeq2", "ggplot2"))

#if (!requireNamespace("tximport", "readr", "tximportData", "AnnotationDbi", "IHW", "vsn", "pheatmap", "apeglm", quietly = TRUE))
#  BiocManager::install(c("tximport", "readr", "tximportData", "AnnotationDbi", "IHW", "vsn", "pheatmap", "apeglm"))

#Set up the working directories
dir <- system.file("extdata", package="tximportData")
sample_dir <- ("/Users/s1886853/TERGO/Monomorph/DE/quants")
setwd("/Users/s1886853/TERGO/Monomorph/DE")
wd <- ("/Users/s1886853/TERGO/Monomorph/DE")

#Read in the meta data and modify it for tximport
samples <- read.table(file.path(wd,"samples.txt"), header=TRUE)
rownames(samples) <- samples$sample
samples[,c("spp","stage","line","sample")]

samples_UPA <- samples[ which(samples$line=='UPA') ,]
samples_NEK <- samples[ which(samples$line=='NEK') ,]

####################################################################
# UPA analysis
####################################################################

#Set up directory to read in quant.sf
files <- file.path(wd,"quants", samples_UPA$sample, "quant.sf")
names(files) <- samples_UPA$sample

#Make a txdb which is used to create tx2gene
library(GenomicFeatures)
txdb = makeTxDbFromGFF('TriTrypDB-46_TbruceiTREU927.gff')
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, k, "GENEID", "TXNAME")

#Tximport and set up design
library (tximport)
txi <- tximport(files, type="salmon", tx2gene=tx2gene)

#Set up DESeq2 for a single design analysis
library (DESeq2)
ddsTxi_UPA <- DESeqDataSetFromTximport(txi,
                                   colData = samples_UPA,
                                   design = ~ stage)
#Keep genes above 10

keep_UPA <- rowSums(counts(ddsTxi_UPA)) >= 10
dds_UPA <- ddsTxi_UPA[keep_UPA,]

#Specify the reference level
dds_UPA$stage <- relevel(dds_UPA$stage, ref = "Start")
dds_UPA$stage <- droplevels(dds_UPA$stage)

#Perform DESeq2
dds_UPA <- DESeq(dds_UPA)
resultsNames(dds_UPA)

####################################################################
# Transforming the data for visualisation
####################################################################
ntd_UPA <- normTransform(dds_UPA)
# this gives log2(n + 1)
ntd_UPA <- normTransform(dds_UPA)
library("vsn")
meanSdPlot(assay(ntd_UPA))

#Many transformation options available - VSD seems most appropriate
vsd_UPA <- vst(dds_UPA, blind=TRUE)
meanSdPlot(assay(vsd_UPA))

####################################################################
# Sample clustering
####################################################################

library("RColorBrewer")
sampleDists_UPA <- dist(t(assay(vsd_UPA)))
sampleDistMatrix_UPA <- as.matrix(sampleDists_UPA)
colnames(sampleDistMatrix_UPA) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix_UPA,
         clustering_distance_rows=sampleDists_UPA,
         clustering_distance_cols=sampleDists_UPA,
         col=colors)

plotPCA(vsd_UPA, intgroup=c("stage"))

####################################################################
# Heatmap of top genes
####################################################################

library("pheatmap")

topVarGenes <- head(order(rowVars(assay(vsd_UPA)), decreasing = TRUE), 100)

mat_UPA  <- assay(vsd_UPA)[ topVarGenes, ]
mat_UPA  <- mat_UPA - rowMeans(mat_UPA)
anno_UPA <- as.data.frame(colData(vsd_UPA)[, c("stage","sample")])
pheatmap(mat_UPA, annotation_col = anno_UPA)

####################################################################
# Perform the comparisons
####################################################################

res_ST_V_INT_UPA <- results(dds_UPA, contrast=c("stage","Intermediate", "Start"))
res_ST_V_END_UPA <- results(dds_UPA, contrast=c("stage","End", "Start"))
res_INT_V_END_UPA <- results(dds_UPA, contrast=c("stage", "End", "Intermediate"))

#Summarise those results
summary(res_ST_V_INT_UPA)
sum(res_ST_V_INT_UPA$padj < 0.1, na.rm=TRUE)

summary(res_ST_V_END_UPA)
sum(res_ST_V_END_UPA$padj < 0.1, na.rm=TRUE)

summary(res_INT_V_END_UPA)
sum(res_INT_V_END_UPA$padj < 0.1, na.rm=TRUE)

#Perform independent hypothesis weighting for p-value filtering

library("IHW")
resIHW_UPA <- results(dds_UPA, filterFun=ihw)

#Summarise those results
summary(resIHW_UPA)
sum(resIHW_UPA$padj < 0.1, na.rm=TRUE)
metadata(resIHW_UPA)$ihwResult

#Perform alternative shrinkage with ashr
library(ashr)
res_ST_V_INT_ashr_UPA <- lfcShrink(dds_UPA, contrast=c("stage","Intermediate", "Start"), type="ashr")
res_ST_V_END_ashr_UPA <- lfcShrink(dds_UPA, contrast=c("stage","End", "Start"), type="ashr")
res_INT_V_END_ashr_UPA <- lfcShrink(dds_UPA, contrast=c("stage", "End", "Intermediate"), type="ashr")

#Plot alternative shrinkage estimation for all results using ashr
par(mfrow=c(1,3), mar=c(4,4,2,1))
xlim <- c(1,1e5); ylim <- c(-3,3)
plotMA(res_ST_V_INT_ashr_UPA, xlim=xlim, ylim=ylim, main="Start vs intermediate")
plotMA(res_ST_V_END_ashr_UPA, xlim=xlim, ylim=ylim, main="Start vs end")
plotMA(res_INT_V_END_ashr_UPA, xlim=xlim, ylim=ylim, main="Intermediate vs end")

####################################################################
# Export DF to CSV
####################################################################

#Save the DE analysis
library(data.table)

#Rename the df's
res_ST_V_INT_ashr_UPA_DF <- setDT(as.data.frame(res_ST_V_INT_ashr_UPA), keep.rownames = TRUE)[]
setnames(res_ST_V_INT_ashr_UPA_DF, old=c("log2FoldChange","padj"), new=c("SVI_UPA_log2FoldChange","SVI_UPA_padj"))
res_ST_V_INT_ashr_UPA_DF[, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

res_ST_V_END_ashr_UPA_DF <- setDT(as.data.frame(res_ST_V_END_ashr_UPA), keep.rownames = TRUE)[]
setnames(res_ST_V_END_ashr_UPA_DF, old=c("log2FoldChange","padj"), new=c("SVE_UPA_log2FoldChange","SVE_UPA_padj"))
res_ST_V_END_ashr_UPA_DF[, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

res_INT_V_END_ashr_UPA_DF <- setDT(as.data.frame(res_INT_V_END_ashr_UPA), keep.rownames = TRUE)[]
setnames(res_INT_V_END_ashr_UPA_DF , old=c("log2FoldChange","padj"), new=c("IVE_UPA_log2FoldChange","IVE_UPA_padj"))
res_INT_V_END_ashr_UPA_DF [, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

#Merge and write
UPA_df <- merge(res_ST_V_INT_ashr_UPA_DF, res_ST_V_END_ashr_UPA_DF, by = ("rn"))
UPA_df <- merge(res_INT_V_END_ashr_UPA_DF, UPA_df, by = ("rn"))
write.csv(UPA_df, 
          file="UPA_results.csv")

#Save the normalised count matrix and write
write.csv(as.data.frame(assay(vsd_UPA)), 
          file="UPA_normalised_counts.csv")

####################################################################
# NEK analysis
####################################################################


#Set up directory to read in quant.sf
files <- file.path(wd,"quants", samples_NEK$sample, "quant.sf")
names(files) <- samples_NEK$sample

#Make a txdb which is used to create tx2gene
library(GenomicFeatures)
txdb = makeTxDbFromGFF('TriTrypDB-46_TbruceiTREU927.gff')
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, k, "GENEID", "TXNAME")

#Tximport and set up design
library (tximport)
txi <- tximport(files, type="salmon", tx2gene=tx2gene)

#Set up DESeq2 for a single design analysis
library (DESeq2)
ddsTxi_NEK <- DESeqDataSetFromTximport(txi,
                                       colData = samples_NEK,
                                       design = ~ stage)
#Keep genes above 10

keep_NEK <- rowSums(counts(ddsTxi_NEK)) >= 10
dds_NEK <- ddsTxi_NEK[keep_NEK,]

#Specify the reference level
dds_NEK$stage <- relevel(dds_NEK$stage, ref = "Start")
dds_NEK$stage <- droplevels(dds_NEK$stage)

#Perform DESeq2
dds_NEK <- DESeq(dds_NEK)
resultsNames(dds_NEK)

####################################################################
# Transforming the data for visualisation
####################################################################
ntd_NEK <- normTransform(dds_NEK)
# this gives log2(n + 1)
ntd_NEK <- normTransform(dds_NEK)
library("vsn")
meanSdPlot(assay(ntd_NEK))

#Many transformation options available - VSD seems most appropriate
vsd_NEK <- vst(dds_NEK, blind=TRUE)
meanSdPlot(assay(vsd_NEK))

####################################################################
# Sample clustering
####################################################################

library("RColorBrewer")
sampleDists_NEK <- dist(t(assay(vsd_NEK)))
sampleDistMatrix_NEK <- as.matrix(sampleDists_NEK)
colnames(sampleDistMatrix_NEK) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix_NEK,
         clustering_distance_rows=sampleDists_NEK,
         clustering_distance_cols=sampleDists_NEK,
         col=colors)

plotPCA(vsd_NEK, intgroup=c("stage"))

####################################################################
# Heatmap of top genes
####################################################################

library("pheatmap")

topVarGenes <- head(order(rowVars(assay(vsd_NEK)), decreasing = TRUE), 100)

mat_NEK  <- assay(vsd_NEK)[ topVarGenes, ]
mat_NEK  <- mat_NEK - rowMeans(mat_NEK)
anno_NEK <- as.data.frame(colData(vsd_NEK)[, c("stage","sample")])
pheatmap(mat_NEK, annotation_col = anno_NEK)

####################################################################
# Perform the comparisons
####################################################################

res_ST_V_INT_NEK <- results(dds_NEK, contrast=c("stage","Intermediate", "Start"))
res_ST_V_END_NEK <- results(dds_NEK, contrast=c("stage","End", "Start"))
res_INT_V_END_NEK <- results(dds_NEK, contrast=c("stage", "End", "Intermediate"))

#Summarise those results
summary(res_ST_V_INT_NEK)
sum(res_ST_V_INT_NEK$padj < 0.1, na.rm=TRUE)

summary(res_ST_V_END_NEK)
sum(res_ST_V_END_NEK$padj < 0.1, na.rm=TRUE)

summary(res_INT_V_END_NEK)
sum(res_INT_V_END_NEK$padj < 0.1, na.rm=TRUE)

#Perform independent hypothesis weighting for p-value filtering

library("IHW")
resIHW_NEK <- results(dds_NEK, filterFun=ihw)

#Summarise those results
summary(resIHW_NEK)
sum(resIHW_NEK$padj < 0.1, na.rm=TRUE)
metadata(resIHW_NEK)$ihwResult

#Perform alternative shrinkage with ashr
library(ashr)
res_ST_V_INT_ashr_NEK <- lfcShrink(dds_NEK, contrast=c("stage","Intermediate", "Start"), type="ashr")
res_ST_V_END_ashr_NEK <- lfcShrink(dds_NEK, contrast=c("stage","End", "Start"), type="ashr")
res_INT_V_END_ashr_NEK <- lfcShrink(dds_NEK, contrast=c("stage", "End", "Intermediate"), type="ashr")

#Plot alternative shrinkage estimation for all results using ashr
par(mfrow=c(1,3), mar=c(4,4,2,1))
xlim <- c(1,1e5); ylim <- c(-3,3)
plotMA(res_ST_V_INT_ashr_NEK, xlim=xlim, ylim=ylim, main="Start vs intermediate")
plotMA(res_ST_V_END_ashr_NEK, xlim=xlim, ylim=ylim, main="Start vs end")
plotMA(res_INT_V_END_ashr_NEK, xlim=xlim, ylim=ylim, main="Intermediate vs end")

####################################################################
# Export DF to CSV
####################################################################

#Save the DE analysis
library(data.table)

#Rename the df's
res_ST_V_INT_ashr_NEK_DF <- setDT(as.data.frame(res_ST_V_INT_ashr_NEK), keep.rownames = TRUE)[]
setnames(res_ST_V_INT_ashr_NEK_DF, old=c("log2FoldChange","padj"), new=c("SVI_NEK_log2FoldChange","SVI_NEK_padj"))
res_ST_V_INT_ashr_NEK_DF[, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

res_ST_V_END_ashr_NEK_DF <- setDT(as.data.frame(res_ST_V_END_ashr_NEK), keep.rownames = TRUE)[]
setnames(res_ST_V_END_ashr_NEK_DF, old=c("log2FoldChange","padj"), new=c("SVE_NEK_log2FoldChange","SVE_NEK_padj"))
res_ST_V_END_ashr_NEK_DF[, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

res_INT_V_END_ashr_NEK_DF <- setDT(as.data.frame(res_INT_V_END_ashr_NEK), keep.rownames = TRUE)[]
setnames(res_INT_V_END_ashr_NEK_DF , old=c("log2FoldChange","padj"), new=c("IVE_NEK_log2FoldChange","IVE_NEK_padj"))
res_INT_V_END_ashr_NEK_DF [, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

#Merge and write
NEK_df <- merge(res_ST_V_INT_ashr_NEK_DF, res_ST_V_END_ashr_NEK_DF, by = ("rn"))
NEK_df <- merge(res_INT_V_END_ashr_NEK_DF, NEK_df, by = ("rn"))
write.csv(NEK_df, 
          file="NEK_results.csv")

#Save the normalised count matrix and write
write.csv(as.data.frame(assay(vsd_NEK)), 
          file="NEK_normalised_counts.csv")

####################################################################
# Combined
####################################################################
#Set up directory to read in quant.sf
files <- file.path(wd,"quants", samples$sample, "quant.sf")
names(files) <- samples$sample

#Make a txdb which is used to create tx2gene
library(GenomicFeatures)
txdb = makeTxDbFromGFF('TriTrypDB-46_TbruceiTREU927.gff')
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, k, "GENEID", "TXNAME")

#Tximport and set up design
library (tximport)
txi <- tximport(files, type="salmon", tx2gene=tx2gene)

#Set up DESeq2 for a single design analysis
library (DESeq2)
ddsTxi_combi <- DESeqDataSetFromTximport(txi,
                                       colData = samples,
                                       design = ~ stage + line)
#Keep genes above 10

keep_combi <- rowSums(counts(ddsTxi_combi)) >= 10
dds_combi <- ddsTxi_combi[keep_combi,]

#Specify the reference level
dds_combi$stage <- relevel(dds_combi$stage, ref = "Start")
dds_combi$stage <- droplevels(dds_combi$stage)

#Perform DESeq2
dds_combi <- DESeq(dds_combi)
resultsNames(dds_combi)

####################################################################
# Transforming the data for visualisation
####################################################################
ntd_combi <- normTransform(dds_combi)
# this gives log2(n + 1)
ntd_combi <- normTransform(dds_combi)
library("vsn")
meanSdPlot(assay(ntd_combi))

#Many transformation options available - VSD seems most appropriate
vsd_combi <- vst(dds_combi, blind=TRUE)
meanSdPlot(assay(vsd_combi))

####################################################################
# Sample clustering
####################################################################

library("RColorBrewer")
sampleDists_combi <- dist(t(assay(vsd_combi)))
sampleDistMatrix_combi <- as.matrix(sampleDists_combi)
colnames(sampleDistMatrix_combi) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix_combi,
         clustering_distance_rows=sampleDists_combi,
         clustering_distance_cols=sampleDists_combi,
         col=colors)

plotPCA(vsd_combi, intgroup=c("stage", "line"))

####################################################################
# Heatmap of top genes
####################################################################

library("pheatmap")

topVarGenes <- head(order(rowVars(assay(vsd_combi)), decreasing = TRUE), 100)

mat_combi  <- assay(vsd_combi)[ topVarGenes, ]
mat_combi  <- mat_combi - rowMeans(mat_combi)
anno_combi <- as.data.frame(colData(vsd_combi)[, c("stage","sample")])
pheatmap(mat_combi, annotation_col = anno_combi)

####################################################################
# Perform the comparisons
####################################################################

res_ST_V_INT_combi <- results(dds_combi, contrast=c("stage","Intermediate", "Start"))
res_ST_V_END_combi <- results(dds_combi, contrast=c("stage","End", "Start"))
res_INT_V_END_combi <- results(dds_combi, contrast=c("stage", "End", "Intermediate"))
res_NEK_V_UPA_combi <- results(dds_combi, contrast=c("line", "UPA", "NEK"))

#Summarise those results
summary(res_ST_V_INT_combi)
sum(res_ST_V_INT_combi$padj < 0.1, na.rm=TRUE)

summary(res_ST_V_END_combi)
sum(res_ST_V_END_combi$padj < 0.1, na.rm=TRUE)

summary(res_INT_V_END_combi)
sum(res_INT_V_END_combi$padj < 0.1, na.rm=TRUE)

#Perform independent hypothesis weighting for p-value filtering

library("IHW")
resIHW_combi <- results(dds_combi, filterFun=ihw)

#Summarise those results
summary(resIHW_combi)
sum(resIHW_combi$padj < 0.1, na.rm=TRUE)
metadata(resIHW_combi)$ihwResult

#Perform alternative shrinkage with ashr
library(ashr)
res_ST_V_INT_ashr_combi <- lfcShrink(dds_combi, contrast=c("stage","Intermediate", "Start"), type="ashr")
res_ST_V_END_ashr_combi <- lfcShrink(dds_combi, contrast=c("stage","End", "Start"), type="ashr")
res_INT_V_END_ashr_combi <- lfcShrink(dds_combi, contrast=c("stage", "End", "Intermediate"), type="ashr")
res_NEK_V_UPA_ashr_combi <- lfcShrink(dds_combi, contrast=c("line", "UPA", "NEK"), type="ashr")

#Plot alternative shrinkage estimation for all results using ashr
par(mfrow=c(1,4), mar=c(4,4,2,1), pch =100)
xlim <- c(1,1e5); ylim <- c(-3,3)
plotMA(res_ST_V_INT_ashr_combi, xlim=xlim,  ylim=ylim, main="Start vs intermediate")
plotMA(res_ST_V_END_ashr_combi, xlim=xlim, ylim=ylim, main="Start vs end")
plotMA(res_INT_V_END_ashr_combi, xlim=xlim, ylim=ylim, main="Intermediate vs end")
plotMA(res_NEK_V_UPA_ashr_combi , xlim=xlim, ylim=ylim, main="NEK vs UPA")

####################################################################
# Export DF to CSV
####################################################################

#Save the DE analysis
library(data.table)

#Rename the df's
res_ST_V_INT_ashr_combi_DF <- setDT(as.data.frame(res_ST_V_INT_ashr_combi), keep.rownames = TRUE)[]
setnames(res_ST_V_INT_ashr_combi_DF, old=c("log2FoldChange","padj"), new=c("SVI_combi_log2FoldChange","SVI_combi_padj"))
res_ST_V_INT_ashr_combi_DF[, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

res_ST_V_END_ashr_combi_DF <- setDT(as.data.frame(res_ST_V_END_ashr_combi), keep.rownames = TRUE)[]
setnames(res_ST_V_END_ashr_combi_DF, old=c("log2FoldChange","padj"), new=c("SVE_combi_log2FoldChange","SVE_combi_padj"))
res_ST_V_END_ashr_combi_DF[, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

res_INT_V_END_ashr_combi_DF <- setDT(as.data.frame(res_INT_V_END_ashr_combi), keep.rownames = TRUE)[]
setnames(res_INT_V_END_ashr_combi_DF , old=c("log2FoldChange","padj"), new=c("IVE_combi_log2FoldChange","IVE_combi_padj"))
res_INT_V_END_ashr_combi_DF [, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

res_NEK_V_UPA_ashr_combi_DF <- setDT(as.data.frame(res_NEK_V_UPA_ashr_combi), keep.rownames = TRUE)[]
setnames(res_NEK_V_UPA_ashr_combi_DF , old=c("log2FoldChange","padj"), new=c("NVU_combi_log2FoldChange","NVU_combi_padj"))
res_NEK_V_UPA_ashr_combi_DF [, c("baseMean","lfcSE", "pvalue"):=NULL]  # remove two columns

#Merge and write
combi_df <- merge(res_ST_V_INT_ashr_combi_DF, res_ST_V_END_ashr_combi_DF, by = ("rn"))
combi_df <- merge(res_INT_V_END_ashr_combi_DF, combi_df, by = ("rn"))
combi_df <- merge(res_NEK_V_UPA_ashr_combi_DF, combi_df, by = ("rn"))
write.csv(combi_df, 
          file="combi_results.csv")

#Save the normalised count matrix and write
write.csv(as.data.frame(assay(vsd_combi)), 
          file="combi_normalised_counts.csv")

####################################################################
# Export all DF to CSV
####################################################################

#Save the DE analysis
Final_df <- merge(UPA_df, combi_df, by = ("rn"))
Final_df <- merge(NEK_df, Final_df, by = ("rn"))
Final_df
shared_df <- subset (Final_df, SVE_NEK_padj < 0.1 & SVE_UPA_padj < 0.1)
shared_df
write.csv(Final_df, file="Final_results.csv")
####################################################################
# Exploratory analysis
####################################################################
shared_df <- subset (Final_df, SVE_NEK_padj < 0.1 & SVE_UPA_padj < 0.1)
shared <- shared_df$rn

shared_df
shared_up <- subset (shared_df, SVE_NEK_log2FoldChange > 0 & SVE_UPA_log2FoldChange > 0)
shared_up_names <- shared_up$rn 

shared_down <- subset (shared_df, SVE_NEK_log2FoldChange < 0 & SVE_UPA_log2FoldChange < 0)
shared_down_names <- shared_down$rn 

same_d_mat <- rbind(shared_down, shared_up)
same_d_mat <- same_d_mat[, c("rn",'SVE_NEK_log2FoldChange', 'SVE_UPA_log2FoldChange', "SVE_UPA_padj", "SVE_NEK_padj"), with = FALSE]
same_d_log <- same_d_mat

up_mat  <- assay(vsd_combi)[ shared_up_names, ]
up_mat_calc  <- up_mat - rowMeans(up_mat)
anno <- as.data.frame(colData(vsd_combi)[, c("line","stage")])
sampleDists <- dist(t(assay(vsd_combi)))
pheatmap(up_mat_calc, annotation_col = anno, clustering_distance_cols = sampleDists, show_rownames = FALSE)

down_mat  <- assay(vsd_combi)[ shared_down_names, ]
down_mat_calc  <- down_mat - rowMeans(down_mat)
anno <- as.data.frame(colData(vsd_combi)[, c("line","stage")])
sampleDists <- dist(t(assay(vsd_combi)))
pheatmap(down_mat_calc, annotation_col = anno, clustering_distance_cols = sampleDists, show_rownames = FALSE)

same_d_mat <- rbind(up_mat, down_mat)
anno <- as.data.frame(colData(vsd_combi)[, c("line","stage")])
sampleDists <- dist(t(assay(vsd_combi)))
pheatmap(same_d_mat, annotation_col = anno, clustering_distance_cols = sampleDists, show_rownames = TRUE)

same_d_mat <- setDT(as.data.frame(same_d_mat), keep.rownames = TRUE)[]
same_d_final_df <- merge(same_d_log, same_d_mat, by = "rn") 
write.csv(same_d_final_df, file="DE_same_direction.csv")


#Plot alternative shrinkage estimation for all results using ashr
par(mfrow=c(1,3), mar=c(4,4,4,2), pch =100)
xlim <- c(1,1e5); ylim <- c(-3,3)
plotMA(res_ST_V_INT_ashr_NEK, alpha = 0.1,  xlim=xlim,  ylim=ylim, main="(a) NEK start vs end", cex.lab = 1.4)
plotMA(res_ST_V_END_ashr_UPA, alpha = 0.1,  xlim=xlim, ylim=ylim, main="(b) UPA start vs end", cex.lab = 1.4)
plotMA(res_NEK_V_UPA_ashr_combi, alpha = 0.1, xlim=xlim, ylim=ylim, main="(c) NEK vs UPA all stages", cex.lab = 1.4)


library(EnhancedVolcano)


EnhancedVolcano(res_ST_V_END_ashr_NEK,
                lab = rownames(res_ST_V_END_ashr_NEK),
                x = 'log2FoldChange',
                y = 'padj',
                xlim=c(-6,6),
                xlab = bquote(~Log[2]~ 'fold change'),
                ylab = bquote(~-Log[10]~adjusted~italic(P)),
                pCutoff = 0.0001,
                FCcutoff = 1.5,
                colAlpha = 1,
                legend=c('NS','Log2 FC','Adjusted p-value',
                         'Adjusted p-value & Log2 FC'),
                legendPosition = 'top',
                legendLabSize = 10,
                legendIconSize = 3.0,
                title = "NEK start vs end",
                subtitle = "")

EnhancedVolcano(res_ST_V_END_ashr_UPA,
                lab = rownames(res_ST_V_END_ashr_UPA),
                x = 'log2FoldChange',
                y = 'padj',
                xlim=c(-6,6),
                xlab = bquote(~Log[2]~ 'fold change'),
                ylab = bquote(~-Log[10]~adjusted~italic(P)),
                pCutoff = 0.0001,
                FCcutoff = 1.5,
                colAlpha = 1,
                legend=c('NS','Log2 FC','Adjusted p-value',
                         'Adjusted p-value & Log2 FC'),
                legendPosition = 'top',
                legendLabSize = 10,
                legendIconSize = 3.0,
                title = "UPA start vs end",
                subtitle = "")

EnhancedVolcano(res_ST_V_END_ashr_combi,
                lab = rownames(res_NEK_V_UPA_ashr_combi),
                x = 'log2FoldChange',
                y = 'padj',
                xlim=c(-6,6),
                xlab = bquote(~Log[2]~ 'fold change'),
                ylab = bquote(~-Log[10]~adjusted~italic(P)),
                pCutoff = 0.0001,
                FCcutoff = 1.5,
                colAlpha = 1,
                legend=c('NS','Log2 FC','Adjusted p-value',
                         'Adjusted p-value & Log2 FC'),
                legendPosition = 'top',
                legendLabSize = 10,
                legendIconSize = 3.0,
                title = "Combined start vs end",
                subtitle = "")

EnhancedVolcano(res_NEK_V_UPA_ashr_combi,
                lab = rownames(res_NEK_V_UPA_ashr_combi),
                x = 'log2FoldChange',
                y = 'padj',
                xlim=c(-6,6),
                xlab = bquote(~Log[2]~ 'fold change'),
                ylab = bquote(~-Log[10]~adjusted~italic(P)),
                pCutoff = 0.0001,
                FCcutoff = 1.5,
                colAlpha = 1,
                legend=c('NS','Log2 FC','Adjusted p-value',
                         'Adjusted p-value & Log2 FC'),
                legendPosition = 'top',
                legendLabSize = 10,
                legendIconSize = 3.0,
                title = "NEK vs UPA (every stage)",
                subtitle = "")
