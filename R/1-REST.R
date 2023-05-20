# author: Iraitz Montalban
# date: May, 2023

rm(list = ls())
cat("\014")

# UTF-8 as the main encoding
options(encoding = "utf-8")

# Package management
#install.packages("pacman")
library("pacman")

# Launch a local server
source("R/RESTserver/launcher.R")
start_plumber("R/RESTserver/server.R",9999)

# Check your server on http://localhost:9999/__docs__/

# Let's look for our URL
url <- "http://localhost:9999"

# Random numbers
endpoint  <- "/random_numbers"
parameters <- "?maxn=5"
query <- paste0(paste0(url, endpoint), parameters)

httr::GET(query)

response <- httr::GET(query)

# Status code
response$status_code

# Content
response$content

# as text
text <- httr::content(response, as = "text", encoding = "UTF-8")
text

# Parse JSON
jsonlite::fromJSON(text)

# Operation

response <- httr::POST(
  url = paste0(url, "/operation"),
  body = NULL,
  encode = c("raw")
)
# Error code
response$status_code
# Message
httr::content(response, as = "text", encoding = "UTF-8")

# JSON request
json_body <- '{ 
  "numbers" : [3,4,5,6], 
  "metric" : "mean"
}'

response <- httr::POST(
  url = paste0(url, "/operation"),
  body = json_body,
  encode = c("raw")
)
# Ok
response$status_code

# Parse
text <- httr::content(response, as = "text", encoding = "UTF-8")
text

# Parse JSON
jsonlite::fromJSON(text)


# Kill server
kill_plumber()
