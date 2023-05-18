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
pacman::p_load(xml2) # XML
pacman::p_load(magrittr) 

# Load an XML file
xmlimport <- xml2::read_xml("data/bookstore.xml")
xmlimport

# Find all books
books <- xmlimport %>% xml_find_all("//book")
books

# Titles (nodes)
titles <- xmlimport %>% xml_find_all('/bookstore/book/title')
titles

# Predicates
low_cost <- xmlimport %>% xml_find_all('/bookstore/book[price<30]')
low_cost

# Get the title
xmlimport %>% xml_find_all('/bookstore/book[price<30]/title')

# Select by attributes
web_titles <- xmlimport %>% xml_find_all('//book[@category="WEB"]')
web_titles

# Get XML from remote location
html <- rvest::read_html("https://www.w3schools.com/xml/books.xml")
html

# Get low cost
html %>% xml_find_all('/bookstore/book[price<30]/title')

# Maybe it is not the same structure
html %>% xml_find_all('//bookstore/book[price<30]/title')

bookstore <- html %>% xml_find_all('/html/body')
bookstore

# based on the examples by rvest: https://rvest.tidyverse.org/ 
starwars <- read_html("https://rvest.tidyverse.org/articles/starwars.html")
starwars

# Let's look for section elements inside our XML document
films <- starwars %>% rvest::html_elements("section")
films

# Let's get the titles under h2 nodes
title <- films %>% 
  rvest::html_element("h2") %>% 
  rvest::html_text2()
title

# Directors (by class)
directors <- films %>% 
  rvest::html_element(".director") %>% 
  rvest::html_text2()
directors
