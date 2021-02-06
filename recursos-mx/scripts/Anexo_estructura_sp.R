## ----Anex_sp_1,echo=TRUE,results="verbatim",cache=TRUE,crop=TRUE,fig.width=3,fig.height=3----
library(sp)
# SpatialPoints
# Crea un vector de coordenadas en x
Xs <- c(2,4,5)
# Crea un vector de coordenadas en y
Ys <- c(5,4,8)
# Pega Xs y Ys para crear una tabla de coordenadas
coords <- cbind(Xs,Ys)
print(coords)

# Crea el objeto SpatialPoints (SP)
SP = SpatialPoints(coords)

plot(SP, axes = TRUE)
class(SP)

## ----Anex_sp_2,echo=TRUE,results="verbatim",cache=TRUE-------------------
summary(SP)
print(SP)
proj4string(SP)
SP@proj4string
bbox(SP)
SP@bbox
coordinates(SP)
SP@coords

## ----Anex_sp_3,echo=TRUE,results="verbatim",crop=TRUE, fig.width=3, fig.height=3,cache=TRUE----
# SpatialPoints data frame SPDF ###########################################
# Tabla con ID (campo num) e información adicional (tabla de atributos)
num <- c(1, 2, 3)
nombre <- c("Pozo","Gasolinera","Pozo")
tabpuntos <- data.frame(cbind(num,nombre))
class(tabpuntos)

# crea el SpatialPointsDataFrame con el SpatialPoints y la tabla
SPDF <- SpatialPointsDataFrame(SP, tabpuntos, match.ID="num")
# crea el SpatialPointsDataFrame con las coord y la tabla
SPDF2 <- SpatialPointsDataFrame(coords, tabpuntos)

plot(SPDF,axes=TRUE)

## ----Anex_sp_4,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
# Se puede extraer la tabla de atributos de un SPDF con
as.data.frame(SPDF)
SPDF@data

# Selección de elementos dentro de la cobertura 
Pozos <- SPDF[SPDF@data$nombre=="Pozo",]
plot(Pozos,axes=TRUE)

## ----Anex_sp_5,echo=TRUE,results="verbatim",fig.width=3, fig.height=3,cache=TRUE----
# Crea 3 objetos "Line": simple cadena de coordenadas (vértices)
# Linea 1
X1s <- c(0,3,5,8,10)
Y1s <- c(0,3,4,8,10)
Coord1 <- cbind(X1s,Y1s)
# Crea objeto de Clase Line
L1 <- Line(Coord1)

# Linea 2
X2s <- c(2,1,1)
Y2s <- c(2,4,5)
Coord2 <- cbind(X2s,Y2s)
# Crea objeto de Clase Line
L2 <- Line(Coord2)

# Linea 3
X3s <- c(8,8)
Y3s <- c(8,5)
Coord3 <- cbind(X3s,Y3s)
# Crea objeto de Clase Line
L3 <- Line(Coord3)

## ----Anex_sp_6,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
# Crea dos objetos Lines: conjunto de objetos Line con un mismo ID
Lines1 = Lines(list(L1,L2),ID="p")
Lines2 = Lines(L3,ID="t")

# Crea un objeto SpatialLines: conjunto de objetos Lines
SL <- SpatialLines(list(Lines1, Lines2))
plot(SL,axes=TRUE)

## ----Anex_sp_7,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
# Tabla con ID (campo num) e informacion adicional (tabla de atributo)
code <- c("t","p")
tipo <- c("Terraceria","Pavimentada")
tablineas <- data.frame(cbind(tipo,code))
SLDF = SpatialLinesDataFrame(SL,tablineas,match.ID="code")
plot(SLDF,axes=TRUE) 

## ----Anex_sp_8,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
# Se puede extraer la tabla de atributos de un SPDF con
as.data.frame(SLDF)
SLDF@data

# Se puede selecionar ciertos rasgos usando la tabla de atributos
plot(SLDF[SLDF@data$tipo=="Pavimentada",],axes=TRUE)                 
plot(SLDF[SLDF@data$tipo=="Terraceria",],add=TRUE,col="red")

## ----Anex_sp_9,echo=TRUE,results="verbatim",fig.width=3, fig.height=3,cache=TRUE----
# Organización de los datos
SLDF@lines

## ----Anex_sp_10,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
## Polígono forestal al SudEste
## Polygon
# Crea una cadena de coordenadas en X
X1 <- c(5,6,10,10,5)
# Crea una cadena de coordenadas en Y
# Ojo tiene que cerrar (último par de coord = primero)
Y1 <-  c(0,5,5,0,0)
# Pega X y Y para crear una tabla de coordenadas
c1 <- cbind(X1,Y1)
print(c1)
class(c1)
# Crea el objeto Polygon. Un polygon es un forma simple cerrada
P1 = Polygon(c1)

# Polígono forestal al NorOeste
# Crea una cadena de coordenadas en X
X2 <- c(0,0,6,2,0)
# Crea una cadena de coordenadas en Y
Y2 <- c(4,10,10,4,4)
# Pega X y Y para crear una tabla de coordenadas
c2 <- cbind(X2,Y2)
P2 = Polygon(c2)

