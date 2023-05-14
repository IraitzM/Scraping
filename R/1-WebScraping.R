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

# IMDB

# (1) read_html
peliculaLego <- read_html("http://www.imdb.com/title/tt1490017/")

# Selector: 
# - Right click on duration and click inspect
# - From copy options within elements select selector option
duracion<-peliculaLego%>%
  html_nodes('#__next > main > div > section.ipc-page-background.ipc-page-background--base.sc-f9e7f53-0.ifXVtO > section > div:nth-child(4) > section > section > div.sc-385ac629-3.kRUqXl > div.sc-52d569c6-0.kNzJA-D > ul > li:nth-child(3)')%>%
  html_text()
duracion

# Trim white spaces
duracion<-gsub("\\\n","",duracion)
duracion<-trimws(duracion)

# CSS path (copy XPath instead)
rating<-peliculaLego%>%
  html_nodes(xpath='//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/ul/li[2]/a')%>%
  html_text()
rating

# Comments
comentarios <-  peliculaLego %>%
  html_nodes(xpath='//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[3]/div[2]/div[2]/ul/li[1]/a')%>%
  html_attr("href")
comentarios

# It is an extension on the original URL, we would need to navigate there
url2<- paste0("https://www.imdb.com/",comentarios)
pagina<-read_html(url2)

comentarios<-pagina%>%
  html_nodes(".content")%>%
  html_text()

# First comment
comentarios[1]
