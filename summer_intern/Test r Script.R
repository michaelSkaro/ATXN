library(dplyr)
library(ggplot2)
library(corrplot)
library(cluster) 
library(fpc)
library(tidyverse)
library(cluster)
library(reshape2)
library(ggpubr)
library(GGally)

filename <- "irisdataset.csv"
file <- as.character(filename)
df <- read.csv(file)

summaryinfo <- function(df){ 
  str(df)
  dim(df)
  summary(df) 
}
corr <- function(df){ 
  corr <- cor(df[,1:4])
  round(corr,3) 
}
scatplot <- function(df){
  filename <- "irisdataset.csv"
  file <- as.character(filename)
  df <- read.csv(file)
  sp1 <- ggscatter(df, x = "Sepal.Length", y ="Sepal.Width",
                   color = "Species", palette = c("black","green","magenta"),
                   size = 3, alpha = 0.6)+
    border()
  sp2 <- ggscatter(df, x = "Sepal.Length", y = "Petal.Length",
                   color = "Species", palette = c("black","green","magenta"),
                   size = 3, alpha = 0.6)+
    border() 
  sp3 <- ggscatter(df, x = "Sepal.Length", y = "Petal.Width",
                   color = "Species", palette = c("black","green","magenta"),
                   size = 3, alpha = 0.6)+
    border() 
  sp4 <- ggscatter(df, x = "Sepal.Width", y = "Petal.Length",
                   color = "Species", palette = c("black","green","magenta"),
                   size = 3, alpha = 0.6)+
    border() 
  sp5 <- ggscatter(df, x = "Sepal.Width", y = "Petal.Width",
                   color = "Species", palette = c("black","green","magenta"),
                   size = 3, alpha = 0.6)+
    border() 
  sp6 <- ggscatter(df, x = "Petal.Width", y = "Petal.Length",
                   color = "Species", palette = c("black","green","magenta"),
                   size = 3, alpha = 0.6)+
    border() 
  
  
  
  ggarrange(sp1, sp2, sp3, sp4, sp5, sp6, ncol = 3, nrow = 2,  align = "hv", common.legend = TRUE)
}
histplot <- function(df){
  hp1 <- gghistogram(df, x="Sepal.Length", color="Species", fill="Species", palette = c("black", "green", "magenta"))
  hp2 <- gghistogram(df), x="Sepal.Width", color="Species", fill="Species", palette = c("black", "green", "magenta"))
  hp3 <- gghistogram(df, x="Petal.Length", color="Species", fill="Species", palette = c("black", "green", "magenta"))
  hp4 <- gghistogram(df, x="Petal.Width", color="Species", fill="Species", palette = c("black", "green", "magenta"))
  
  ggarrange(hp1, hp2, hp3, hp4, ncol = 2, nrow = 2,  align = "hv", common.legend = TRUE)
  
}

summaryinfo(df)
corr(df)
scatplot(df)
histplot(df)

iriscordata <- corr(df)
write(iriscordata)
irissuminfo <-  summaryinfo(df)
write(irissuminfo)
irisscatplot <- scatplot(df)
write(irisscatplot)
irishistplot <- histplot(df)
write(irishistplot)