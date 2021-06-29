install.packages("DESeq2")
library(DESeq2)
install.packages("tximport")
library(tximport)
install.packages("readr")
library(readr)
install.packages("ggpubr")
library(ggpubr)
install.packages("corrplot")
library(corrplot)


# You'll want to change this here. You should code it to accept an argument at the command line as your filename you wll be using.
# Or you can take a step further and direcly pass the directory.  

filename <- "irisdataset.csv"
dir <- as.character(filename)
samples <- read.csv(dir)
samples$run <- factor(rep(c("A","B"),each=3))
samples[,c("sepal.width","sepal.length", "petal.width","petal.length","variety")]


# So this won't fit with your data unless you make a directory called salmon, have quant.sf.gz files. I am not sure what the samples$species is doing but that
# will not be needed. 
files <- file.path(dir,"salmon", samples$species, "quant.sf.gz")
names(files) <- samples$run
tx2gene <- read_csv(file.path(dir, "tx2gene.gencode.v27.csv"))
txi <- tximport(files, type="salmon", tx2gene=tx2gene)
dds <- DESeqDataSetFromTximport(txi,
                                   colData = samples,
                                   design = ~ condition)
dds$condition <- factor(dds$condition, levels = c("untreated","treated"))

dds2 <- DESeq(dds)
res <- results(dds2)
res

# you'll want ot pull the streing name from the levels and point to contrast table. This will feel oddd but writing out variable names as strings
# won't automate. 

res <- results(dds2, name="condition_treated_vs_untreated")
res <- results(dds2, contrast=c("condition","treated","untreated"))
resultsNames(dds2)
resLFC <- lfcShrink(dds, coef="condition_treated_vs_untreated", type="apeglm")
resLFC
register(MulticoreParam(4))
cor<- function(dds){
  x <- c("dds2$healthy", "dds2$atriskbreast", "dds2$atriskliver", "dds2$illliver", "dds2$illbreast")
  cmb <- combn(x, 2)
  cor(cmb, method = c("pearson"))
}
cordf <- cpr(dds)
write(cordds)
parcoord <- function(dds2){
  parcoord(dds2[,1:4], col=df[,5],var.label=TRUE,oma=c(4,4,6,12))
  par(xpd=TRUE)
  legend(0.85,0.6, as.vector(unique(df$Species)),fill=c(1,2,3))
}
gptplot <- function(dds2){
  ggplot(dds2, aes(Sepal.Length, Sepal.Width, color = Species)) + 
    geom_point() + 
    scale_color_manual(values = c("black",
                                  "green",
                                  "magenta")) +
    geom_smooth(method = "lm")+
    theme_bw()
}

pcdf <- parcoord(dds2)
write(pcdf)
gptpt <- gptplot(dds2)
write(gptpt)
