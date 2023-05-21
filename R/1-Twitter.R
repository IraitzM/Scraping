# author: Iraitz Montalban
# date: May, 2023

rm(list = ls())
cat("\014")

# UTF-8 as the main encoding
options(encoding = "utf-8")

# Package management
#install.packages("pacman")
library("pacman")

pacman::p_load(httr)

# Remember to obtain you TOKEN from the Developer porta
# > https://developer.twitter.com/en/docs/twitter-api/tweets/search/introduction
# > https://developer.twitter.com/en/docs/tutorials/step-by-step-guide-to-making-your-first-request-to-the-twitter-api-v2

# Token
token <- '<YOUR TOKEN>'

# API
api <- 'https://api.twitter.com/'
endpoint <- '2/tweets/search/recent'

# Parameters
query <- 'Eurovision'

# Auth header
key <- paste0('Bearer ', token)

# GET
base_url <- paste0(api, endpoint)
base_url <- paste0(base_url, '?query=')
base_url <- paste0(base_url, query)
base_url

r <- GET(base_url, 
          add_headers(
            "Authorization" = key))
r$status_code
response <- content(r, as = "text", encoding = "UTF-8")
response

tweets <- fromJSON(response)
tweets$data
