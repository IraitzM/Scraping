# author: Iraitz Montalban
# date: May, 2023

rm(list = ls())
cat("\014")

# UTF-8 as the main encoding
options(encoding = "utf-8")

# Package management
#install.packages("pacman")
library("pacman")

# Install and load rvest
pacman::p_load("rvest")
# Data manipulation
pacman::p_load(dplyr)
pacman::p_load("hrbrthemes")

# Lets look for some tabular data from Perú
url <- "https://es.wikipedia.org/wiki/Departamentos_del_Per%C3%BA"
pagina <- read_html(url)

# Website code
pagina

# Let's get information from the main table
tabla<-pagina%>%
  html_table(fill = T)%>%
  as.data.frame()%>%
  select(2,3,4,5,6)

# Get flag images
enlacesImagen<-pagina %>%
  html_nodes("table") %>%
  html_nodes("a") %>%
  html_attr("href")

# Filter images from all references
enlacesImagen=enlacesImagen[grep(".svg$",enlacesImagen)]

# Make the complete urls available
enlacesImagen<-paste0("https://es.wikipedia.org",enlacesImagen)
enlacesImagen

################################################################################

# Target URL
url <- 'https://en.wikipedia.org/wiki/List_of_bordering_countries_with_greatest_relative_differences_in_GDP_(PPP)_per_capita'

html <- read_html(url)

tables <- html_table(html, fill=TRUE)

length(tables)

# Four tables were found
#   Inspecting their structure we will see all of them share the same calss: 
#   <table class="wikitable sortable jquery-tablesorter" style="text-align: right">
wiki <- html_nodes(html, '.wikitable')
length(wiki)

tabla <- html_table(wiki[[1]], fill = TRUE)
str(tabla)

# Lets select the columns of interest
tabla<-tabla[,c(1,2,3,5,6,8,9)]

# Change column names
names(tabla)<-c("posicion","paisRico","pibPaisRico","paisPobre","pibPaisPobre","ratio","region")

# Clean the data
tabla$pibPaisRico <- gsub(',', '', tabla$pibPaisRico)
tabla$pibPaisRico <- as.numeric(tabla$pibPaisRico)

tabla$pibPaisPobre <- gsub(',', '', tabla$pibPaisPobre)
tabla$pibPaisPobre <- as.numeric(tabla$pibPaisPobre)

# Let's take top 30
top30<-tabla[1:50,]
top30
