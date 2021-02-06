## ----script6,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=3, fig.height=3,crop=TRUE----
library(raster)
# Determina el espacio de trabajo
setwd("/home/jf/libroRGIS/recursos-mx")
############## Datos muy sencillos
# Creamos unas matrices
m1 <- matrix(c(1,1,2,2,1,1,2,2,1,1,3,3),ncol=4,nrow=3,byrow=TRUE)
m2 <- matrix(c(1,2,3,4,2,NA,2,2,3,3,3,1),ncol=4,nrow=3,byrow=TRUE)
print(m1)
print(m2)
r1 <- raster(m1); r2 <- raster(m2)
extent(r1) <- extent(r2) <- extent(c(0,4,0,3))
### stack
colortable(r1) <- c("red","blue","green")
colortable(r2)<- c("red","blue","green","yellow")
r12 <- stack(r1,r2)
plot(r1,axes=TRUE);plot(r2,axes=TRUE)

# Características del raster
res(r1)
dim(r12)
xmax(r1) # existen también xmax, ymin y ymax
cellStats(r1,"sum")  # suma de todos los pixeles
cellStats(r1,"sd") # desv estándar de todos los pixeles

## ----script6_2,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Algebra de mapa
sum1 <- r1 + 2; print(as.matrix(sum1))
sum2 <- r1 + 2*r2; print(as.matrix(sum2))
sum3 <- overlay(r1, r2, sum1, fun=function(x, y, z){ x + 2*y -z} )
print(as.matrix(sum3))

## ----script6_3,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Operaciones tipo SIG
# Mosaico (merge) y recorte (crop)
# Extent de r1 (xmin, xmin, ymin, ymax)
extent(r1)
m3 <- matrix(c(5,5,5,5,5,5,5,5,5,5,5,5),ncol=4,nrow=3,byrow=TRUE)
print(m3)
r3 <- raster(m3)
# extent(xmin, xmax, ymin, ymax)
extent(r3) <- extent(c(0,4,3,6)) # Está al norte de r1
mosaico <- merge(r1,r3)
extent(mosaico)
print(as.matrix(mosaico))
extent_corte <- extent(c(1,3,2,4))
corte <- crop(mosaico,extent_corte)
print(as.matrix(corte))

## ----script6_4,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Reclasificaciones
print(as.matrix(r2))
r2[r2 > 2] <- 6
print(as.matrix(r2))
# Tabla de reclasificación (rangos)
m <- c(0, 2, 0, 2, 5, 1)
tabla_reclas <- matrix(m, ncol=3, byrow=TRUE)
print(tabla_reclas)
reclas <- reclassify(mosaico, tabla_reclas)
print(as.matrix(reclas))
# Substitución de valores
print(as.matrix(r2))
r2[r2 == 6] <- 9
print(as.matrix(r2))
# con tabla
tab_subs <- data.frame(id=c(1,2,3),v=c(1,56,84))
print(tab_subs)
sub <- subs(r1, tab_subs)
print(as.matrix(r1))
print(as.matrix(sub))

## ----script6_5,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Remuestreos
# Agregación espacial
agreg <- aggregate(mosaico, fact=2, fun="sum")
print(as.matrix(mosaico));print(as.matrix(agreg))
agreg2 <- aggregate(mosaico, fact=2, fun=modal,na.rm = TRUE)
print(as.matrix(agreg2))

## ----script6_6,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Remuestreo
# Imagen de mismo tamaño que mosaico con menos filas
m4 <- matrix(rep(1,20),ncol=4,nrow=5)
r4 <- raster(m4)
extent(r4) <- extent(mosaico)
resv <- resample(mosaico,r4,method="ngb") # vecino más cercano
resb <- resample(mosaico,r4,method="bilinear") # bilinear
print(as.matrix(resv)); print(as.matrix(resb))

## ----script6_7,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Operaciones focales
help(focal)
promedio <- focal(r1, w=matrix(1/9, ncol=3, nrow=3))
promedio <- focal(r1, w=matrix(1,3,3), fun="mean") # otra forma
print(as.matrix(r1))
print(as.matrix(promedio))

## ----script6_7a,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Operaciones zonales
print(as.matrix(r1)); print(as.matrix(r2))
zonal_sum <- zonal(r2,r1,"sum") # map de valores, mapa de zonas
print(zonal_sum)

## ----script6_8,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Importación de un shape con sf
library(sf)
cs2004 <- st_read("cs2004.shp")
plot(cs2004["clase"], axes = T)
head(cs2004)
st_bbox(cs2004)
st_crs(cs2004)

## ----script6_8a,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
## Rasteriza con paquete raster
resol <- 100
# Para rasterizar usando un raster "master"
extension <- extent(c(2460000, 2540000,780000,  820000))
r <- raster(res=resol, ext=extension)
# Rasteriza con el campo GRIDCODE (as() para convertir a sp)
cs2004r <- rasterize(as(cs2004,Class = "Spatial"), r, "GRIDCODE")
plot(cs2004r,axes=T)

## Lo mismo con el mapa de 2014
cs2014 <- st_read("cs2014.shp")
# plot(cs2014["GRIDCODE"], axes = T)
cs2014r <- rasterize(as(cs2014,Class = "Spatial"), r, "GRIDCODE") 
plot(cs2014r,axes=T)

## ----script6_8b,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Obtiene GRIS CODE / clase
aggregate(GRIDCODE~clase,FUN=min,data=cs2004)
# aggregate(GRIDCODE~clase,FUN=min,data=cs2004,package="stat")

## ----script6_8c,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Reclasificación para elaborar un mapa binario forestal / no forestal
# 6-15 y 16-19 son clases forestales
# Matriz tabla para reclasificar
# por default el valor inferior del rango no está incluido
m <- c(0, 5, 0, 5, 15, 1, 15, 19, 1,19,24,0)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
print(rclmat)
F2004 <- reclassify(cs2004r, rclmat)
plot(F2004)

F2014 <- reclassify(cs2014r, rclmat)
plot(F2014)

## Algebra de mapas: Deforestación
def <- overlay(F2004, F2014, fun = function(x,y) {ifelse( x == 1 & y == 0, 1, 0) } )
plot(def)

## Agrega pixels por paquetes de 10 x 10 pixels (suma)
def2 <- aggregate(def, fact=10, fun=sum)
plot(def2)

# Salva el raster
writeRaster(def2, filename="defor.tif", format="GTiff", datatype="INT1U", overwrite=TRUE)

