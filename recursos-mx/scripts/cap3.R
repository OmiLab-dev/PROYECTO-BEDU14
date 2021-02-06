## ----Cap3_codeinstal,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
## sudo apt-get update
## sudo apt-get install libgdal-dev libgeos-dev libproj-dev libudunits2-dev
## sudo apt-get install liblwgeom-dev

## ----Cap3_1,echo=TRUE,results="verbatim",cache=TRUE,crop=TRUE,fig.width=3,fig.height=3,autodep=TRUE----
library(sf)
# Geometrías Simple Features (sfg)
# Point: coordenadas de un punto en 2, 3 o 4 dimensiones
P <- st_point(c(2,5))  # 2 dimensiones (XY)
class(P)
P <- st_point(c(2,5,17,44),"XYZM")  # 4 dimensiones (XYZM)
class(P)
str(P)
plot(P, axes = TRUE)

# Multipoint: coordenadas de varios puntos en 2, 3 o 4 dimensiones
# Crea un vector of coordenadas en x
Xs <- c(2,4,5)
# Crea un vector of coordenadas en y
Ys <- c(5,4,8)
# Pega Xs y Ys para crear una tabla de coordenadas
coords <- cbind(Xs,Ys)
print(coords)

# Crea el objeto Multipoint (MP)
MP <- st_multipoint(coords)
plot(MP, axes = TRUE)
class(MP)
print(MP)

# Multipoint en 3 dimensiones
xyz <- cbind(coords,c(17, 22, 31))
print(xyz)
MP <- st_multipoint(xyz)
print(MP)

## ----Cap3_2,echo=TRUE,results="verbatim",cache=TRUE----------------------
# Colecciones de Simple Features (sfc)
# Crea varios sfg
P1 <- st_point(c(2,5)); P2 <- st_point(c(4,4)); P3 <- st_point(c(5,8))

# Junta varios sfg en un sfc (colección de simple features)
geometria1 = st_sfc(P1,P2,P3) # st_sfc(P1,P2, crs = 4326)

## ----Cap3_3,echo=TRUE,results="verbatim",crop=TRUE, fig.width=3, fig.height=1.5,cache=TRUE----
# Asociando una geometria sfc con una tabla de atributos (data frame)
# Tabla con ID (campo num) e información adicional (tabla de atributos)
num <- c(1,2,3)
nombre <- c("Pozo","Gasolinera","Pozo")
tabpuntos <- data.frame(cbind(num,nombre))
class(tabpuntos)
print(tabpuntos)

# sf object
SFP = st_sf(tabpuntos, geometry = geometria1)
class(SFP) # doble clase: simple feature y dataframe
print(SFP) # ver columna lista "geometry"
plot(SFP,axes=TRUE)

## ----Cap3_3a,echo=TRUE,results="verbatim",crop=TRUE, fig.width=2, fig.height=3,cache=TRUE----
plot(st_geometry(SFP),axes=TRUE)

## ----Cap3_4,echo=TRUE,results="verbatim",crop=TRUE, fig.width=4.5, fig.height=1.5,cache=FALSE----
# Se puede extraer la tabla de atributos de un objeto SFC con
as.data.frame(SFP)

# Selección de elementos dentro de la cobertura 
Pozos <- SFP[nombre=="Pozo",]

## ----Cap3_5,echo=TRUE,results="verbatim",fig.width=3, fig.height=3,cache=TRUE----
# Crea 3 objetos "Linestring": simple cadena de coordenadas (vértices)
# Línea L1
X1s <- c(0,3,5,8,10)
Y1s <- c(0,3,4,8,10)
Coord1 <- cbind(X1s,Y1s)
# Crea objeto de Clase Linestring
L1 <- st_linestring(Coord1)
class(L1)
print(L1)

# Línea L2
X2s <- c(2,1,1)
Y2s <- c(2,4,5)
Coord2 <- cbind(X2s,Y2s)
# Crea objeto de Clase Linestring
L2 <- st_linestring(Coord2)

# Línea 3
X3s <- c(8,8)
Y3s <- c(8,5)
Coord3 <- cbind(X3s,Y3s)
# Crea objeto de Clase Linestring
L3 <- st_linestring(Coord3)

# Crea un objeto Multilineas: conjunto de objetos Linestring
L1L2 = st_multilinestring(list(L1,L2))

# Junta varios sfg en un sfc (colección de simple features)
geometria2 = st_sfc(L1,L2,L3)

## ----Cap3_6,echo=TRUE,results="verbatim",crop=TRUE,fig.width=4.5, fig.height=1.5,cache=TRUE----
# Tabla de atributos
num <- c(1,2,3)
code <- c("t","t","p")
tipo <- c("Terraceria","Terraceria","Pavimentada")
tablineas <- data.frame(cbind(num,tipo,code))
print(tablineas)
# sf object
SFL = st_sf(tablineas, geometry = geometria2)
plot(SFL,axes=TRUE)     
class(SFL) # doble clase: simple feature y dataframe
print(SFL) # ver columna lista "geometry"

