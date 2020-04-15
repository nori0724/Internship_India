#https://rpubs.com/nabilabd/118172
#公式ドキュメント
#https://cran.r-project.org/web/packages/gstat/vignettes/gstat.pdf

#----------3 Spatial data frames----------
library(sp)
library(gstat)

suppressPackageStartupMessages({
	library(dplyr)
	library(ggplot2)
	library(scales)
	library(magrittr)
})

data(meuse)
glimpse(meuse)
class(meuse)
names(meuse)

coordinates(meuse)=~x+y
class(meuse)
summary(meuse)

coordinates(meuse)[1:5]
bubble(meuse, "zinc", col=c("#00ff0088", "#00ff0088"), main="zinc concentrations(ppm)")

#----------4 Spatial data on a regular grid----------
data(meuse.grid)
summary(meuse.grid)
class(meuse.grid)

coordinates(meuse.grid)=~x+y
class(meuse.grid)

gridded(meuse.grid)=TRUE
class(meuse.grid)

image(meuse.grid["dist"])
title("distance to river (red = 0)")
zinc.idw=idw(zinc~1, meuse, meuse.grid)
class(zinc.idw)
spplot(zinc.idw["var1.pred"], main="zinc inverse distance weighted interpolations")

plot(log(zinc)~sqrt(dist), meuse)
abline(lm(log(zinc)~sqrt(dist), meuse))

#----------5 Variogram----------
lzn.vgm=variogram(log(zinc)~1, meuse)
lzn.vgm

lzn.fit=fit.variogram(lzn.vgm, model=vgm(1, "Sph", 900, 1))
lzn.fit

plot(lzn.vgm, lzn.fit)

#----------6 Kriging----------
lzn.kriged = krige(log(zinc)~1, meuse, meuse.grid, model=lzn.fit)
spplot(lzn.kriged["var1.pred"])

