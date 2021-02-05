library(dplyr)

file <- read.csv("210128COVID19MEXICO.csv")
inegi<- read.csv("conjunto_de_datos_iter_00_cpv2020.csv")

#COVID limpieza y extracción

file <- select(file, ENTIDAD_RES, SEXO, EDAD, INDIGENA, DIABETES, HIPERTENSION, OBESIDAD, MIGRANTE)

totinf <- c()
infhom <- c()
infmuj <- c()
infedad <- c()
diab <- c()
hip <- c()
obe <- c()
ind <- c()
mig <- c()

for(i in 1:32){
  filt <- filter(file, ENTIDAD_RES == i)
  totinf[i] <- nrow(filt)
  infhom[i] <- sum(filt$SEXO == 2)
  infmuj[i] <- sum(filt$SEXO == 1)
  infedad[i] <- mean(filt$EDAD)
  diab[i] <- sum(filt$DIABETES == 1)
  hip[i] <- sum(filt$HIPERTENSION == 1)
  obe[i] <- sum(filt$OBESIDAD == 1)
  ind[i] <- sum(filt$INDIGENA == 1)
  mig[i] <- sum(filt$MIGRANTE == 1)
}

#INEGI limpieza y extracción 

totest <- inegi$POBTOT[inegi$NOM_LOC == "Total de la Entidad"]
tothom <- inegi$POBFEM[inegi$NOM_LOC == "Total de la Entidad"]
totmuj <- inegi$POBMAS[inegi$NOM_LOC == "Total de la Entidad"]
hab <- as.numeric(inegi$VIVPAR_HAB[inegi$NOM_LOC == "Total de la Entidad"])
internet <- as.numeric(inegi$VPH_INTER[inegi$NOM_LOC == "Total de la Entidad"])
tv<- as.numeric(inegi$VPH_TV[inegi$NOM_LOC == "Total de la Entidad"])
pc <- as.numeric(inegi$VPH_PC[inegi$NOM_LOC == "Total de la Entidad"])

estados <- unique(inegi$NOM_ENT)[-1]
estados[c(9,15,16,19,22,24,31)] <- c("Ciudad de México", "México", "Michoacán de Ocampo", "Nuevo León", "Querétaro", "San Luis Potosí", "Yucatán")
cod <- c("Ags", "BC", "BCS", "Camp", "Coah", "Col", "Chis", "Chih", "CDMX", "Dgo", "Gto", "Gro", "Hgo", "Jal", "Mex", "Mich", "Mor", "Nay", "NL", "Oax", "Pue", "Qro", "Q. Roo", "SLP", "Sin", "Son", "Tab", "Tamps", "Tlax", "Ver", "Yuc", "Zac")
perxvivien <- c(3.7, 3.3, 3.3, 3.6, 3.5, 3.2, 4.1, 3.2, 3.3, 3.7, 3.9, 3.7, 3.6, 3.6, 3.7, 3.7, 3.5, 3.4, 3.5, 3.7, 3.8, 3.5, 3.2, 3.6, 3.5, 3.3, 3.6, 3.3, 3.9, 3.4, 3.5, 3.7)

data <- data.frame(estados, cod, "num_ent" = seq(1,32,1), totest, tothom, totmuj, hab, internet, tv, pc, totinf, infhom, infmuj, infedad, diab, hip, obe, ind, mig)

# Numero de personas promedio por vivienda en cada estado INEGI
data <- mutate(data, pc = round(pc*perxvivien), 
               tv = round(tv*perxvivien), 
               internet = round(internet*perxvivien))

write.csv(data, file="data.csv", row.names = FALSE)