## ----Cap3_7,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
# Se puede extraer la tabla de atributos de un SFC con
as.data.frame(SFL)

# Se puede selecionar ciertos rasgos usando la tabla de atributos
print(SFL[tipo=="Pavimentada",])
plot(st_geometry(SFL[tipo=="Terraceria",]),col="red",axes=TRUE)
plot(st_geometry(SFL[tipo=="Pavimentada",]),add=TRUE)                

## ----Cap3_8,echo=TRUE,results="verbatim",crop=TRUE,fig.width=3, fig.height=3,cache=TRUE----
## P1 Polígono forestal al SudEste
## Polygon
# Crea una cadena de coordenadas en X
X1 <- c(5,10,10,6,5)
# Crea una cadena de coordenadas en Y
# Ojo tiene que cerrar (último par de coord = primero)
Y1 <-  c(0,0,5,5,0)
# Pega X y Y para crear una tabla de coordenadas
c1 <- cbind(X1,Y1)
print(c1)
class(c1)

# Crea el objeto Polygon. Un polygon es una forma simple cerrada
# eventualmente con hueco(s)
P1 = st_polygon(list(c1))
plot(P1,axes=T)

# P2 Polígono forestal al NorOeste
# Crea una cadena de coordenadas en X
X2 <- c(0,2,6,0,0)
# Crea una cadena de coordenadas en Y
Y2 <- c(4,4,10,10,4)
# Pega X y Y para crear una tabla de coordenadas
c2 <- cbind(X2,Y2)

# Polígono hueco  %%%%%%%%%%%%%% orden coordenadas !!!!!!!!!!!!!
# Crea una cadena de coordenadas en X
X3 <- c(1,1,2,2,1)
# Crea una cadena de coordenadas en Y
Y3 <- c(5,6,6,5,5)
# Pega X y Y para crear una tabla de coordenadas
c3 <- cbind(X3,Y3)
P2 = st_polygon(list(c2,c3))
plot(P2,axes=T)

# P4 Polígono de agricultura
c3i <- c3[nrow(c3):1, ] # Invierte el orden de las coordenadas
P4 = st_polygon(list(c3i)) # Esta vez no es hueco

# P5 Polígono de área urbana
X5 <- c(0,5,6,10,10,6,2,0,0)
Y5 <- c(0,0,5,5,10,10,4,4,0)
c5 <- cbind(X5,Y5)
P5 = st_polygon(list(c5))

# Junta varios sfg en un sfc (colección de simple features)
geometria3 = st_sfc(P1,P2,P4,P5)

## ----Cap3_9,echo=TRUE,results="verbatim",crop=TRUE,fig.width=4.5, fig.height=1.5,cache=TRUE----
# Tabla de atributos
ID <- c(1,2,3,4)
code <- c("F","F","U","A")
tipo <- c("Bosque","Bosque","Urbano","Agricultura")
tabpol <- data.frame(cbind(ID,code,tipo))

# sf object
SFPol = st_sf(tabpol, geometry = geometria3)
plot(SFPol,axes=TRUE)     
class(SFPol) # doble clase: simple feature y dataframe
print(SFPol) # ver columna lista "geometry"
summary(SFPol)

## ----Cap3_10,echo=TRUE,results="verbatim",crop=TRUE,fig.width=2, fig.height=3,cache=TRUE----
# Se puede extraer la tabla de atributos de un SFC con
as.data.frame(SFPol)

# Se puede selecionar ciertos rasgos usando la tabla de atributos
print(SFPol[tipo=="Bosque",])
Bosque <- SFPol[tipo=="Bosque",]
plot(st_geometry(SFPol),axes=TRUE)
plot(Bosque,add=TRUE, col = "green")      

## ----Cap3_10a,echo=TRUE,results="verbatim",crop=TRUE,fig.width=2, fig.height=2,cache=TRUE----
### Una colección puede eventualmente juntar diferentes tipos de geometría
Detodo <- st_sfc(P1,P2,L1,L2,P1)
plot(Detodo,border="red",axes=TRUE)

## ----Cap3_18,echo=TRUE,results="verbatim",fig.width=4, fig.height=3.5,crop=TRUE,cache=TRUE----
library(raster)
# Creamos una matriz
m <- matrix(c(1,2,3,4,2,NA,2,2,3,3,3,1),ncol=4,nrow=3,byrow=TRUE)
m
r <- raster(m)
extent(r) <- extent(c(0,4,0,3))
class(r)
print(r)
plot(r)

