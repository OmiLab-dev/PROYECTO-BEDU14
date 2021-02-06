## ----script8,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
library(raster)
library (rgdal)
library(maptools)
library(spdep)

#  Ruta del espacio de trabajo
setwd("/home/jf/libroRGIS/recursos-mx")

# def indica el número de pixels deforestados de 100 x 100 m en cuadros de 1 x 1 km
def <- raster("defor.tif")
plot(def)
dim(def)
res(def)

# Transforma el raster en puntos
def_pts <- rasterToPoints(def)
# plot(def_pts)
head(def_pts)
summary(def_pts)
class(def_pts)

# Distancia de búsqueda de los vecinos "locales"
dist_G <- 5000

# Genera matriz con 2 columnas para coordenadas (x e y)
xy <- as.matrix(def_pts[,1:2])
head(xy)
tasa <- def_pts[,3]

# Identifica vecinos de cada punto en distancias de 0 a dist_G
vecino <-dnearneigh(xy, 0, dist_G)
print(vecino)

# Genera un vector de longitud = número de puntos
length(vecino)
x <- 1:length(vecino)

## ----script8a,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
library(spdep)
pesos <- nb2listw(vecino, style="B")
Getis<- localG(tasa, pesos)
class(Getis)
head(Getis)
z <- as.numeric(Getis)

## ----script8b,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
library(raster)
# Genera una tabla con x y z
spz <- as.data.frame(cbind(xy,z))
head(spz)

# Crea un objeto "spatial points data frame"
coordinates(spz) <- ~ x + y
# Convierte a SpatialPixelsDataFrame
gridded(spz) <- TRUE
# Convierte a raster
rasterz <- raster(spz)
plot(rasterz)

