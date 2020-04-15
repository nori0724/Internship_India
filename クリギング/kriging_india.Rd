install.packages("openxlsx")
library(sp)
library(gstat)
library(openxlsx)
suppressPackageStartupMessages({
	library(dplyr)
	library(ggplot2)
	library(scales)
	library(magrittr)
})


data<-read.xlsx("/Users/masanoritakahashi/Documents/aqi/Kriging/PM25Data.xlsx")
colnames(data)=data[1,]
data=data[2:201,]

#緯度経度の型を文字列からdoubleに変換
class(data$Latitude)
data$Latitude = as.double(data$Latitude)
data$Longitude = as.double(data$Longitude)
data$PM25 = as.double(data$PM25)
coordinates(data) = ~Latitude+Longitude

bubble(data, "PM25", col=c("#00ff0088", "#00ff0088"), main="PM25 concentrations(ppm)")

##バリオグラム
pm25.var <- variogram(log(PM25)*10~ Latitude + Longitude, data=data)
plot(pm25.var)

##バリオグラム雲
plot(variogram(log(PM25)~ Latitude + Longitude, data=data, cloud=TRUE))

##球形モデル
pm25.model = fit.variogram(pm25.var, model=vgm(1, "Sph", 6, 1))
plot(pm25.var, pm25.model)


##シェープファイル 読み込み
shp<-read_sf("/Users/masanoritakahashi/Documents/aqi/Kriging/India_SHP/INDIA.shp")
class(shp)
names(shp)
plot(shp)


##クリギング
pm25.kriged = krige(log(PM25)*10~ Latitude + Longitude, data, shp, model=pm25.model)

