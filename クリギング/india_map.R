#devtools::install_github("tidyverse/ggplot2")
#install.packages("maptools")
#install.packages("rgdal")
#install.packages("sf")
#install.packages("dplyr")
library(maptools)
library(sf)
library(ggplot2)
library(dplyr)

map <- read_sf("/Users/masanoritakahashi/Documents/aqi/Kriging/India_SHP/INDIA.shp")
map

ggplot(map)+geom_sf(fill=NA)+coord_sf(datum=NA)+theme_void()