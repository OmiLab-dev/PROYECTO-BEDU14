## ----import_maptools,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE,warning=FALSE----
  # Carga los paquetes
  library(maptools)

# Determina la ruta del espacio de trabajo  CAMBIAR A SU CARPETA!!
# En windows seria algo tipo setwd("C:/Users/jf/Dropbox/libro_SIG/datos-mx")

setwd("/home/jf/libroRGIS/recursos-mx")

# Con maptools
mx <- readShapePoly("Entidades_latlong.shp")

# Pregunta la clase del objeto espacial 
class(mx) # Es un "SpatialPolygonsDataFrame"

# plotea el mapa
plot(mx, axes=T)

# Pregunta por el sistema de proyección
proj4string(mx) # No tiene el sistema de proyección definido

# Define el sistema de proyección
proj4string(mx) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 
                    +towgs84=0,0,0"


## ----import_rgdal,echo=TRUE,results="verbatim",cache=FALSE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE----
library(rgdal)
  setwd("/home/jf/libroRGIS/recursos-mx")
# Importa el mismo shape, esta vez con el paquete rgdal
mx <- readOGR(".", "Entidades_latlong")

# Plotea el mapa
# plot(mx, axes=T)

# Determina la clase
class(mx)

# Consulta la proyección
proj4string(mx) # Este vez el objeto tiene el sistema de proyección definido

# Importación del shape de carreteras pavimentadas
carr <- readOGR(".", "carretera")

# Plotea el mapa
plot(carr, axes = T)

# Consulta la proyección
proj4string(carr) 
# Son coordenadas en Cónica Conforme de Lambert (lcc)

## ----operac_vetor,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE,warning=FALSE----
  ## Reproyección
  ## Proyección del mapa de las entidades a la 
  # misma proyección que el mapa de carreteras (Cónica Conforme de Lambert)
  mx_lcc <- spTransform(mx, proj4string(carr))  
proj4string(mx_lcc) # Ahora son coord. en Conica Conforme de Lambert (lcc)

# plotea el mapa (en LCC)
# plot(mx_lcc, axes = T)

# Plotea los estados juntos con las carreteras
plot(mx_lcc,border="red", axes = T)
lines(carr,col = "blue")

# salva el objeto en formato shape
writeSpatialShape(mx_lcc,"Entidades_LCC.shp")

## ----import_raster1,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=3.5,crop=TRUE----
  library(raster)
setwd("/home/jf/libroRGIS/recursos-mx")
# Importa imagen
tmp <- raster("DEM_GTOPO1KM.tif")
plot(tmp)
extent(tmp)

# checa la proyección
proj4string(tmp)

# checa la clase
class(tmp)

# Reproyecta en LCC
                                                                                                                                                                                                            LCC <- "+proj=lcc +lat_1=17.5 +lat_2=29.5 +lat_0=12 +lon_0=-102 +x_0=2500000 +y_0=0 
                                                                                                                                                                                                                                                                            +ellps=GRS80 +units=m +no_defs"
tmp_lcc <- projectRaster(tmp, crs = LCC)
# Plotea el dem con mapa de los estados
mx_lcc <- readOGR(".", "Entidades_LCC")
plot(tmp_lcc); plot(mx_lcc,add=TRUE)
# Checa la extensión (coord extremas) del mapa de México
extent_mx <- extent(mx_lcc)
# Corta a la extensión
dem_mx <- crop(tmp_lcc,extent_mx)

# Lo mismo con comandos anidados
dem_mx <- crop(projectRaster(tmp, crs = LCC),extent(mx_lcc))

plot(dem_mx)

# Salva el raster en formato TIFF
                                                                                                                                                                                                                                                                              writeRaster(dem_mx, filename="DEM_Mx.tif",format="GTiff",overwrite=TRUE,datatype="INT4S")

