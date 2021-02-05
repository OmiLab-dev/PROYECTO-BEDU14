# Recuerda descargar previamente la carpeta de mxmaps de
# la URL:https://www.diegovalle.net/mxmaps/index.html
# Los archivos de trabajo tienen que estar en la misma carpeta

# Directorio donde se encuentran los archivos
setwd("~/recursos-mx/")

# Cargar las librerias a utilizar para generar los mapas
# NOTA: La libreria "mxmaps" fue generada por diego valle
#URL:https://www.diegovalle.net/mxmaps/index.html
# Para instalar la libreria mxmaps se debe utilizar la siguiente linea:
# devtools::install_github("diegovalle/mxmaps")
# Posteriormente install.packages("mxmaps")
library(tidyverse)
library(sf)
library(ggplot2)
library("mxmaps")
library(RColorBrewer)

#Cargar la base de datos que contienen las variables a analizar
tabla <- read.csv("data.csv")

# Cargar el archivo shp que contiene informaciÃ³n del mapa de mÃ©xico por estados y municipios 
mx <- st_read("Entidades_latlong.shp")

# Ordernar por nombre de estado
attach(mx)
mx <- mx[order(CveEdo),]

# Selecciono codigo de estado de la base de datos
CveEdo <- tabla$num_ent

# Seleccionar total de poblacion de la base de datos
Poptotal <- tabla$totest
# Seleccionar total de decesos de la base de datos
Descesos <- tabla$totinf
# Generar el promedio de cada variable de tecnologÃ­a por estado
int_est <- (tabla$internet/tabla$totest)*100
pc_est <- (tabla$pc/tabla$totest)*100
tv_est <- (tabla$tv/tabla$totest)*100

tecnologia_est <- data.frame(int_est, pc_est, tv_est)
promedio_est <- data.frame(tecnologia_est[,1], Means=rowMeans(tecnologia_est[,-4]))
promedio_est <- promedio_est$Means

# Generar un data frame con las variables a graficar
tabla <- data.frame(CveEdo, Descesos, Poptotal, promedio_est)

# Verificar la clase de las variables
class(mx)
class(tabla)

# Unir el data frame generado al archivo shp, considerando el codigo de estado
mx_poblacion <- mx %>%
  left_join(tabla,
            by=c("CveEdo" = "CveEdo"))
mx_poblacion

# Lectura del data frame que contiene informacion de los estados
df_mxstate
df_mxstate$region #Seleccionar la region

##### Generación de los mapas de población total y decesos por estado

Pob <- mx_poblacion$Poptotal # Definir la variable Pob
Decesos <- mx_poblacion$Descesos # Definir la variable Decesos
prom_tec <- mx_poblacion$promedio_est
region <- df_mxstate$region  # Definir la variable region
state_name <- df_mxstate$state_name  #Definir la variable state name
state_name_official <- df_mxstate$state_name_official #Definir la variable state_name_official
state_abbr <- df_mxstate$state_abbr # Definir la variable state_abbr
state_abbr_oficial <- df_mxstate$state_abbr_official # Definir state_abbr_oficial

# Generar un data frame con la información de las variables anteriormente definidas
datos <- data.frame(region, state_name, state_name_official,
                    state_abbr, state_abbr_oficial, Pob, Descesos, prom_tec)

# Generar el mapa de total de población por estado
df_mxstate$value <- datos$Pob
mxstate_choropleth(df_mxstate, title = "Total de la poblaciÃ³n mexicana por estado", 
                   num_colors = 9) +
  theme(plot.title = element_text(hjust = 0.5, size = 18),
        legend.key.size = unit(0.5,"cm"), legend.direction = "horizontal", 
        legend.position = "bottom", legend.title = element_text(size = 16)) + 
  guides(fill=guide_legend(title=NULL)) +
  knitr::opts_chunk$set(fig.width=30, fig.height=15, fig.align = "center")


# Generar el mapa del total de decesos por estado
df_mxstate$value <- datos$Descesos
mxstate_choropleth(df_mxstate, title = "Total de decesos en México por estado", 
                   num_colors = 9) +
  theme(plot.title = element_text(hjust = 0.5, size = 18),
        legend.key.size = unit(0.5,"cm"), legend.direction = "horizontal", 
        legend.position = "bottom", legend.title = element_text(size = 16)) + 
  scale_fill_brewer(palette = "Reds") + guides(fill=guide_legend(title=NULL)) +
  knitr::opts_chunk$set(fig.width=30, fig.height=25, fig.align = "center")

# Generar el mapa de tecnología por estado
df_mxstate$value <- datos$prom_tec
mxstate_choropleth(df_mxstate, title = "Promedio de tecnología por estado", 
                   num_colors = 9) +
  theme(plot.title = element_text(hjust = 0.5, size = 18),
        legend.key.size = unit(0.5,"cm"), legend.direction = "horizontal", 
        legend.position = "bottom", legend.title = element_text(size = 16)) + 
  scale_fill_brewer(palette = "Greens") + guides(fill=guide_legend(title=NULL)) +
  knitr::opts_chunk$set(fig.width=30, fig.height=15, fig.align = "center")

## Grafica de pastel

# Lectura de la base de datos
tabla <- read.csv(file = "datav3.csv")

total_tec <- sum(int_est, pc_est, tv_est)/3 #% total de población con tecnología

### Grafica de pastel (¿Cuanta tecnología está presente en la población de México?)
# Generar un data frame
data <- data.frame(category=c("Con tecnología", "Sin tecnología"),
                   count=c(59.62, 40.38))
# Calcular porcentajes
data$fraction <- data$count / sum(data$count)
# Calcular porcentajes acumulativos (parte superior de cada rectangulo)
data$ymax <- cumsum(data$fraction)
# Calcular la parte inferior de cada rectangulo
data$ymin <- c(0, head(data$ymax, n=-1))
# Calcular la posicion de la etique
data$labelPosition <- (data$ymax + data$ymin) / 2
# Generar una etique
data$label <- paste0(data$category, "\n", data$count, "%")
# Hacer la gráfica
ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  geom_label( x=3.5, aes(y=labelPosition, label=label), size=4) +
  scale_fill_brewer(palette=4) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme_void() +
  ggtitle("Población total en México (Censo 2020)") +
  theme(legend.position = "noun", plot.title = element_text(hjust = 0.5)) 
