predictores <- data[,c(8,9,10,15,16,17)] # Predictores pc, tv, internet, diabetes, obesidad e hipertensión

library(corrplot)
source("http://www.sthda.com/upload/rquery_cormat.r")
cor <- rquery.cormat(predictores) # Matriz de correlaciones

lm.fit <- lm(data$totinf ~ diab + internet + internet*diab, predictores) # Regresión lineal
summary(lm.fit)
