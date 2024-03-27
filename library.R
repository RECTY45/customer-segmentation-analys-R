# Mengimpor pustaka 
library(shinydashboard)
library(rsconnect)
library(dplyr)
library(ggplot2)
library(tidyr)
library(shiny)
library(plotly)
library(shinyWidgets)
library(RColorBrewer)

# Mengatur direktori kerja 

setwd("C:/laragon/www/COSTUMER-SEGMENTATION-ANALYS-R/Customer-Segmentation")
df <- read.csv('supermarket_sales.csv')

# Ubah nama kolom menjadi nama yang lebih memadai dan buat nama kolom dengan huruf kecil
headers <- tolower(colnames(df))
headers[1] = 'id'
headers[6] = 'product.type'
headers[10] = 'spending'
headers[9] = 'tax'
headers[14] = 'cost'
colnames(df) = headers
