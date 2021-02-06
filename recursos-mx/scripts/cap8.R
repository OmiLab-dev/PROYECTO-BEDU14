## ----PR,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
#install.packages("RStoolbox") # Instala el paquete si necesario
# Librería RStoolbox y espacio de trabajo
library(RStoolbox)
setwd("/home/jf/libroRGIS/recursos-mx")

# Lee los Metadatos
M <- readMeta("LC08_L1TP_028047_20170411_20170415_01_T1_MTL.txt")
head(M,10)  # Desplega las 10 primeras líneas del Metadata
print(M$PATH_ROW)

# Importa la imagen (por default las 10 bandas com 30 m res)
Metadata_file <- "LC08_L1TP_028047_20170411_20170415_01_T1_MTL.txt"
imagen <- stackMeta(Metadata_file,quantity = "dn")              # Las bandas de 30m
pan <- stackMeta(Metadata_file,quantity = "dn",category="pan")  # La pancromática
qa <- stackMeta(Metadata_file,category="qa")                    # La de calidad

print(imagen)
class(imagen)  # Es un RasterStack
class(pan)  # Es un RasterLayer

## ----PR2echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Composición a color RGB
ggRGB(imagen,r=5,g=3,b=2,stretch = "lin")

# Corrección atmosférica - apref:	 Apparent reflectance (top-of-atmosphere reflectance)
imagen_c <- radCor(imagen, metaData = Metadata_file, method = "apref")
# ggRGB(imagen_c,r=5,g=3,b=2,stretch = "lin")

# Fusión bandas multiespectrales y banda pancromática
fusion <- panSharpen(imagen,pan,r=5,g=3,b=2,method="brovey")

# Zoom sobre pequeña ventana
ventana <- extent(842800,845300,2153400,2155000)
ggRGB(imagen,r=5,g=3,b=2,stretch="lin",ext=ventana) # Multiespectral 30 m
ggRGB(fusion,r=3,g=2,b=1,stretch="lin",ext=ventana) # Fusión 15 m


# Indices espectrales
Indices <- spectralIndices(imagen_c, red = "B3_tre", nir = "B4_tre",
                           indices = c("SAVI","NDVI"))
plot(Indices[[2]])  # plot NDVI (2a banda)

## ----PR3,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Clasificación no supervisada (método K-means)
clas_nosup <- unsuperClass(imagen, nSamples = 200, nClasses = 6, nStarts = 5)
class(clas_nosup)
ggR(clas_nosup$map,geom_raster = TRUE,forceCat = TRUE)

# Clasificación supervisada
library(rgdal)
campos <- readOGR(".","campos_utmz13")  # importación shape campos de entrenamiento
clas_sup <- superClass(imagen,trainData = campos, responseCol = "clase", model="mlc")
ggR(clas_sup$map,geom_raster = TRUE,forceCat = TRUE)

## ----PR4,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# convierte raster en data.frame
library(ggplot2)
tabla <- fortify(imagen)
head(tabla)

