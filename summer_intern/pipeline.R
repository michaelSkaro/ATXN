install.packages("DESeq2")
library(DESeq2)
install.packages("tximport")
library(tximport)
install.packages("readr")
library(readr)

filename <- "irisdataset.csv"
dir <- as.character(filename)
samples <- read.csv(dir)
samples$run <- factor(rep(c("A","B"),each=3))
samples[,c("sepal.width","sepal.length", "petal.width","petal.length","variety")]

files <- file.path(dir,"salmon", samples$species, "quant.sf.gz")
names(files) <- samples$run
tx2gene <- read_csv(file.path(dir, "tx2gene.gencode.v27.csv"))
txi <- tximport(files, type="salmon", tx2gene=tx2gene)
ddsTxi <- DESeqDataSetFromTximport(txi,
                                   colData = samples,
                                   design = ~ condition)




dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design= ~ batch + condition)
dds2 <- DESeq(dds)
