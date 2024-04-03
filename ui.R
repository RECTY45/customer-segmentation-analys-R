# Mengimpor pustaka 
library(shinydashboard)
library(rsconnect)
library(dplyr)
library(ggplot2)
library(tidyr)
library(shiny)
library(plotly)
library(shinyWidgets)
library(shiny)
library(plotly)
library(cluster)
library(stats)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = img(src="icon.jpg", height = '53',widht='100',align='right'),titleWidth = 200),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Location", tabName = "locations", icon = icon("map-marker")),
      menuItem("Time", tabName = "time", icon = icon("clock")),
      menuItem("SalesOverview", tabName = "salesoverview", icon = icon("bar-chart")),
      menuItem("Gender", tabName = "gender", icon = icon("venus-mars")),
      menuItem("Membership", tabName = "membership", icon = icon("users")),
      menuItem("Rating", tabName = "rating", icon = icon("star")),
      menuItem("Clustering", tabName = "clustering", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      # Dashboard Tab
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Welcome To Costumer Segmentation",
                    width = 12)
              )
      ),
      # Location Tab
      tabItem(tabName = "locations",
              fluidRow(
                box(plotOutput("location"), width = 12)
              )
      ),
      # Time Tab
      tabItem(tabName = "time",
              fluidRow(
                sidebarPanel(
                  radioButtons("time", label = h3("Sales by time"),
                               choices = list("Weekdays" = 1, "Daily hours" = 2), 
                               selected = 1)
                ),
                mainPanel(
                  plotOutput("time")
                )
              )
      ),
      # Sales Overview Tab
      tabItem(tabName = "salesoverview",
              fluidRow(
                sidebarPanel(
                  selectInput("salesoverview", label = h3("Total sales per gender"),
                              choices = list('Total sales per gender' = 1, 'Total sales per type of product' = 2, "Total sales per credit rating" = 3, 'Total sales per membership' = 4),
                              selected = 1)
                ),
                mainPanel(
                  plotOutput("salesoverview")
                )
              )
      ),
      # Gender Tab
      tabItem(tabName = "gender",
              fluidRow(
                sidebarPanel(
                  selectInput("gender", label = h3("Gender"),
                              choices = list('Type of product' = 1, 'Membership' = 2),
                              selected = 1)
                ),
                mainPanel(
                  plotOutput("gender")
                )
              )
      ),
      # Membership Tab
      tabItem(tabName = "membership",
              fluidRow(
                box(plotOutput("membership"), width = 12)
              )
      ),
      # Rating Tab
      tabItem(tabName = "rating",
              fluidRow(
                box(plotOutput("rating"), width = 12)
              )
      ),
      
            # Clustering Tab
      tabItem(tabName = "clustering",
              fluidRow(
                sidebarPanel(
                  numericInput("clusters", "Number of clusters:", 3, min = 1, max = 10)
                ),
                mainPanel(
                  plotOutput("cluster_plot")
                )
              )
      )
      
    )
  )
)