# Polígono hueco
# Crea una cadena de coordenadas en X
X3 <- c(1,1,2,2,1)
# Crea una cadena de coordenadas en Y
Y3 <- c(5,6,6,5,5)
# Pega X y Y para crear una tabla de coordenadas
c3 <- cbind(X3,Y3)
P3 = Polygon(c3, hole=TRUE)

# Polígono de agricultura
P4 = Polygon(c3) # esta vez no es hueco

# Polígono de área urbana
X5 <- c(0,0,2,6,10,10,6,5,0)
Y5 <-  c(0,4,4,10,10, 5,5,0,0)
c5 <- cbind(X5,Y5)
P5 = Polygon(c5)

# Un Polygons es un conjunto de Polygon, incluyendo eventualmente huecos, con un ID

# Polígonos forestales: los dos polígonos con un hueco
PoliF = Polygons(list(P1,P2,P3),ID="F")

# Polígono zona urbana
PoliU = Polygons(list(P4),ID="U")
# Polígono agricultura
PoliA = Polygons(list(P5),ID="A")

# Spatial Polygons: conjunto de polygons
SPol = SpatialPolygons(list(PoliF,PoliA,PoliU))

plot(SPol,axes=TRUE,xlab="x",ylab="y")

## ----Anex_sp_11,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
# Spatial PolygonsDataFrame

# Tabla con ID (campo num) e información adicional (tabla de atributo)
code <- c("A","F","U")
tipo <- c("Agricultura","Bosque","Urbano")
tabpol <- data.frame(cbind(code,tipo))

SPolDF = SpatialPolygonsDataFrame(SPol,tabpol,match.ID="code")

summary(SPolDF)
SPolDF@polygons
SPolDF@polygons[[1]]@Polygons[[1]]@hole
SPolDF@polygons[[1]]@Polygons[[1]]@coords

SPolDF@polygons[[1]]@Polygons[[1]]
slot(SPol,"polygons")  # lista de objetos Polygons

## ----Cap3_12,echo=TRUE,results="verbatim",fig.width=3, fig.height=3,crop=TRUE,cache=TRUE----
## SpatialPixels
## Malla de 3 x 4 celdas de dimensión 1x1
## Coordenadas del centro de las celdas (no hay (1.5,1.5) que es NA)
xc = c(0, 1, 2, 3, 0, 2, 3, 0, 1, 2, 3) + 0.5
yc = c(0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2) + 0.5
df <- data.frame(xc,yc)
print(df)
plot(xc,yc, axes = T)

coordinates(df) <- ~xc+yc
class(df)  # es un SpatialPoints!
gridded(df) = TRUE  # lo pasamos a raster SpatialPixels
class(df)  # ya es SpatialPixels
plot(df)

## ----Cap3_13,echo=TRUE,results="verbatim",fig.width=3, fig.height=3,cache=TRUE----
# Grid (topología del grid: offset, tamaño de celdas, num filas/columnas)
df@grid
# Grid index: indexación de los puntos
df@grid.index
# Coordenadas de los puntos (centro de las celdas)
df@coords
# Ventana
df@bbox
# Un sistema de proyección (inexistente en este caso)
df@proj4string

## ----Cap3_14,echo=TRUE,results="verbatim",fig.width=3, fig.height=2,crop=TRUE,cache=TRUE----
## SpatialPixelsDataFrame
# Data frame tabla de atributos (sin el dato NA)
tab_g <- data.frame(c(1,2,3,4,2,2,2,3,3,3,1))

# SpatialPixelsDataFrame
SPixDF <- SpatialPixelsDataFrame(df,tab_g)
class(SPixDF)  # es un "SpatialPixelsDataFrame"
plot(SPixDF)

## Hay algunos slots suplementarios en comparación con el SpatialPixel
# Valores de los pixels
SPixDF@data
SPixDF@coords.nrs # Núm de la columna de la tabla de atributos 
# que contiene las coordenadas (aqui no aplica)

## ----Cap3_15,echo=TRUE,results="verbatim",fig.width=3, fig.height=3,crop=TRUE,cache=TRUE----
G = GridTopology(c(0.5,0.5), c(1,1), c(4,3))
class(G)

# Estructura de la malla con 3 slots
G@cellcentre.offset
G@cellsize
G@cells.dim
summary(G)
coordinates(G)
coordinatevalues(G)

# SpatialGrid 
# Casi lo mismo: tiene slots adicionales (proj, bbox)
SG = SpatialGrid(G)
class(SG)
summary(SG)

## ----Cap3_16,echo=TRUE,results="verbatim",fig.width=3, fig.height=1.5,crop=TRUE,cache=TRUE----
# slots adicionales
SG@grid
SG@bbox
SG@proj4string
plot(SG, axes=TRUE)

## ----Cap3_17,echo=TRUE,results="verbatim",fig.width=3, fig.height=2,crop=TRUE,cache=TRUE----
## SpatialGridDataFrame
# Un dataframe con los valores de las 12 celdas
tab_g <- data.frame(c(1,2,3,4,2,NA,2,2,3,3,3,1))

SGDF = SpatialGridDataFrame(SG, tab_g)
class(SGDF)
plot(SGDF,axes=T)
SGDF@data

