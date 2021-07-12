library(maps)
library(geosphere)
library(dplyr)

outl <- file.choose()
outlrd <- read.csv(outl)
outlrd 
cldam <- file.choose()
cldam <- read.csv(cldam)
cldam
cldas <- file.choose()
cldas <- read.csv(cldas)
cldas
cldeu <- file.choose()
cldeu <- read.csv(cldeu)
cldeu
plot_my_connection <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00e6ac"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00e6ac"), lwd=.3)
}
plot_my_connection1 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00cc99"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00cc99"), lwd=.3)
}
plot_my_connection2 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00b386"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00b386"), lwd=.3)
}
plot_my_connection3 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#009973"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#009973"), lwd=.3)
}
plot_my_connection4 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#00664c"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#00664c"), lwd=.3)
}
plot_my_connection5 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#004c39"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#004c39"), lwd=.3)
}
plot_my_connection6 <- function(dep_lon,dep_lat,arr_lon,arr_lat){
  library(geosphere)
  inter <- gcIntermediate(c(dep_lon,dep_lat), c(arr_lon,arr_lat),n=500, addStartEnd=T, breakAtDateLine=F)
  inter <- data.frame(inter)
  lines(subset(inter,lon>=0),col=c("#003d2e"), lwd=.3)
  lines(subset(inter,lon<0),col=c("#003d2e"), lwd=.3)
}

par(mar=c(0,0,0,0))
data1 <- (outlrd)
colnames(data1) <- c("longitude","latitude")
data2 <- (cldam)
colnames(data2) <- c("longitude","latitude")
data3 <- (cldas)
colnames(data3) <- c("longitude","latitude")
data4 <- (cldeu)
colnames(data4) <- c("longitude","latitude")
maps::map('world',
      col="#b3b3b3", fill=TRUE, bg="#F1F1F0", lwd=0.05,
      mar=rep(0,4),border=0, ylim=c(-80,80) 
      )
points(x=outlrd$longitude, y=outlrd$latitude, col=c("black"), cex=(.2), pch=16)
points(x=cldam$longitude, y=cldam$latitude, col=c("#043b8c"), cex=(.7), pch=16)
points(x=cldeu$longitude, y=cldeu$latitude, col=c("#0282e3"), cex=(.7), pch=16)
points(x=cldas$longitude, y=cldas$latitude, col=c("#16b507"), cex=(.7), pch=16)

inter <- gcIntermediate(c(10.451526,51.165691), c(4.469936,50.503887), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-3.435973,55.378051), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(-120.7401385,47.7510741), c(-79.3832,43.6532), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(-74.0059728,40.7127753), c(-111.093731,34.0489281), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(114.305539,30.592849), c(119.7889248,29.1416432), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(4.469936,50.503887), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#003d2e"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(8.227512,46.818188), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(144.9631,-37.8136), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-79.3832,43.6532), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-96.8410503,32.8143702), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(120.960515,23.69781), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-99.9018131,41.4925374), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-14.452362,14.497401), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

plot_my_connection(-120.7401385,47.7510741,144.9631,-37.8136)
plot_my_connection(144.9631,-37.8136,-120.7401385,47.7510741)

inter <- gcIntermediate(c(-120.7401385,47.7510741), c(-89.3985283,40.6331249), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(-120.7401385,47.7510741), c(-79.0192997,35.7595731), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(-120.7401385,47.7510741), c(-95.1449017,36.6309594), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00b386"), lwd=.3)

plot_my_connection(-74.0059728,40.7127753,120.960515,23.69781)
plot_my_connection(120.960515,23.69781,-74.0059728,40.7127753)

inter <- gcIntermediate(c(-74.0059728,40.7127753), c(-8.224454,39.399872), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

plot_my_connection1(-74.0059728,40.7127753,138.252924,36.204824)
plot_my_connection1(138.252924,36.204824,-74.0059728,40.7127753)

plot_my_connection(-74.0059728,40.7127753,144.9631,-37.8136)
plot_my_connection(144.9631,-37.8136,-74.0059728,40.7127753)

inter <- gcIntermediate(c(-74.0059728,40.7127753), c(45.079162,23.885942), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

plot_my_connection(-73.087749,41.6032207,144.9631,-37.8136)
plot_my_connection(144.9631,-37.8136,-73.087749,41.6032207)

plot_my_connection(-73.087749,41.6032207,120.960515,23.69781)
plot_my_connection(120.960515,23.69781,-73.087749,41.6032207)

inter <- gcIntermediate(c(5.291266,52.132633), c(-43.1729,-22.9068), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(5.291266,52.132633), c(144.9631,-37.8136), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-119.4179324,36.778261), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-111.0937311,34.0489281), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(120.960515,23.69781), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-3.74922,40.463667), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-79.3832,43.6532), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(-43.1729,-22.9068), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(10.451526,51.165691), c(144.9631,-37.8136), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#004c39"), lwd=.3)

plot_my_connection4(114.305539,30.392849,-95.7422569,36.2244054)
plot_my_connection4(-95.7422569,36.2244054,114.305539,30.392849)

plot_my_connection6(114.305539,30.392849,-88.7878678,43.7844397)
plot_my_connection6(-88.7878678,43.7844397,114.305539,30.392849)

plot_my_connection(114.305539,30.392849,-119.4179324,36.778261)
plot_my_connection(-119.4179324,36.778261,114.305539,30.392849)

inter <- gcIntermediate(c(114.305539,30.392849), c(-3.435973,55.378051), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#003d2e"), lwd=.3)

inter <- gcIntermediate(c(114.305539,30.392849), c(-7.6920536,53.1423672), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(114.305539,30.392849), c(-21.9426,64.1466), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

plot_my_connection(114.305539,30.392849,-79.3832,43.6532)
plot_my_connection(-79.3832,43.6532,114.305539,30.392849)

inter <- gcIntermediate(c(2.213749,46.227638), c(-88.7878678,43.7844397), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(-3.435973,55.378051), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(18.4241,-33.9249), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(2.213749,46.227638), c(144.9631,-37.8136), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(4.469936,50.303887), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00cc99"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(-14.452362,14.497401), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(-74.0059728,40.7127753), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(37.6173,55.7558), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(-21.9426,64.1466), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00b386"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(9.501785,56.26392), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

inter <- gcIntermediate(c(-3.435973,55.378051), c(18.4241,-33.9249), n=100, addStartEnd=TRUE, breakAtDateLine=F)
lines(inter, col=c("#00e6ac"), lwd=.3)

legend(x="left", legend=c("1-2", "3-4", "5-6", "7-8", "9-10", "<39"),fil=c("#00e6ac","#00cc99","#00b386","#009973","#00664c","#004c39","#003d2e"), title="Gene Flow Density")