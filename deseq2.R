#Running DESEQ2

#Installing required packages
#if (!requireNamespace("BiocManager", "RColorBrewer", "DESeq2", "ggplot2", quietly = TRUE))
#  install.packages(c("BiocManager", "RColorBrewer", "DESeq2", "ggplot2"))

#if (!requireNamespace("tximport", "readr", "tximportData", "AnnotationDbi", "IHW", "vsn", "pheatmap", "apeglm", quietly = TRUE))
#  BiocManager::install(c("tximport", "readr", "tximportData", "AnnotationDbi", "IHW", "vsn", "pheatmap", "apeglm"))

#Set up the working directories
dir <- system.file("extdata", package="tximportData")
sample_dir <- ("/Users/s1886853/TERGO/Monomorph_DE/quants")
setwd("/Users/s1886853/TERGO/Monomorph_DE")
wd <- ("/Users/s1886853/TERGO/Monomorph_DE")

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
genes(txdb)
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, k, "GENEID", "TXNAME")

#Tximport and set up design
library (tximport)
txi <- tximport(files, type="salmon", tx2gene=tx2gene)

#Set up DESeq2 for a single design analysis
library (DESeq2)
ddsTxi <- DESeqDataSetFromTximport(txi,
                                   colData = samples_UPA,
                                   design = ~ stage)

#Keep genes above 10
keep <- rowSums(counts(ddsTxi)) >= 10
dds_UPA <- ddsTxi[keep,]

#Specify the reference level and drop intermediate atm
dds_UPA$stage <- relevel(dds_UPA$stage, ref = "Start")
dds_UPA$stage <- droplevels(dds_UPA$stage)

#Perform DESeq2
dds_UPA <- DESeq(dds_UPA)
resultsNames(dds_UPA)

res_ST_V_INT <- results(dds_UPA, contrast=c("stage","Start","Intermediate"))
res_ST_V_END <- results(dds_UPA, contrast=c("stage","Start","End"))
res_INT_V_END <- results(dds_UPA, contrast=c("stage","Intermediate","End"))

summary(res_ST_V_INT)
sum(res_ST_V_INT$padj < 0.1, na.rm=TRUE)

summary(res_ST_V_END)
sum(res_ST_V_END$padj < 0.1, na.rm=TRUE)

summary(res_INT_V_END)
sum(res_INT_V_END$padj < 0.1, na.rm=TRUE)

#Perform shrinkage of dataset with apeglm
library (apeglm)

#Perform alternative shrinkage with normal
res_ST_V_INT_Norm <- lfcShrink(dds_UPA, contrast=c("stage","Start","Intermediate"), type="normal")
res_ST_V_END_Norm <- lfcShrink(dds_UPA, contrast=c("stage","Start","End"), type="normal")
res_INT_V_END_Norm <- lfcShrink(dds_UPA, contrast=c("stage","Intermediate","End"), type="normal")


#Perform alternative shrinkage with ashr
library(ashr)
res_ST_V_INT_ashr <- lfcShrink(dds_UPA, contrast=c("stage","Start","Intermediate"), type="ashr")
res_ST_V_END_ashr <- lfcShrink(dds_UPA, contrast=c("stage","Start","End"), type="ashr")
res_INT_V_END_ashr <- lfcShrink(dds_UPA, contrast=c("stage","Intermediate","End"), type="ashr")

#Plot alternative shrinkage estimation for ST_V_INT
par(mfrow=c(1,3), mar=c(4,4,2,1))
xlim <- c(1,1e5); ylim <- c(-3,3)
plotMA(res_ST_V_INT, xlim=xlim, ylim=ylim, main="Unshrunk")
plotMA(res_ST_V_INT_Norm, xlim=xlim, ylim=ylim, main="normal")
plotMA(res_ST_V_INT_ashr, xlim=xlim, ylim=ylim, main="ashr")

