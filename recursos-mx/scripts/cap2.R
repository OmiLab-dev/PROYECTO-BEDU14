## ----primeirospassos1,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  primervalor <- 5
  segundovalor <- 4
  suma <- primervalor + segundovalor
  print(suma)
  suma

## ----primeirispassos2,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  suma <- sum(primervalor,segundovalor,primervalor)
print(suma)

## ----primerospasos3,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
# Datos de precipitación mensual en Ensenada, Baja California
Prec <- c(15, 40, 37, 37, 0, 0, 0, 0, 0, 7, 3, 77)
meses <- c("Enero", "Febrero", "Marzo", "Abril")
numeros <- 1:4

## ----primerospasos4,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  # Lista de los objetos
  ls()

# Muestra el tipo de datos
class(Prec)
class(meses)
class(numeros)

print(prec) # prec no existe, es Prec 
# Pregunta es un vector?
is.vector(Prec)
is.vector(meses)
is.vector(numeros)

# Indica la longitud del vector
length(Prec)
length(meses)
length(numeros)

## ----primerospasos5,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
# Muestra el contenido del objeto en pantalla
print(Prec)
print(meses)
print(numeros)

# Calcula estadísticas básicas (Máxima, mínima, promedio y suma)
max(Prec)  # máximo
min(Prec)  # mínimo
mean(Prec) # promedio
sum(Prec)  # suma 

## ----primerospasos6,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
# Determina la ruta del espacio de trabajo
setwd("/home/jf/libroRGIS/")
# Muestra la ruta del espacio de trabajo
getwd()

# Carga la tabla "ensenada.csv" en el objeto tab
tab <- read.csv("recursos-mx/ensenada.csv")

# Tipo del objeto tab
class(tab)

# Muestra la tabla completa
print(tab)

# Muestra las primeras filas de la tabla
head(tab)

## ----primerospasos7,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
# Muestra nombres (encabezados) de las columnas
names(tab)

# Muestra una sola columna (P)
print(tab$P)

# Una columna de tabla es un vector
is.vector(tab$P)

## ----primerospasos8,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  # Calculemos el rango de temperatura (T max - T min)
  # Nueva columna en la tabla: rango
  tab$rango <- tab$Tmax - tab$Tmin

# Muestra las primeras filas de la tabla
head(tab)

## ----primerospasos9,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  # factor
  tab$PCvid
class(tab$PCvid)
as.numeric(tab$PCvid)

## ----primerospasos10,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
tab[1,2]
tab[,c(1,2,6)] # selecciona las filas enteras
tab[1:6, c(1:3,6)]
tab[-(10:12),-4]
tab[, c("mes","P","Tprom")] # equivalente a tab[,c(1,2,6)]

## ----primerospasos11,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
tab[tab$Tmax > 25,]
tab[tab$PCvid == "no",]
subset(tab,Tmax > 25)
subset(tab,PCvid == "no")
subset(tab,PCvid == "no",select= c("mes","P","Tprom"))

## ----primerospasos12,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
# install.packages("dplyr") # en caso que no esté instalado
library(dplyr)
filter(tab,PCvid == "no")
select(tab,c(mes, Tmin:Tprom))
select(filter(tab,PCvid == "no"),c(mes, Tmin:Tprom))

## ----primerospasos13,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  # Guarda la tabla en un archivo de texto
  write.table(tab, file="tabla.txt")

## ----primerospasos14,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
# Conversión de data.frame a matriz
m <- as.matrix(tab[,1:7]) # parte numérica de la tabla tab
class(m)
print(m)

# indexación: 2a fila, 4a columna
print(tab[2,4])
print(m[2,4])
print(m[1:3,4])
print(m[,4])
print(m[1,])

## ----primerospasos15,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,crop=TRUE,cache=TRUE----
plot(tab$dias,tab$P)

## ----primerospasos16,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,crop=TRUE,cache=TRUE----
plot(tab$dias,tab$P,  xlab="Número de días de lluvia", ylab="Precipitación mensual (mm)",
     pch=22, col="darkblue", bg="blue",
     main="Relación días de lluvias / Precipitación", sub = "Ensenada, BC", cex=0.8)

## ----primerospasos17,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  # Correlación
  cor(tab$dias,tab$P)

