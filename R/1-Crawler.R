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
pacman::p_load(devtools)
pacman::p_load(dplyr)
pacman::p_load(RSelenium)
pacman::p_load(wdman)
pacman::p_load(xml2)
pacman::p_load(tidyverse)

# Let's open a phantom browser
server <- phantomjs(port=5010L)
remDr <- remoteDriver(browserName = "phantomjs", port=5010L)
remDr$open()

# We will navigate to our target website
remDr$navigate("http://www.imdb.com/title/tt1490017/")
remDr$screenshot(display = TRUE) 

# Get web page HTML code
pagina <- remDr$getPageSource()[[1]]

# We will select the comments
resenas <- remDr$findElement(using = 'xpath', 
                             '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[3]/div[2]/div[2]/ul/li[1]/a/span/span[2]')

# And click on those
resenas$clickElement()

# Let's check it out
remDr$screenshot(display = TRUE) 

# We can navigate as if a human was interacting with the site
remDr$goBack()
remDr$screenshot(display = TRUE) 
remDr$goForward()
remDr$screenshot(display = TRUE) 

# Let's get the comments
comments <-xml2::read_html(remDr$getPageSource()[[1]]) %>%
  html_nodes(xpath = '//*[@id="main"]/section/div[2]/div[2]') %>% html_text()
comments

# Let's switch Amazon now
remDr$navigate("https://www.amazon.es/")
remDr$screenshot(display = TRUE) 

# We will select the search box
input <- remDr$findElement(using = 'css selector', "#twotabsearchtextbox")

# And do a targeted search
input$sendKeysToElement(list("Laptop Computer"))
btn <- remDr$findElement(using = 'css selector',"#nav-search-submit-button")
btn$clickElement() # Click on search

# See the outcome
remDr$screenshot(display = TRUE)

# We can check those elements via crawler to track if they change prices, for example
pagina<-remDr$getCurrentUrl()[[1]][1]%>% read_html()

# Let's close the connection
remDr$close() 
server$stop()
