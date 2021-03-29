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

# make the counts input matrix
for(i in read_counts){
      if(file.exists(i)){
        print(i)
        dat <- data.table::fread(i, header = TRUE)
        #print(i)
        colnames(dat) <- c("Ensembl","unstranded_count","S1","S2")

        pattern <- "[:alnum:]{2,3}-[:alnum:]{2,3}"
        pattern2 <- '[^_]+'
        match <- i %>% str_extract(pattern2)
        #print(match)
      
        
        
        
        
        
        
        
        
        
        
        }
}
  
