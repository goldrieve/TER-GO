if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
library("tximport")
library("readr")
library("tximportData")

dir <- system.file("extdata", package="tximportData")
sample_dir <- ("/Users/s1886853/TERGO/Monomorph_DE/quants")
setwd("/Users/s1886853/TERGO/Monomorph_DE")
wd <- ("/Users/s1886853/TERGO/Monomorph_DE")
samples <- read.table(file.path(wd,"samples.txt"), header=TRUE)
rownames(samples) <- samples$sample
samples[,c("spp","stage","line","sample")]

files <- file.path(wd,"quants", samples$sample, "quant.sf")
names(files) <- samples$sample
files
library(GenomicFeatures)

txdb = makeTxDbFromGFF('TriTrypDB-46_TbruceiTREU927.gtf')
library(AnnotationDbi)
saveDb(txdb, 'txdb.tb927')
txdb = loadDb(file = 'txdb.tb927')
genes(txdb)

k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, k, "GENEID", "TXNAME")

txi <- tximport(files, type="salmon", tx2gene=tx2gene)
library("DESeq2")
ddsTxi <- DESeqDataSetFromTximport(txi,
                                   colData = samples,
                                   design = ~ stage)
keep <- rowSums(counts(ddsTxi)) >= 10
dds <- ddsTxi[keep,]
dds <- DESeq(dds)

stage_res <- results(dds, contrast=c("line", "NEK", "UPA"))
resultsNames(dds)

BiocManager::install("apeglm")
resLFC <- lfcShrink(dds, coef="line_UPA_vs_NEK", type="apeglm")
resLFC
resOrdered <- res[order(res$pvalue),]
summary(res)

sum(res$padj < 0.1, na.rm=TRUE)

res05 <- results(dds, alpha=0.05)
summary(res05)
sum(res05$padj < 0.05, na.rm=TRUE)

BiocManager::install("IHW")
library("IHW")
resIHW <- results(dds, filterFun=ihw)
summary(resIHW)
sum(resIHW$padj < 0.1, na.rm=TRUE)
metadata(resIHW)$ihwResult

plotMA(res, ylim=c(-2,2))
plotMA(resLFC, ylim=c(-2,2))

idx <- identify(res$baseMean, res$log2FoldChange)
rownames(res)[idx]

colData(dds)

ddsMF <- dds

design(ddsMF) <- formula(~ stage + line)
ddsMF <- DESeq(ddsMF)

resMFType <- results(ddsMF,
                     contrast=c("stage", "Intermediate", "End"))
head(resMFType)

# this gives log2(n + 1)

vsd <- vst(dds, blind=FALSE)
rld <- rlog(dds, blind=FALSE)
head(assay(vsd), 3)

ntd <- normTransform(dds)
library("vsn")
meanSdPlot(assay(ntd))
meanSdPlot(assay(vsd))

library("pheatmap")

select <- order(rowMeans(counts(dds,normalized=TRUE)),
                decreasing=TRUE)[1:20]

df <- as.data.frame(colData(dds)[,c("stage","line")])
pheatmap(assay(ntd)[select,], cluster_rows=FALSE, show_rownames=FALSE,
         cluster_cols=FALSE, annotation_col=df)

pheatmap(assay(vsd)[select,], cluster_rows=FALSE, show_rownames=FALSE,
         cluster_cols=FALSE, annotation_col=df)

sampleDists <- dist(t(assay(vsd)))
library("RColorBrewer")
sampleDistMatrix <- as.matrix(sampleDists)

rownames(sampleDistMatrix) <- paste(vsd$line, vsd$stage, sep="-")
colnames(sampleDistMatrix) <- NULL

colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)


plotPCA(vsd, intgroup=c("line", "stage"))
library("ggplot2")
pcaData <- plotPCA(vsd, intgroup=c("stage", "line"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(PC1, PC2, color=stage, shape=line)) +
  geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) + 
  coord_fixed()

