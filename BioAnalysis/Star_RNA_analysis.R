# Star alignment to mRNA differential expression analysis 3-29-21

#Libraries
library(DESeq2)
library(clusterProfiler)
library(tximport)
library(org.Mm.eg.db)
library(ggplot2)
library(readr)
library(tidyverse)
library(dplyr)
library(stringr)
# process the data into a gene counts file
setwd("/mnt/storage/mskaro1/ATXN/mRNA/concatenated/geneCounts")
read_counts <- list.files()

makeGeneCounts <- function(read_counts) {
  cnt = 0
  for(i in read_counts){
    print(i)
    dat <- data.table::fread(i, header = TRUE)
    #print(i)
    colnames(dat) <- c("Ensembl","unstranded_count","S1","S2")
    print(colnames(dat))
    pattern <- "[:alnum:]{2,3}-[:alnum:]{2,3}"
    pattern2 <- '[^_]+'
    match <- i %>% str_extract(pattern2)
    
    if(cnt == 0){
      temp <- dat %>%
        select(c(Ensembl,S2))
      
      colnames(temp) <- c("Ensembl", match)
      cnt = cnt +1
    }else{
      dat <- dat %>% dplyr::select(c(Ensembl,S2))
      colnames(dat) <- c("Ensembl", match)
      temp <- left_join(temp,dat, by = "Ensembl")
      cnt = cnt +1
    }
    
    print(str_glue("Processing: {i}"))
    
  }
  df <- temp[4:length(temp$Ensembl),]
}


df <- makeGeneCounts(read_counts)
write.csv(df, "ATXN_mouse_RNAseq_counts.csv")
###############################################
setwd("/mnt/storage/mskaro1/ATXN/sra_downloads/mRNA_downloads/geneCounts")
read_counts <- list.files()
df2 <- makeGeneCounts(read_counts)
colnames(df2) <- c("Ensembl","SRR1552444","SRR1552445","SRR1552446",
                   "SRR1552447","SRR1552448","SRR1552449","SRR1552450",
                   "SRR1552451","SRR1552452","SRR1552453","SRR1552454","SRR1552455")
###############################################

mammary_counts <- left_join(df,df2, by="Ensembl")

write.csv(mammary_counts,"Mammary_mRNA_gene_counts.csv")


