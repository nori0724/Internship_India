#http://web.sfc.keio.ac.jp/~maunz/wiki/index.php?ESTRELA_78
library(spdep)
library(gstat)
library(sp)
#測定局データの読み込み
spm.shp<-read_sf("/Users/masanoritakahashi/Documents/aqi/Kriging/data/tma_spm.shp")
spm<-cbind(spm.shp$ID, spm.shp$X, spm.shp$Y, spm.shp$SPM07)
colnames(spm)<-c("ID", "X", "Y", "SPM07")

ward.shp<-read_sf("/Users/masanoritakahashi/Documents/aqi/Kriging/data/Ward.shp")
ward.map<-Map2poly(ward.shp)

#メッシュデータの読み込み
mesh.grid<-read.table("/Users/masanoritakahashi/Documents/aqi/Kriging/data/mesh.csv", header=TRUE, sep=",")
coordinates(mesh.grid)<-c("X", "Y")
mesh.grid<-as(mesh.grid, "SpatialPixelsDataFrame")

#spmをSpatialPixelsDataFrameに変換したいがエラーが出る
#→matrixの型をデータフレームに変更した上でcoordinatesに突っ込む
#coordinates(spm)<-c("X","Y")
spm.df=data.frame(
ID=spm[,1],
X=spm[,2],
Y=spm[,3],
SPM07=spm[,4])
#緯度経度の指定
coordinates(spm.df)<-c("X","Y")

#緯度経度によるトレンドを説明変数とするバリオグラム
spm.var1<-variogram(SPM07*1000~X+Y, data=spm.df)
plot(spm.var1)

#バリオグラム雲の表示
plot(variogram(SPM07*1000~X+Y, data=spm.df, cloud=TRUE))



#https://rdrr.io/cran/gstat/man/fit.variogram.html
#指数モデル
spm.model1 <- fit.variogram(spm.var1, vgm(psill=25, model="Exp", range=28000, nugget=45))
plot(spm.var1, model=spm.model1, cex=1.5, lwd=4)

#球形モデル
spm.model2 <- fit.variogram(spm.var1, vgm(psill=25, model="Sph", range=60000, nugget=45))
plot(spm.var1, model=spm.model2, cex=1.5, lwd=4)

#線形モデル
spm.model3 <- fit.variogram(spm.var1, vgm(psill=25, model="Lin", range=56000, nugget=45))
plot(spm.var1, model=spm.model3, cex=1.5, lwd=4)

#ガウスモデル
spm.model4 <- fit.variogram(spm.var1, vgm(psill=20, model="Gau", range=35000, nugget=50))
plot(spm.var1, model=spm.model4, cex=1.5, lwd=4)

#ナッゲト効果モデル
#エラー
spm.model5 <- fit.variogram(spm.var1, vgm(psill=0, model="Nug", range=0, nugget=70))
plot(spm.var1, model=spm.model5, cex=1.5, lwd=4)

#Maternモデル
spm.model6 <- fit.variogram(spm.var1, vgm(psill=25, model="Mat", range=30000, nugget=45))
plot(spm.var1, model=spm.model6, cex=1.5, lwd=4)


#通常クリギング
spm.go <- gstat(id="ID", formula=SPM07~X+Y, data=spm.df, model=spm.model1)
spm.po <- predict(spm.go, mesh.grid)
spplot(spm.po[1])
spplot(spm.po[2])





