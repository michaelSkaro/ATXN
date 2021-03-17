# DESEQ from salmon quantification

#Libraries

library(DESeq2)
library(clusterProfiler)
library(tximport)
library(org.Mm.eg.db)
library(ggplot2)
library(readr)
library(tidyverse)
library(dplyr)
# import the merged counts files form the miRNA
miRNA <- data.table::fread("/mnt/storage/mskaro1/ATXN/results/miRNA_expression_counts.csv", header = TRUE) %>%
  dplyr::select(-V1)
miRNA_source <- data.table::fread("/mnt/storage/mskaro1/ATXN/results/MGI_source_counts_miRNA.txt", header = TRUE)
colnames(miRNA_source)[1] <- "miRNAID"

df.exp <- left_join(miRNA,miRNA_source, by ="miRNAID")
df.exp[is.na(df.exp)] <- 0
df.exp <- df.exp[complete.cases(df.exp)]
#write.csv(df.exp, "miRNA_counts_all.csv")

miRNA.exp <- df.exp


# aggregate the mRNA samples and make the correct metadata

# miRNA + mRNA annotation
anno <- data.table::fread("/mnt/storage/mskaro1/ATXN/Annotation/ATXN_sample_data_sheet.txt", header = TRUE)
# Get data from quantification directories that we will combine and into a dds object 

dir_ATXN_mRNA <- "/mnt/storage/mskaro1/ATXN/mRNA/concatenated/trimmed/quant"
dir_sra_mRNA <- "/mnt/storage/mskaro1/ATXN/sra_downloads/mRNA_downloads/trimmed/quant"
#dir_ATX_miRNA <- "/mnt/storage/mskaro1/ATXN/miRNA/concatenated/trimmed/quant"

# mRNA data
annomRNA <- anno %>%
  filter(Batch == 1 | Batch == 3)
# miRNA data
annomiRNA <- anno %>%
  filter(Batch == 2 | Batch == 4)

ATXN_mRNA_files <- file.path(dir_ATXN_mRNA,list.files(dir_ATXN_mRNA), "quant.sf")
sra_mRNA_files <- file.path(dir_sra_mRNA,list.files(dir_sra_mRNA), "quant.sf")
mRNA_files <- c(sra_mRNA_files,ATXN_mRNA_files)
mRNA_files <- mRNA_files[order(mRNA_files)]
annomRNA <- annomRNA[order(annomRNA$SampleID)]

names(mRNA_files) <- annomRNA$SampleID



txdb <- makeTxDbFromGFF(file = "/mnt/storage/mskaro1/ATXN/mouse_ref/gencode.vM24.annotation.gtf.gz",format = "gtf",organism = "Mus musculus")
k <- keys(txdb, keytype = "GENEID")

# this is fucking annoying
#detach("package:dplyr", unload=T)
tx2gene <- select(txdb, keys = k, keytype = "GENEID", columns = "TXNAME")
tx2gene <- tx2gene[,c(2,1)]
#tmp <- tx2gene
tx2gene$GENEID <- substr(tx2gene$GENEID,1,18)
tx2gene$TXNAME <- substr(tx2gene$TXNAME,1,18)
#library(dplyr)

txi.salmon <- tximport(mRNA_files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE, ignoreAfterBar = TRUE)
rownames(annomRNA) <- annomRNA$SampleID
annomRNA$Batch <- as.factor(annomRNA$Batch)
annomRNA <- annomRNA %>%
  dplyr::select(-c(Description,GSMID))
annomRNA <- annomRNA %>%
  dplyr::select(-c(sampleType))
dds <- DESeqDataSetFromTximport(txi.salmon,colData = annomRNA,
                                   design= ~ Tissue + condition)
dds$condition = relevel(dds$condition, "Normal")
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
dds <- DESeq(dds)
model.matrix(design(dds), colData(dds))
resultsNames(dds)
res <- results(dds, contrast = c("condition","Tumor","Normal"))


