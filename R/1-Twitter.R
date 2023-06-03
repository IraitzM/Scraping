# author: Iraitz Montalban
# date: May, 2023

rm(list = ls())
cat("\014")

# UTF-8 as the main encoding
options(encoding = "utf-8")

# Package management
#install.packages("pacman")
library("pacman")

pacman::p_load(httr) # REST functions
pacman::p_load(RCurl) # Curl requests
pacman::p_load(jsonlite) # JSON

# Remember to obtain you TOKEN from the Developer portal
# > https://developer.twitter.com/en/docs/tutorials/step-by-step-guide-to-making-your-first-request-to-the-twitter-api-v2

# API
api <- 'https://api.twitter.com/'

# Getting the token automatically
# > https://developer.twitter.com/en/docs/authentication/api-reference/token
api_key <- '<API_KEY>'
api_secret <- '<API_SECRET>'

# POST oauth2
endpoint <- 'oauth2/token'
parameters <- 'grant_type=client_credentials'

base_url <- paste0(api, endpoint)
base_url <- paste0(base_url, '?')
base_url <- paste0(base_url, parameters)
base_url

user_pass <- paste0(utils::URLdecode(api_key),":")
user_pass <- paste0(user_pass, utils::URLdecode(api_secret))
key <- paste0('Basic ', base64(user_pass))

r <- POST(base_url, 
         add_headers(
           "Authorization" = key,
           "Content-Type" = 'application/x-www-form-urlencoded;charset=UTF-8'))
r$status_code
response <- content(r, as = "text", encoding = "UTF-8")
token <- fromJSON(response)$access_token
token

### Search
# > https://developer.twitter.com/en/docs/twitter-api/tweets/search/introduction

#Search enpoint
endpoint <- '2/tweets/search/recent'
query <- 'elecciones'

# Auth header
key <- paste0('Bearer ', token)

# Base URL
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

# Get structured data
tweets_df <- fromJSON(response)$data

# Check it, every time we ask, it changes

# Packages
pacman::p_load(rtweet) # https://www.rdocumentation.org/packages/rtweet/versions/1.1.0

# Auth
vignette("auth", "rtweet")
auth <- rtweet_app()

tweets_df <- search_tweets(query, n = 1000, token = auth)

# Processing text
pacman::p_load("wordcloud")
pacman::p_load("RColorBrewer")
pacman::p_load("wordcloud2")
pacman::p_load(tidytext)
pacman::p_load(magrittr)

# Create a vector containing only the text
text <- tweets_df$text

# Clean text (regex)
text <- gsub("https\\S*", "", text) 
text <- gsub("@\\S*", "", text) 
text <- gsub("amp", "", text) 
text <- gsub("[\r\n]", "", text)
text <- gsub("[[:punct:]]", "", text)

tweets_words <-  tweets_df %>%
  dplyr::select(text) %>%
  unnest_tokens(word, text)
words <- tweets_words %>% dplyr::count(word, sort=TRUE)

# Let's paint the wordcloud
wordcloud(words = words$word, freq = words$n, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35,
          colors=brewer.pal(8, "Dark2"))
