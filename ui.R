# Define UI
ui <- dashboardPage(
  dashboardHeader(title = tags$a(tags$img(src="icon.jpg", height = '50', width = '200')), titleWidth = 240),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Lokasi", tabName = "locations", icon = icon("map-marker")),
      menuItem("Waktu", tabName = "time", icon = icon("clock")),
      menuItem("Ringkasan Penjualan", tabName = "salesoverview", icon = icon("bar-chart")),
      menuItem("Gender", tabName = "gender", icon = icon("venus-mars")),
      menuItem("Keanggotaan", tabName = "membership", icon = icon("users")),
      menuItem("Rating", tabName = "rating", icon = icon("star"))
    )
  ),
  dashboardBody(
    tabItems(
      # Dashboard Tab
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Selamat datang di Costumer Segmentation",
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
                  radioButtons("time", label = h3("Penjualan berdasarkan waktu"),
                               choices = list("Hari kerja" = 1, "Jam kerja harian" = 2), 
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
                  selectInput("salesoverview", label = h3("Ringkasan Penjualan"),
                              choices = list('Total sales per gender' = 1, 'Total penjualan per jenis produk' = 2, "Total sales per Kredit rating" = 3, 'Total sales per Keanggotaan' = 4),
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
                              choices = list('Jenis produk' = 1, 'Keanggotaan' = 2),
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
      )
    )
  )
)
