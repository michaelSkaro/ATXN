library(maps)
library(dplyr)
library(geosphere)

allc <- file.choose()
allcrd <- read.csv(allc)
allcrd 
cld <- file.choose()
cldrd <- read.csv(cld)
cldrd

plot_my_connection <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00ffbf"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00ffbf"), lwd=.3)
}
plot_my_connection1 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00ff84"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00ff84"), lwd=.3)
}
plot_my_connection2 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00ff62"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00ff62"), lwd=.3)
}
plot_my_connection3 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00ff2a"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00ff2a"), lwd=.3)
}
plot_my_connection4 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#09ff00"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#09ff00"), lwd=.3)
}
plot_my_connection5 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#2bff00"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#2bff00"), lwd=.3)
}
plot_my_connection6 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#2bcf0a"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#2bcf0a"), lwd=.3)
}

par(mar=c(0,0,0,0))
data1 <- (allcrd)
colnames(data1) <- c("longitude","latitude")
data2 <- (cldrd)
colnames(data2) <- c("longitude","latitude")
map('world',
      col="#b3b3b3", fill=TRUE, bg="white", lwd=0.05,
      mar=rep(0,4),border=0, ylim=c(-80,80) 
      )
points(x=cldrd$longitude, y=cldrd$latitude, col=c("magenta"), cex=(.7), pch=16)    
points(x=allcrd$longitude, y=allcrd$latitude, col=c("black"), cex=(.2), pch=16)

plot_my_connection(-120.7401385,47.7510741,133.775136,-25.274398)
plot_my_connection(133.775136,-25.274398,-120.7401385,47.7510741)

inter <- gcIntermediate(c(10.451526,51.165691), c(133.775136,-25.274398), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ff84"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-106.346771,56.130366), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-96.8410503,32.8143702), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(120.960515,23.69781), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-99.9018131,41.4925374), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-14.452362,14.497401), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

plot_my_connection(-120.7401385,47.7510741,133.775136,-25.274398)
plot_my_connection(133.775136,-25.274398,-120.7401385,47.7510741)

inter <- gcIntermediate(c(-120.7401385,47.7510741), c(-89.3985283,40.6331249), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(-120.7401385,47.7510741), c(-79.0192997,35.7595731), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(-120.7401385,47.7510741), c(-95.1449017,36.6309594), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ff62"), lwd=.3)

plot_my_connection(-74.0059728,40.7127753,120.960515,23.69781)
plot_my_connection(120.960515,23.69781,-74.0059728,40.7127753)

inter <- gcIntermediate(c(-74.0059728,40.7127753), c(-8.224454,39.399872), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

plot_my_connection1(-74.0059728,40.7127753,138.252924,36.204824)
plot_my_connection1(138.252924,36.204824,-74.0059728,40.7127753)

plot_my_connection(-74.0059728,40.7127753,133.775136,-25.274398)
plot_my_connection(133.775136,-25.274398,-74.0059728,40.7127753)

inter <- gcIntermediate(c(-74.0059728,40.7127753), c(45.079162,23.885942), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

plot_my_connection(-73.087749,41.6032207,133.775136,-25.274398)
plot_my_connection(133.775136,-25.274398,-73.087749,41.6032207)

plot_my_connection(-73.087749,41.6032207,120.960515,23.69781)
plot_my_connection(120.960515,23.69781,-73.087749,41.6032207)

inter <- gcIntermediate(c(5.291266,52.132633), c(-51.92528,-14.235004), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ff84"), lwd=.3)

inter <- gcIntermediate(c(5.291266,52.132633), c(133.775136,-25.274398), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-119.4179324,36.778261), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-111.0937311,34.0489281), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-120.960515,23.69781), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-3.74922,40.463667), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-106.346771,56.130366), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ff84"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-51.92528,-14.235004), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(133.775136,-25.274398), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#2bff00"), lwd=.3)

plot_my_connection4(114.305539,30.392849,-95.7422569,36.2244054)
plot_my_connection4(-95.7422569,36.2244054,114.305539,30.392849)

plot_my_connection6(114.305539,30.392849,-88.7878678,43.7844397)
plot_my_connection6(-88.7878678,43.7844397,114.305539,30.392849)

plot_my_connection(114.305539,30.392849,-119.4179324,36.778261)
plot_my_connection(-119.4179324,36.778261,114.305539,30.392849)

inter <- gcIntermediate(c(114.305539,30.392849), c(-3.435973,55.378051), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#2bcf0a"), lwd=.3)

inter <- gcIntermediate(c(114.305539,30.392849), c(-7.6920536,53.1423672), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(114.305539,30.392849), c(-19.020835,64.963051), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ff84"), lwd=.3)

plot_my_connection(114.305539,30.392849,-106.346771,56.130366)
plot_my_connection(-106.346771,56.130366,114.305539,30.392849)

inter <- gcIntermediate(c(2.213749,46.227638), c(-88.7878678,43.7844397), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(-3.435973,55.378051), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(21.758664,-4.038333), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(133.775136,-25.274398), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(4.469936,50.303887), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ff84"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(133.775136,-25.274398), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(-74.0059728,40.7127753), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(105.318756,61.32501), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(-19.020835,64.963051), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ff62"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(9.501785,56.26392), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(21.758664,-4.038333), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00ffbf"), lwd=.3)

legend(x="left", legend=c("1-2", "3-4", "5-6", "7-8", "9-10", "<39"),fil=c("#00ffbf","#00ff84","#00ff62","#00ff2a","#09ff00","#2bff00","#2bcf0a"), title="Gene Flow Density")