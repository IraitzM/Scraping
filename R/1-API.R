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
pacman::p_load(jsonlite) # JSON object manipulation
pacman::p_load(dplyr) # Data cleansing
pacman::p_load(ggplot2) # Plots
pacman::p_load(gganimate) # Animations
pacman::p_load(forcats) # Factor treatment

# API: ...
url  <- "https://..."
request <- GET(url = url)
request$status_code # 200

# Process results
response <- content(request, as = "text", encoding = "UTF-8")
df <- fromJSON(response, flatten = TRUE) %>% 
  data.frame()