# Para cualquier duda, pedir ayuda!
help(cor)
?cor()
cor(tab$dias,tab$P, method = "pearson")
cor(tab$dias,tab$P, method = "spearman")

# Una regresión lineal entre la prec y el número de días de lluvia
reg <- lm(tab$P ~ tab$dias)

# Los resultados del ajuste lineal
summary(reg)
resumen <- summary(reg)

# Unas nuevas clases de objeto: lm (linear model) y summary.lm
class(reg)
class(resumen)

# summary.lm guarda la información en una matriz llamada coeffcients
resumen$coefficients
# Recuperando un elemento particular de la matriz (t value del intercept)
resumen$coefficients[1,3]

# Una lista (list) es una lista de objetos de diferentes tipos
lista <- list(Prec, reg, "lista rara")
lista

# Muestra el primer y el tercer elemento de la lista
lista[[1]]
lista[[3]]

## ----primerospasos18,echo=TRUE,results="verbatim",cache=TRUE-------------
# Crea una matriz de 3 x 3
# byrow=T: los números del vector entran por fila
m <- matrix(c(1,2,2,3,6,0,4,7,9),ncol=3,byrow=T)
print(m)

colSums(m)
rowSums(m)
colMeans(m)

## ----primerospasos19,echo=TRUE,results="verbatim",cache=TRUE-------------
apply(m,1,sum)
apply(m,2,sum)
apply(m,1,mean)
apply(m,1,max)
apply(m,2,sd)

## ----primerospasos20,echo=TRUE,results="verbatim",cache=TRUE-------------
aggregate(P ~ PCvid, data = tab, FUN = "sum")
aggregate(x = tab$P, by = list(tab$PCvid), FUN = "sum")
aggregate(Tprom ~ PCvid, data = tab, FUN = "mean")

## ----primerospasos21,echo=TRUE,results="verbatim",cache=TRUE-------------
# con dplyr
por_estacion <- group_by(tab, PCvid)
summarise(por_estacion, Ptotal = sum(P), Tprom_anual = mean(Tprom))

## ----primerospasosfuncion,echo=TRUE,results="verbatim",cache=TRUE--------
# Definición de una función para sumar un valor numérico
# con el doble de un segundo valor
Func <- function (a, b) {
  resultado <- a + 2 * b
  resultado
}
# Ejecución de la función
Func(3,7)  # 3 + 2 * 7 = 3 + 14 = 17

## ----primerospasos22,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
for (i in 1:6){
  print(i)
}

## ----primerospasos23,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
fac <- 1
for (i in 1:4){
  fac <- fac * i
}
print(fac)

## ----primerospasos24,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
  vector <- c(0,0,0,0)
  for (i in 1:4){
 vector[i] <- i*2
  }
  print(vector)

## ----primerospasos25,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
vector <- c(9,4,2,12,3,6)
suma <- 0
for (i in 1:length(vector)){
if (vector[i] > 5) {suma <- suma + vector[i]} else {suma <- suma -1}
print(suma)
}

## ----primerospasos26,echo=TRUE,results="verbatim",fig.width=4, fig.height=4,cache=TRUE----
i <- 1
nombre <- paste("mapa",i,".txt",sep="")
print(nombre)
  
for (i in 1:4){
  nombre <- paste("mapa",i,".txt",sep="")
  print(nombre)
  }
  
# Nombres bandas imagen Sentinel 2
for (i in c("B02","B03","B8A","TCI")){
  nombre <- paste("T23KNT_20170701T131241_",i,".TIF",sep="")
  print(nombre)
  }

## ----Cap2_pipe1,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE-------
## resultado <- funcion3(funcion2(funcion1(entrada)))
## resultado <- entrada %>% funcion1() %>% funcion2() %>% funcion3()

## ----pipe2,echo=TRUE,results="verbatim",cache=TRUE-----------------------
# Dos funciones que se aplican de forma succesiva: 
# 2 líneas de código, un objeto intermediario (por_estacion)
por_estacion <- group_by(tab, PCvid)
summarise(por_estacion, Ptotal = sum(P), Tprom_anual = mean(Tprom))

# Con pipe
group_by(tab, PCvid) %>% summarise(Ptotal = sum(P), Tprom_anual = mean(Tprom))

