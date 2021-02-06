## ----Cap5_1,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE,autodep=TRUE----
# Determina la ruta del espacio de trabajo
setwd("/home/jf/libroRGIS/recursos-mx")
library(sf)
# Importación de los mapitas con st_read (paquete sf)
# Mapa puntos
SFP <- st_read("SFP.shp")
# Mapa líneas
SFL <- st_read("SFL.shp")
# Mapa polígonos
SFPol <- st_read("SFPol.shp")

# Test de la validez de polígonos
st_is_valid(SFPol)
# Test si líneas son simples
st_is_simple(SFL)
# Calcula área de polígonos
st_area(SFPol)
# Calcula longitud líneas  %%%%% no funcion para multiline
st_length(SFL)

# Mapita de los datos
plot(SFPol["ID"],col=c("Dark Green","green","grey","white"))
plot(st_geometry(SFP),add=TRUE)
plot(st_geometry(SFP) + c(0.5,0),add=TRUE,pch=c(49,50,51),cex=1)
plot(st_geometry(SFL),add=TRUE,lty=2,lwd = 2,col="red")
# agrega el número de las líneas
text(5,5.5,"1",pos=4,col="red",cex=1)
text(1.2,3,"2",pos=4,col="red",cex=1)
text(7.8,6,"3",pos=4,col="red",cex=1)

## ----Cap5_2,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE,autodep=TRUE----
## Operadores lógicos binarios
# Intersección de puntos y polígonos
st_intersects(SFP, SFPol, sparse = FALSE)
st_intersects(SFP, SFPol, sparse = TRUE)

# Intersección de líneas y polígonos
st_intersects(SFL, SFPol, sparse = FALSE)
st_intersects(SFL, SFPol, sparse = TRUE)

# Distancia más corta entre elementos de dos objetos
st_distance(SFP, SFPol)

## ----Cap5_3,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=2,cache=TRUE----
# Operadores geométricos (intersección geométrica)
SFPxSFPol <- st_intersection(SFP,SFPol)
print(SFPxSFPol)  # punto 1 es duplicado por pertenecer a 2 polígonos

SFLxSFPol <- st_intersection(SFL,SFPol)
print(SFLxSFPol)  # hay puntos y  líneas
plot(SFLxSFPol["tipo.1"],lwd=3)
# extraemos solo las líneas
SFLxSFPol_l <- st_collection_extract(SFLxSFPol,type="LINESTRING")
longitud <- st_length(SFLxSFPol_l) # Cálculo longitud
SFLxSFPol_l$long <- longitud # Resultados en nueva columna de la tabla
# Suma la longitud de los segmentos de cada tipo de cubierta
Suma_l <- aggregate(long ~ tipo.1, FUN = sum, data = SFLxSFPol_l)
print(Suma_l)

## ----Cap5_3pipe,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=2,cache=TRUE----
# Con pipe
longitud <- 
  st_intersection(SFL,SFPol) %>% st_collection_extract(type="LINESTRING") %>% st_length()
print(longitud)

## ----script4,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=3,crop=TRUE----
# Carga los paquetes
library(sf)
# library(raster)

# Determina la ruta del espacio de trabajo
setwd("/home/jf/libroRGIS/recursos-mx")

####################################################
# Importación de los mapas con st_read (paquete sf)
# Mapa de los estados de México
mx <- st_read("Entidades_latlong.shp")
st_crs(mx)
summary(mx)
# Mapa de carreteras
carr <- st_read("carretera.shp")
st_crs(carr)
# Atributos del mapa de carretera
names(carr)
summary(carr)
# Reproyecta mx a LCC
mx_lcc <- st_transform(mx, st_crs(carr))
st_crs(mx_lcc)

# Calcula el área de los Estados
mx_lcc$AreaEdo <- st_area(mx_lcc) / 1000000  # km2
# Plotea los estados y carreteras juntos
plot(st_geometry(carr),col="blue",axes=TRUE)
plot(st_geometry(mx_lcc),border="red",add=TRUE)

## ----script4_1,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Qué longitud de carreteras federales en c/ estado del sureste?
# Selección carr federales
carrFed <- carr[ADMINISTRA="Federal",]
# Selección estados del sureste (Tabasco, Campeche, Quintana Roo y Yucatán)
sureste <- 
  mx_lcc[mx_lcc$NOM_ENT %in% c("Tabasco", "Campeche", "Quintana Roo", "Yucatan"),]
class(sureste)
plot(st_geometry(sureste))

# Intersección entre mapas de carr federales y Edos sureste
carrFedXedos <- st_intersection(carrFed,sureste)
names(carrFedXedos)
summary(carrFedXedos)
# Convierte los objetos "Multilines" en "Lines" (para cálculo longitud)
carrFedXedos_l <- st_collection_extract(carrFedXedos,type="LINESTRING")
long <- st_length(carrFedXedos_l) / 1000  # km
head(long)
# Agrega columna long a la tabla de atributos
carrFedXedos_l$long <- long
# Suma la longitud de los segmentos de cada tipo de cubierta
Suma_long <- aggregate(long ~ NOM_ENT, FUN = sum, data = carrFedXedos_l)
print(Suma_long)

## ----script4_1a,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE----
# Que proporción del territorio estatal está a menos de 20 km de una
# carretera federal?
# Creación de un buffer de 20 km alrededor carreteras fed
buf <- st_buffer(carrFed,dist=20000)
plot(st_geometry(buf),axes=TRUE)
# Intersección entre buffer de carr federales y Edos sureste
carrbufXedos <- st_intersection(buf,sureste)
area <- st_area(carrbufXedos) / 1000000  # km2
head(area)
carrbufXedos$area <- area
# Suma la longitud de los segmentos de cada tipo de cubierta
Suma_area <- aggregate(area ~ NOM_ENT, FUN = sum, data = carrbufXedos)
print(Suma_area)
# junta a sureste la tabla Suma_area (por clave en común)
sureste <- merge(sureste,Suma_area)
# calcula la proporción del área del buffer / área del estado
sureste$prop <- sureste$area / sureste$AreaEdo

## ----script4_2,echo=TRUE,results="verbatim",cache=TRUE,eval=TRUE,fig.width=4, fig.height=4,crop=TRUE,depend=TRUE----
# Población Censo de Población y Vivienda 2010
tab_pop <- read.csv("Pop2010_INEGI.csv")
head(tab_pop)
head(mx_lcc)

# Junta las dos tablas
# Con la clave numérica
mx_lcc <- merge(mx_lcc,tab_pop,by.x="CveEdo",by.y="NumEdo")

print(mx_lcc)
names(mx_lcc)

# Densidad de población (núm hbs / km2)
mx_lcc$dens <- mx_lcc$Poptotal/mx_lcc$AreaEdo

# El índice de masculinidad, también llamado razón de sexo es un índice demográfico 
# que expresa la razón de hombres por mujeres en un determinado territorio, expresado 
# por lo tanto en %. Se calcula usando la fórmula: 100 * H/M
mx_lcc$IM <- 100 * mx_lcc$Hombre/mx_lcc$Mujer

# salva el objeto en shape
st_write(mx_lcc,"mx_lcc.shp",delete_layer = TRUE)

