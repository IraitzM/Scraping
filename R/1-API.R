# author: Iraitz Montalban
# date: May, 2023

rm(list = ls())
cat("\014")

# UTF-8 as the main encoding
options(encoding = "utf-8")

# Package management
#install.packages("pacman")
library("pacman")

# Libraries
pacman::p_load(httr) # API call enabler
pacman::p_load(rvest) # API call enabler
pacman::p_load(jsonlite) # JSON object manipulation
pacman::p_load(dplyr) # Data cleansing
pacman::p_load(ggplot2) # Plots
pacman::p_load(gganimate) # Animations
pacman::p_load(forcats) # Factor treatment
pacman::p_load(leaflet) # Maps

# API: datos.gob.es
url  <- "https://datos.gob.es/apidata/catalog/dataset"
parameters <- "?_sort=title&_pageSize=10&_page=0"
query <- paste0(url, parameters)

request <- GET(url = query)
request$status_code # 200

# Process results
response <- content(request, as = "text", encoding = "UTF-8")
df <- fromJSON(response, flatten = TRUE) %>% 
  data.frame()
df

# Let's look based on format
endpoint <- "/format/json"
query <- paste0(url, endpoint)
query <- paste0(query, parameters)

request <- GET(url = query)
request$status_code # 200

# Process results
response <- content(request, as = "text", encoding = "UTF-8")
df <- fromJSON(response, flatten = TRUE) %>% 
  data.frame()

# What about streaming APIs
# Site: https://openskynetwork.github.io/opensky-api/rest.html
url = "https://opensky-network.org/api/states/all"
request <- GET(url)
request$status_code # 200

response <- content(request, as = "text", encoding = "UTF-8")
df <- fromJSON(response)
df <- df[["states"]]
df <- as.data.frame(df)

# Let's get what each field means
url = "https://openskynetwork.github.io/opensky-api/rest.html"
names <- read_html(url) %>% 
  html_nodes("#all-state-vectors")  %>% 
  html_nodes("#response")  %>% 
  html_nodes('.docutils') %>% 
  rvest::html_table()

# Assign names
colnames(df) <- names[[2]]$Property

# Oops, seems category is missing
colnames(df) <- names[[2]]$Property[c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)]
data <- as.data.frame(df, stringsAsFactors = FALSE)

# We can store this information
write.csv(data, "planes.csv", row.names = FALSE)

# Some data may need to be converted
data$longitude <- as.numeric(data$longitude)
data$latitude <- as.numeric(data$latitude)

# Create a map
leaflet() %>%
  addTiles() %>%
  addCircles(lng = data$longitude, 
             lat = data$latitude, 
             color = "#ff5733", opacity = 0.3) 
