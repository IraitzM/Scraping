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
pacman::p_load(RCurl)
pacman::p_load(httr)
pacman::p_load(rjson)

# Let's check some of Clarifai's application: https://docs.clarifai.com/api-guide/predict/

# Here goes yout API key or Personal Access Token
apikey <- '<API KEY>'
# Image recognition model: https://clarifai.com/clarifai/main/models
base_url <- "https://api.clarifai.com/v2/models/aaa03c23b3724a16a56b629203edc62c/outputs"

# Let's process and image
img <- "https://cr00.epimg.net/radio/imagenes/2020/03/07/deportes/1583593958_257142_1583594654_noticia_normal.jpg"

# According to the documentation we need to provide a list called input
req <- list("inputs" = list())
# First element: data -> image -> url
req$inputs[[1]] <- list(data=list(image=list(url = img)))
# Build now the request
requests <- rjson::toJSON(req)

# Set the key in the headers
key = paste("Key", apikey)
r <- POST(base_url, 
          add_headers(
            "Authorization" = key,
            "Content-Type" = "application/json"),
          body = requests)
r

# Parse content
r <- httr::content(r, 'parsed')

# Check probabilities
for (result in r$outputs[[1]]$data$concepts){
  message('object: ', result$name, ' -- probability: ', result$value)
}



