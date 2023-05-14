# author: Iraitz Montalban
# date: May, 2023

rm(list = ls())
cat("\014")

# UTF-8 as the main encoding
options(encoding = "utf-8")

# Package management
#install.packages("pacman")
library("pacman")

# Tidyverse: https://www.tidyverse.org/
pacman::p_load(tidyverse)

# The main functions we will use for this exercise
#   (1) filter() - Select samples based on their values
#   (2) arrange() - Rearrange
#   (3) select() - Select by column names
#   (4) mutate() - Create new columns based on existing ones
#   (5) summarize() - Combine and summarize results

# Finally this functions can be used in combination with group_by(), so the operation is done
# over subsets of the target dataframe

# Global Club Soccer Rankings:
#   https://projects.fivethirtyeight.com/global-club-soccer-rankings/

# Rvest
pacman::p_load(rvest)

# Get the main table
datos <- "https://projects.fivethirtyeight.com/global-club-soccer-rankings/" %>%
  read_html() %>%
  html_nodes("#all-teams-table") %>% 
  html_table() %>% .[[1]]

# Rename columns with first row
names(datos) <- datos[1,]

# Cleans
datos <- datos %>%
  slice(-1) %>% # Remove header row
  select(rank=1, team=3, league=4, country=5, off=6, def=7, spi=8) %>% #  Select columns
  mutate_at(vars(rank, off:spi), as.numeric) #  Change data types

# Results
str(datos)

# By country
table(datos$country)

# Let's get some statistics: Mean, Std. dev, freq.)
resumen<-datos%>%
  group_by(country)%>%
  dplyr::summarize(spiMedio=mean(spi),
                   spiSd=sd(spi),
                   numeroClubes=n())%>%
  dplyr::mutate(cv=spiSd/spiMedio)

view(resumen)

# We can select specific countries
countries <- c("England","Spain","Italy","Germany")

resumen2<-datos%>%
  group_by(country)%>%
  filter(country %in% countries)%>%
  dplyr::summarize(spiMedio=mean(spi),
                   spiSd=sd(spi),
                   numeroClubes=n())%>%
  dplyr::mutate(cv=spiSd/spiMedio)

view(resumen2)

# See, it takes same efect as
resumen %>%
  filter(country %in% countries)

# Select the top ones
datos %>%
  top_n(-30, rank) %>%
  mutate(team = fct_rev(fct_inorder(team, ordered=TRUE) ) ) %>%
  
  # Here we append the ggplot functionality
  ggplot(aes(team, spi, fill=country)) +
  geom_col() +
  coord_flip() +
  scale_fill_brewer(palette = "Paired") +
  theme_minimal()
  # End plot