#Plot alternative shrinkage estimation for ST_V_END
par(mfrow=c(1,3), mar=c(4,4,2,1))
xlim <- c(1,1e5); ylim <- c(-3,3)
plotMA(res_ST_V_END, xlim=xlim, ylim=ylim, main="Unshrunk")
plotMA(res_ST_V_END_Norm, xlim=xlim, ylim=ylim, main="normal")
plotMA(res_ST_V_END_ashr , xlim=xlim, ylim=ylim, main="ashr")

#Plot alternative shrinkage estimation for INT_V_END
par(mfrow=c(1,3), mar=c(4,4,2,1))
xlim <- c(1,1e5); ylim <- c(-3,3)
plotMA(res_INT_V_END , xlim=xlim, ylim=ylim, main="Unshrunk")
plotMA(res_INT_V_END_Norm, xlim=xlim, ylim=ylim, main="normal")
plotMA(res_INT_V_END_ashr, xlim=xlim, ylim=ylim, main="ashr")

#Perform independent hypothesis weighting for p-value filtering
library("IHW")
resIHW <- results(dds_UPA, filterFun=ihw)
summary(resIHW)
sum(resIHW$padj < 0.1, na.rm=TRUE)
metadata(resIHW)$ihwResult

####################################################################
# Plot counts
####################################################################
plotCounts(dds_UPA, gene=which.min(res_ST_V_END_ashr$padj), intgroup="stage")
d <- plotCounts(dds, gene=which.min(res_ST_V_END_ashr$padj), intgroup="stage", 
                returnData=TRUE)

library("ggplot2")
ggplot(d, aes(x=stage, y=count)) + 
  geom_point(position=position_jitter(w=0.1,h=0)) + 
  scale_y_log10(breaks=c(25,100,400))

mcols(res)$description

####################################################################
# Export DF to CSV
####################################################################

res_ST_V_END_ashr_DF <- as.data.frame(res_ST_V_END_ashr)
res_ST_V_INT_ashr_DF <- as.data.frame(res_ST_V_INT_ashr)

all_df <- merge(as.data.frame(res_ST_V_END_ashr),as.data.frame(res_ST_V_INT_ashr), by="baseMean")


write.csv(as.data.frame(res_sig_ST_V_END_APELGM), 
          file="APEGLM_results_ST_V_END.csv")

resSig <- subset(res_ST_V_INT_APELGM, padj < 0.1)
write.csv(as.data.frame(resSig), 
          file="condition_treated_results_sig.csv")

res_sig_ST_V_END_APELGM <- subset(res_ST_V_END_APELGM, padj < 0.1)
write.csv(as.data.frame(res_sig_ST_V_END_APELGM), 
          file="APEGLM_results_ST_V_END.csv")

####################################################################
# Transforming the data for visualisation
####################################################################

library("vsn")
vsd <- vst(dds_UPA, blind=FALSE)
rld <- rlog(dds_UPA, blind=FALSE)
ntd <- normTransform(dds_UPA)

meanSdPlot(assay(ntd))
meanSdPlot(assay(vsd))
meanSdPlot(assay(rld))

####################################################################
# Data quality assessment by sample clustering and visualization
####################################################################

library("pheatmap")

select <- order(rowMeans(counts(dds_UPA,normalized=TRUE)),
                decreasing=TRUE)[1:20]

df <- as.data.frame(colData(dds_UPA)[("stage")])

pheatmap(assay(ntd)[select,], cluster_rows=FALSE, show_rownames=FALSE,
         cluster_cols=FALSE, annotation_col=df)

pheatmap(assay(vsd)[select,], cluster_rows=FALSE, show_rownames=FALSE,
         cluster_cols=FALSE, annotation_col=df)

sampleDists <- dist(t(assay(vsd)))

library("RColorBrewer")

sampleDistMatrix <- as.matrix(sampleDists)

rownames(sampleDistMatrix) <- paste(sd$stage, sep="-")
colnames(sampleDistMatrix) <- NULL

colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

plotPCA(vsd, intgroup=c("stage"))

####################################################################
# Heatmap of top genes
####################################################################

topVarGenes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 20)

mat  <- assay(vsd)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(vsd)[, c("stage","sample")])
pheatmap(mat, annotation_col = anno)