library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    dashboardHeader(
        title = "Proyecto Bedu"
    ),
    
    dashboardSidebar(
        sidebarMenu(id="sbmenu",
                    
                    menuItem("Equipo 14", tabName = "Equipo 14",
                             menuSubItem('Detalles', tabName = 'menu01')
                    ),
                    
                    menuItem("Problema",tabName = "Problema" ,
                             menuSubItem('Introducción', tabName = 'menu11'),
                             menuSubItem('Objetivo', tabName = 'menu12'),
                             menuSubItem('Hipotesis', tabName = 'menu13')
                    ),
                    
                    menuItem("Análisis descriptivo",tabName = "menu2" ,
                             menuSubItem('Datos', tabName = 'menu21'),
                             menuSubItem('Pregunta clave', tabName = 'menu22'),
                             menuSubItem('Población', tabName = 'menu23'),
                             menuSubItem('Acceso a tecnología', tabName = 'menu24'),
                             menuSubItem('Distribución de tecnología', tabName = 'menu25'),
                             menuSubItem('Distribución de defunciones', tabName = 'menu26')
                    ),
                    
                    menuItem("Análisis estadístico",tabName = "menu3" ,
                             menuSubItem('Pregunta clave', tabName = 'menu31'),
                             menuSubItem('Correlaciones', tabName = 'menu32'),
                             menuSubItem('Regresión lineal', tabName = 'menu33')
                    ),
                    
                    menuItem("Conclusiones",tabName = "menu4" ,
                             menuSubItem('Conclusiones', tabName = 'menu41'),
                             menuSubItem('Complicaciones', tabName = 'menu42')
                    )
        )
    ),
    
    dashboardBody(
        tabItems(
            tabItem("menu01",h1("Programación y estadística con R (Santander)"),h1("Implicaciones del COVID-19 en el sector tecnológico en México"),img( src = "equipo.jpeg", height = 550, width = 700)),
            tabItem("menu11",h1("Introducción"), h4("A raíz de la situación de emergencia por COVID-19, se han identificado diferentes causas que generan un mayor número de defunciones; entre ellas las enfermedades  que engloban el síndrome metabólico (diabetes, hipertensión y obesidad) y la necesidad de salir a trabajar por no contar con las herramientas necesarias para realizar trabajo en casa (home office).  Debido a lo anterior, surge la idea de analizar si existe una relación entre la tecnología (internet, PC y TV) con la que cuenta un hogar
mexicano y las defunciones por COVID-19, con el propósito de determinar cuáles son las zonas más vulnerables y tomar acciones que disminuyan el número de casos. ")),
            tabItem("menu12",h1("Objetivo"), h4("Identificar si existe una relación entre la tecnología en cada hogar de la República Mexicana y las defunciones por COVID-19.")),
            tabItem("menu13",h1("Hipotesis"), h4("Si existe un mayor índice de tecnología en los estados, entonces se presentará una menor incidencia de defunciones."),h6("Referencias"), h6("Secretaría de Salud (2021) Datos abiertos de defunciones por COVID-19, 31-01-2021.  Recuperado de http://www.dgis.salud.gob.mx/contenidos/basesdedatos/da_defunciones_gobmx.html
"), h6("INEGI(2021) Censo de población y vivienda 2020. Recuperado de https://www.inegi.org.mx/programas/ccpv/2020/")),
            
            tabItem("menu21",
                    h1("Datos obtenidos"), 
                    h4("De la base de datos INEGI y SSA, se seleccionaron por estado los siguientes datos:"), 
                    h4("- Población total."), 
                    h4("- Tecnologías (Internet, PC y TV)."), 
                    h4("- Defunciones por causas del síndrome metabólico (diabetes, hipertensión, obesidad)."),
                    h4("Con estos datos, se elabora un data frame para realizar un análisis estadístico utilizando Rstudio."), 
                    dataTableOutput("table")
                    
            ),
            tabItem("menu22",h1("Resultados"), h2("Pregunta clave 1"), h3("¿Existe una relación entre el índice de tecnología (internet, PC y TV) y el número de defunciones?")),
            tabItem("menu23",h1("Población"), h4("En el primer mapa se observa la distribución de la población por estado. En el mapa observamos mostrando una alta densidad en zonas como la Ciudad de México, Estado de México, Jalisco y Veracruz."), img( src = "poblacion_total.png", height = 550, width = 700)),
            tabItem("menu24",h1("Acceso a tecnología"), img( src = "tecnologia.png", height = 450, width = 600)),
            tabItem("menu25",h1("Distribución de tecnología"), img( src = "mapa_tecnologia.png", height = 550, width = 700)),
            tabItem("menu26",h1("Distribución de defunciones"), img( src = "decesos.png", height = 550, width = 700)),
            
            tabItem("menu31",h1("Resultados"), h3("Pregunta clave"), h4("¿Existe una relación entre el índice de tecnología y alguna de las causas (hipertensión, diabetes y obesidad) que generan el síndrome metabólico?")),
            tabItem("menu32",h1("Matriz de correlaciones"), img( src = "cor.png", height = 600, width = 1000)),
            tabItem("menu33",h1("Regresión lineal"), img( src = "regresion.png", height = 450, width = 750)),
            
            tabItem("menu41",h1("Conclusiones"), h3("En el primer análisis, los estados de Guadalajara, CDMX, Monterrey y Área Metropolitana muestran un mayor índice de población, de tecnología y de defunciones con respecto al resto del país. Por su parte, la zona sur del país, muestra un índice menor de población, un nivel medio de tecnología y un menor índice de defunciones. Con estos datos se sugiere que el nivel de tecnología es indispensable para disminuir los casos de infección y de defunción. Sin embargo, es claro que ciudades que tienen un crecimiento de población mayor a la media, no cumplen con este criterio."),
                    h3("En el segundo análisis se encontró una correlación entre el internet y la diabetes con el número de defunciones. Esto nos indica que posiblemente la reducción de actividad física durante la pandemia, al tener posibilidades de hacer home office y actividades de recreación dentro de sus hogares (como el uso de servicios de streaming), podrían ser relevantes para el aumento de diabetes y defunciones. "), h3("De acuerdo a lo anterior, se puede proponer diseñar nuevas estrategias de promoción de la salud para las personas que realizan home office y así mejorar el estilo de vida  entre la población ante las nuevas tendencias de prácticas laborales."),
                    h3("Con esto, se concluye que el índice de tecnología es indispensable para frenar la cadena de contagio; sin embargo, podría estar interviniendo el estilo de vida de cada persona, el cual es un indicador de presentar o no síndrome metabólico.")),
            tabItem("menu42",h1("Complicaciones"), h3("En lo general, para mostrar mejor las densidades de tecnología y población, se necesitaba un tipo de gráfico distinto a los que vimos en clase, lo cual llevó a investigar nuevas opciones como el manejo de las librerías “mxmaps” y “corrplot”, que funcionan muy bien para demostrar este tipo de datos."))
            
        )
    )
)


server <- function(input, output) {
    library(dplyr)
    data <- read.csv("https://raw.githubusercontent.com/OmiLab-dev/PROYECTO-BEDU14/main/data.csv")
    data <- data[,-c(5,6,12,13,14,18,19)]
    data2 <- rename(data, Estados = estados, Código = cod, ID = num_ent, Población = totest, Defunciones = totinf, Viviendas = hab, Internet = internet, PC = pc, TV = tv, Diabetes = diab, Obesidad = obe, Hipertensión = hip)
    observe(print(input$sbmenu))
    
    output$table <- renderDataTable({data2})
}

shinyApp(ui,server)
