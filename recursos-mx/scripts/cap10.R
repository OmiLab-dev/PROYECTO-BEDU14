## ----Cap10_code1,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE------
## ##Layer = raster
## ##showplots
## hist(as.matrix(Layer),main="Histograma",xlab="Mapa")

## ----Cap10_code2,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE------
## ##polyg=vector
## ##numpoints=number 10
## ##output=output vector
## ##sp=group
## 
## pts <- spsample(polyg,numpoints,type="random")
## output=SpatialPointsDataFrame(pts, as.data.frame(pts))

## ----Cap10_code3i1,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## install.packages(c("Rcpp", "RcppProgress", "rbenchmark", "inline"))

## ----Cap10_code3i2,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## install.packages("/home/jf/Downloads/dinamica_1.0.2.tar.gz", repos=NULL, type="source")

## ----Cap10_code3,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE------
## tabla <- t1
## colnames(tabla) <- c("valores", "n")
## png("histograma.png")
## plot(tabla$n,tabla$valores,main="Histograma banda 2", xlab="",
##      ylab="Número de celdas")
## dev.off()

## ----Cap10_code4,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE------
## # Recibe datos de DINAMICA
## numptos <- v1
## numlin <- v2
## numcol <- v3
## 
## # Genera coordenadas aleatorias
## y <- floor(runif(numptos, min=1, max=numlin))
## x <- floor(runif(numptos, min=1, max=numcol))
## tab <- cbind(seq(1:numptos),x,y)
## 
## # Pasa la tabla a Dinamica
## outputTable("tabxy", tab)

## ----Cap10_code5,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE------
## # Importa las dos tablas de Dinamica
## tabla1 <- t1
## tabla2 <- t2
## colnames(tabla1) <- colnames(tabla2) <- c("key", "ND")
## # Extrae la columna con los valores espectrales
## x <- tabla1$ND
## y <- tabla2$ND
## # crea un dataframe
## tab <- data.frame(cbind(x,y))!
## 
## # Elabora diagrama de dispersión
## png("diag_dispersion.png")
## plot(x,y,main="Diagrama de dispersión banda 2 versus 1", xlab="banda 1",
##      ylab="banda 2")
## dev.off()
## 
## # Ajusta modelo lineal
## regression <- lm(formula=y~x, data=tab)
## print(regression)
## coefficents <- coef(regression)
## # y = a x + b
## 
## # Exporta a Dinamica los coeficientes de la ecuación
## outputDouble("b", coefficents[1])
## outputDouble("a", coefficents[2])

