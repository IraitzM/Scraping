# author: Iraitz Montalban
# date: May, 2023

rm(list = ls())
cat("\014")

# UTF-8 as the main encoding
options(encoding = "utf-8")

# Package management
#install.packages("pacman")
library("pacman")

# Install and load jsonlite
pacman::p_load(jsonlite)

# Lets load our object
mario <- fromJSON("http://bit.ly/mario-json")
mario
