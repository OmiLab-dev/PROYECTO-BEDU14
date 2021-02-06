## ----import_sf,echo=TRUE,results='verbatim',cache=FALSE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE,warning=TRUE----
# Carga el paquete sf
library(sf)
# Determina la ruta del espacio de trabajo  CAMBIAR A SU CARPETA!!
# En windows sería algo tipo setwd("C:/Users/jf/Dropbox/libro_SIG/datos-mx")
setwd("/home/jf/libroRGIS/recursos-mx")
mx <- st_read("Entidades_latlong.shp")

# Pregunta la clase del objeto espacial 
class(mx) # Es un simple feature "sf"
summary(mx) # un dataframe con una columna "lista" sobre la geometría
# plotea el mapa (um mapa para cada atributo)
plot(mx, axes = T)

# Para plotear únicamente la geometría
plot(st_geometry(mx))

# Pregunta por el sistema de proyección
st_geometry(mx)  # equivalente a print(mx$geometry)

st_crs(mx) # por código EPSG y proj4string

## ----import_sf2,echo=TRUE,results='verbatim',cache=FALSE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE,warning=TRUE----
carr <- st_read("carretera.shp")
st_crs(carr) # No hay información sobre el sistema de coordenadas
# se define:
st_crs(carr) <- "+proj=lcc +lat_1=17.5 +lat_2=29.5 +lat_0=12 +lon_0=-102 +x_0=2500000 
                 +y_0=0 +ellps=GRS80 +units=m +no_defs"

# Test de la validez de los mapas
st_is_valid(mx)
# st_is_valid(carr)

## ----import_sf3,echo=TRUE,results='verbatim',cache=FALSE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE,warning=TRUE----
drivers_soportados <- st_drivers()
names(drivers_soportados)
# Lista de los 10 primeros drivers de la lista (hay más!)
head(drivers_soportados[,-2], n = 10) 

## ----operac_vetor_sf,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE,warning=FALSE----
# Salva el objeto en formato shape
st_write(mx,"mexico.shp",delete_layer = TRUE)
st_write(mx, dsn = "mx.gpkg", delete_layer = TRUE)

## ----import_sf4,echo=TRUE,results='verbatim',cache=FALSE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE,warning=TRUE----
library(sp)
mx_sp = as(mx, Class = "Spatial")
# Regreso a sf con st_as_sf():
mx_sf = st_as_sf(mx_sp, "sf")

## ----import_raster,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE----
library(raster)

# Importa imagen
dem <- raster("DEM_GTOPO1KM.tif")
class(dem)
plot(dem)
extent(dem)

# Formatos disponibles para salvar
writeFormats()
# Salva el raster en formato LAN
writeRaster(dem, filename="DEM_Mx.lan", format="LAN", overwrite=TRUE,
            datatype="INT2S")