# Mammary mRNA
  # make mammary quant
  annoMammary <- annomRNA %>% filter(Tissue == "Mammary_Gland")
  rownames(annoMammary) <- annoMammary$SampleID
  mammary_files <- mRNA_files[names(mRNA_files) %in% annoMammary$SampleID] 
  annoMammary <- annoMammary %>%
    dplyr::select(-Batch)
  
  txi.salmon <- tximport(mammary_files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE, ignoreAfterBar = TRUE)
  
  dds <- DESeqDataSetFromTximport(txi.salmon,colData = annoMammary,design= ~ condition)
  dds$condition = relevel(dds$condition, "Normal")
  keep <- rowSums(counts(dds)) >= 10
  dds <- dds[keep,]
  dds <- DESeq(dds)
  resultsNames(dds)
  res <- results(dds, contrast = c("condition","Tumor","Normal"))
  resOrder <- as.data.frame(res[order(res$padj, decreasing = FALSE),])
  
  write.csv(resOrder,"Mammary_Gland_DE.csv")

# Liver mRNA

  annoLiver <- annomRNA %>% filter(Tissue == "Liver")
  rownames(annoLiver) <- annoLiver$SampleID
  Liver_files <- mRNA_files[names(mRNA_files) %in% annoLiver$SampleID] 
  annoLiver <- annoLiver %>%
    dplyr::select(-Batch)
  
  txi.salmon <- tximport(Liver_files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE, ignoreAfterBar = TRUE)
  
  dds <- DESeqDataSetFromTximport(txi.salmon,colData = annoLiver,design= ~ condition)
  dds$condition = relevel(dds$condition, "Normal")
  keep <- rowSums(counts(dds)) >= 10
  dds <- dds[keep,]
  dds <- DESeq(dds)
  resultsNames(dds)
  res <- results(dds)
  resOrder <- as.data.frame(res[order(res$padj, decreasing = FALSE),])
  
  write.csv(resOrder,"Liver_DE.csv")


  # Mammary res
  
  Mdat <- data.table::fread("Mammary_Gland_DE.csv", header = TRUE) %>%
    tibble::column_to_rownames("V1") %>%
    rownames_to_column("ENSEMBL")
  
  
  
  
  # Liver res
  
  Ldat <- data.table::fread("Liver_DE.csv", header = TRUE) %>%
    tibble::column_to_rownames("V1") %>%
    rownames_to_column("ENSEMBL")
  

  # Mammary differential expression enrichment analysis
  # we want the log2 fold change 
  mammary_gene_list <- Mdat$log2FoldChange
  
  # name the vector
  names(mammary_gene_list) <- Mdat$ENSEMBL
  
  # omit any NA values 
  gene_list<-na.omit(mammary_gene_list)
  
  # sort the list in decreasing order (required for clusterProfiler)
  gene_list = sort(gene_list, decreasing = TRUE)
  library(org.Mm.eg.db)
  gse <- gseGO(geneList=gene_list, 
               ont ="ALL", 
               keyType = "ENSEMBL", 
               nPerm = 10000, 
               minGSSize = 3, 
               maxGSSize = 800, 
               pvalueCutoff = 0.05, 
               verbose = TRUE, 
               OrgDb = org.Mm.eg.db, 
               pAdjustMethod = "BH")
  library(DOSE)
  dotplot(gse, showCategory=10)
  ridgeplot(gse) + labs(x = "enrichment distribution")

  
  # Liver differential expression enrichment analysis
  # we want the log2 fold change 
  Liver_gene_list <- Ldat$log2FoldChange
  
  # name the vector
  names(Liver_gene_list) <- Ldat$ENSEMBL
  names(Liver_gene_list) <- substr(names(Liver_gene_list),1,18)
  # omit any NA values 
  gene_list<-na.omit(Liver_gene_list)
  
  # sort the list in decreasing order (required for clusterProfiler)
  gene_list = sort(gene_list, decreasing = TRUE)
  library(org.Mm.eg.db)
  gse <- gseGO(geneList=gene_list, 
               ont ="ALL", 
               keyType = "ENSEMBL", 
               nPerm = 10000, 
               minGSSize = 3, 
               maxGSSize = 800, 
               pvalueCutoff = 0.05, 
               verbose = TRUE, 
               OrgDb = org.Mm.eg.db, 
               pAdjustMethod = "BH")
  library(DOSE)
  dotplot(gse, showCategory=10)
  ridgeplot(gse) + labs(x = "enrichment distribution")
