## ----script7_1,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=4,fig.show=FALSE----
library(maptools)
library(RColorBrewer)
library(classInt)
library(sf)
# Determina la ruta del espacio de trabajo
setwd("/home/jf/libroRGIS/recursos-mx")
mx <- st_read("mx_lcc.shp")
# nombres de las columnas de la tabla de atributos
names(mx)

## ----script7_2,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=4,fig.show=FALSE----
# valores de densidad de los estados
print(mx$dens)
## Paleta de colores y categorización de la variable densidad 
numclass <- 7 # número de categorías
# Generación de 7 colores en la escala amarillo a rojo
colores <- brewer.pal(numclass, "YlOrRd")
print(colores) # códigos de los colores
# determinación de los umbrales entre categorías (método cuantil)
var <- mx$dens
brks<-classIntervals(var, n=numclass, style="quantile")
brks <- brks$brks
print(brks)
class(brks)
class(mx$dens)
# Determina qué color corresponde a cada valor de densidad
codigos_num <- findInterval(var, brks,all.inside=TRUE)
print(codigos_num)
codigos_color <- colores[codigos_num]
print(codigos_color)

## ----script7_3,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=4,fig.show=FALSE----
png(file="/home/jf/Dropbox/libroRGIS/latex/figuras/mexico_densidad.png", height=16, 
    width=20, units="cm", res=400) 
par(mar=c(10.1,4.1,4.1,10.1))
plot(mx["dens"], col=codigos_color, axes=T,main="")
## pone un título
title(main="Densidad poblacional",cex.main=1.3)
# pone texto en ciertas coordenadas
text(3500000,1500000,"Golfo de México",pos = 1,cex = 1.2)
# pon el símbolo de Norte
SpatialPolygonsRescale(layout.north.arrow(1), offset= c(3500000,2000000), 
                       scale = 300000,plot.grid=F)
# leyenda
# genera texto de la leyenda (rangos de valores)
rangos <- leglabs(as.vector(round(brks, digit = 0)),under="Menos de", over="Más de")
#print(rangos)
class(rangos)
legend("bottomleft", inset=.05, title=expression("Densidad (hb/km"^2*")") ,
       legend=rangos, fill=colores, horiz=FALSE, 
       box.col = NA, cex = 1.2)
# Escala gráfica
SpatialPolygonsRescale(layout.scale.bar(), offset= c(2800000,180000), 
      scale= 1000000, fill=c("transparent", "black"), plot.grid= F)
text(2800000,120000,"0"); text(3850000,120000,"1000 km") # texto da escada
par(mar=c(5.1,4.1,4.1,2.1))
dev.off()

## ----script7_4,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=4,fig.show=FALSE----
# importa y recorta el DEM
extension <- extent(2000000,3000000,500000,1500000)
dem <- crop(raster("DEM_Mx.tif"), extension)
# Crea una escala de color
colores <- terrain.colors(7, alpha = 1)
# Elabora el mapa
png(file="dem-mx.png", height=20, width=20, units="cm", res=400) 
plot(dem, col=colores,breaks = c(0, 500, 1000, 1500, 2000, 2500, 3000, 5300), 
     main = "Elevación")
SpatialPolygonsRescale(layout.scale.bar(), offset= c(2100000,600000), scale= 300000, 
                       fill=c("transparent", "black"), plot.grid= F)
text(2100000,580000,"0"); text(2430000,580000,"300 km")
dev.off()

## ----script7_5,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=4,fig.show=FALSE----
# Preparación de un sombreado
pend <- terrain(dem, opt = "slope")
orient <- terrain(dem, opt = "aspect")
sombra <- hillShade(pend, orient, 40, 270)

# Plotea el sombreado y la elevación con transparencia
png(file="sombreado-mx.png", height=20, width=20, units="cm", res=400) 
plot(sombra, col = grey(0:100/100), legend = FALSE, main = "Sombreado")
plot(dem, col = rainbow(25, alpha = 0.3), add = TRUE)
SpatialPolygonsRescale(layout.scale.bar(), offset= c(2100000,600000), scale= 300000, 
                       fill=c("transparent", "black"), plot.grid= F)
text(2100000,580000,"0"); text(2430000,580000,"300 km")
dev.off()

