# server.R
# Palette colors
brighter_palette <- c("#FFCCCC", "#FFE6CC", "#FFF7CC", "#F0FFCC", "#CCFFFF", "#CCD8FF", "#FFCCF2", "#FFCCB2", "#FFFFCC", "#D8F1FF")
server <- function(input, output, session){
  
  clusters <- reactive({
    kmeans(df$rating, centers = input$clusters)
  })

     observe({
     
    #--- location ---------------------------------------------------------------------------------------------------    
  
       output$location <- renderPlot({
      df %>%
        group_by(city) %>%
        ggplot(aes(x = city, y = spending)) +
        geom_bar(stat = "identity", aes(fill = city)) +  # Gunakan city sebagai variabel fill
        labs(x = "", y = "Total Sales", title = "Sales Per City",  face = "bold") +  # Update label sumbu dan judul
        scale_fill_manual(values = brighter_palette) +  # Gunakan palet warna yang telah ditentukan
        theme_light() +  # Ubah tema menjadi tema light
        theme(axis.text = element_text(size = 20),  # Ubah ukuran teks sumbu
              axis.title = element_text(size = 25),  # Pertebal judul sumbu x dan y
              plot.title = element_text(size = 25, hjust = 0.5, face = "bold"))  # Pertebal judul plot
    })
    
    #--- Time ----------------------------------------------------------------------------------------------------- 
 
          output$time <- renderPlot({
      
      if (input$time == 1) 
        {
        df %>%
          mutate(date = as.Date(date, format = "%m/%d/%y"),
                 day = weekdays(date)) %>%
          group_by(day) %>%
          summarize(sales = mean(spending)) %>%
          arrange(match(day, c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))) %>%
          ggplot(aes(x = factor(day, levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')), y = sales)) +
          geom_point(color = 'darkblue', size = 3) +  # Menggunakan geom_point() untuk menunjukkan rata-rata penjualan per hari
          ylab('Total sales') +
          xlab('Weekdays') +
          ggtitle('Average sales per weekday') +
          theme_minimal() + 
          theme(axis.text=element_text(size=20),
                axis.title=element_text(size=20),
                axis.title.x = element_blank(),
                plot.title = element_text(size = 20)) +
          theme(plot.title = element_text(hjust = 0.5))  
      } else {
        df %>%
          reframe(spending, time.intervals = ifelse(time < 11, 10, ifelse((time >= 11 & time < 12), 11, ifelse((time >=12 & time < 13),12, ifelse((time >= 13 & time < 14),13,ifelse((time >= 14 & time < 15),14,ifelse((time >= 15 & time < 16), 15, ifelse((time >= 16 & time < 17),16,ifelse((time >= 16 & time < 17),16,ifelse((time >= 17 & time < 18), 17,ifelse((time >= 18 & time < 19), 18,ifelse((time >= 19 & time <20),19,20)))))))))))) %>% 
          group_by(time.intervals) %>% 
          reframe(time.intervals, sales = mean(spending)) %>% 
          distinct(.,time.intervals,sales) %>%
          ggplot(aes(x = time.intervals, y = sales)) +
          geom_line(stat = 'identity', color = 'darkblue') +
          theme_minimal() +  
          ylab('Total sales') +
          xlab('Daily hours') +
          ggtitle('Average sales per hour') +
          theme(axis.text=element_text(size=20),
                axis.title=element_text(size=20),
                plot.title = element_text(size = 20)) +
          theme(plot.title = element_text(hjust = 0.5))
      }
      
    })
          
    #--- Sales overview ----------------------------------------------------------------------------------------------------- 
   
            output$salesoverview <- renderPlot({
       
      if (input$salesoverview == 1)
        {
        df %>% 
          group_by(gender) %>% 
          summarise(unit.price = mean(unit.price), 
                    quantity = mean(quantity), 
                    spending = sum(spending)) %>% 
          distinct(gender, quantity, unit.price, spending) %>% 
          ggplot(aes(x = gender, y = spending)) +
          geom_bar(aes(fill = gender), stat = 'identity', width = 0.35) +
          ylab('Total sales') +
          xlab('Gender') + 
          ggtitle('Total sales per gender') +
          theme_minimal() +
          theme(axis.text=element_text(size=20),
                axis.title=element_text(size=20),
                plot.title = element_text(size = 20)) +
          theme(plot.title = element_text(hjust = 0.5)) +
          theme(legend.position = "none") 
      } else if(input$salesoverview == 2){
        df %>%
          group_by(product.type) %>%
          summarise(spending = sum(spending)) %>% 
          distinct(product.type, spending) %>%
          mutate_if(is.numeric, round) %>% 
          ggplot(aes(y = product.type, x = spending, label = spending)) +
          theme_minimal() +
          geom_segment(aes(x = 0, y = product.type, xend = spending, yend = product.type), color = 'darkblue') +
          geom_point(size = 20, color = 'darkblue') + 
          geom_text(color = 'white', size = 3.5) +
          ylab('Type of product') +
          xlab('Total sales') +
          ggtitle('Total sales per type of product') +
          theme_minimal() +
          theme(axis.text=element_text(size=20),
                axis.title=element_text(size=20),
                plot.title = element_text(size = 20)) +
          theme(plot.title = element_text(hjust = 0.5))
      } else if (input$salesoverview == 3){
        df %>%
          group_by(rating) %>%
          summarise(spending = mean(spending)) %>%
          distinct(rating, spending) %>%
          ggplot(aes(x = rating, y = spending)) +
          theme_minimal() +
          geom_point(color = 'darkblue') +
          geom_smooth(method = 'lm', formula = y ~ x) +  # Specify the formula here
          ylab('Total sales') +
          xlab('Rating') +
          ggtitle('Correlation between total sales and rating') +
          theme(axis.text=element_text(size=20),
                axis.title=element_text(size=20),
                plot.title = element_text(size = 20)) +
          theme(plot.title = element_text(hjust = 0.5))
        
      } else {
        df %>%
          ggplot(aes(x = customer.type, y = spending)) +
          theme_minimal() +
          geom_boxplot(color = 'darkblue') +
          ylab('Total Sales') +
          xlab('Membership') +
          ggtitle('Total sales per membership') +
          theme(axis.text=element_text(size=20),
                axis.title=element_text(size=20),
                plot.title = element_text(size = 20)) +
          theme(plot.title = element_text(hjust = 0.5))
      }
       
    })
     #--- Gender ----------------------------------------------------------------------------------------------------- 
     output$gender <- renderPlot({
       if (input$gender == 1)
         {
         df %>%
           group_by(gender, product.type) %>%
           summarise(spending = sum(spending), .groups = 'drop') %>% 
           distinct(product.type, spending, gender) %>%
           mutate(across(where(is.numeric), round), .groups = 'drop') %>% 
           ggplot(aes(y = product.type, x = spending, label = spending, color = gender)) +
           theme_minimal() +
           geom_segment(aes(x = 0, y = product.type, xend = spending, yend = product.type)) +
           geom_point(size = 20) + 
           geom_text(color = 'white', size = 3.5) +
           ylab('Type of product') +
           xlab('Total sales') +
           ggtitle('Total sales per type of product and gender') +
           theme(axis.text=element_text(size=20),
                 axis.title=element_text(size=20),
                 plot.title = element_text(size = 20)) + 
           theme(plot.title = element_text(hjust = 0.5))
       } else {
         df %>% 
           group_by(gender, customer.type) %>%
           summarise(spending = sum(spending), .groups = 'drop') %>%
           ggplot(aes(x = customer.type, y = spending)) +
           theme_minimal() +
           geom_bar(stat = 'identity', position = 'dodge', aes(fill = gender)) +
           xlab('Membership') +
           ylab('Total sales') +
           ggtitle('Membership by gender') +
           theme(axis.text=element_text(size=20),
                 axis.title=element_text(size=20),
                 plot.title = element_text(size = 20)) +
           theme(plot.title = element_text(hjust = 0.5))
       }
     })
     
     #--- Membership ----------------------------------------------------------------------------------------------------- 
     output$membership <- renderPlot({
       df %>%
         group_by(customer.type, product.type) %>%
         summarise(spending = sum(spending), .groups = 'drop') %>% 
         distinct(product.type, spending, customer.type) %>%
         mutate(across(where(is.numeric), round), .groups = 'drop') %>% 
         ggplot(aes(y = product.type, x = spending, label = spending, color = customer.type)) +
         theme_minimal() +
         geom_segment(aes(x = 0, y = product.type, xend = spending, yend = product.type)) +
         geom_point(size = 20) + 
         geom_text(color = 'white', size = 3.5) +
         ylab('Type of product') +
         xlab('Total sales') +
         ggtitle('Total sales per type of product and membership') +
         theme(axis.text=element_text(size=20),
               axis.title=element_text(size=20),
               plot.title = element_text(size = 20)) +
         theme(plot.title = element_text(hjust = 0.5))
     })
     
    #--- Rating -----------------------------------------------------------------------------------------------------
     
     output$rating <- renderPlot({
       ggplot(df, aes(x = customer.type, y = rating)) +
         geom_boxplot(color = 'darkblue') +
         labs(
           y = 'Rating',
           x = 'Membership',
           title = 'Membership by rating'
         ) +
         theme_minimal() +
         theme(
           axis.text = element_text(size = 20),
           axis.title = element_text(size = 20),
           plot.title = element_text(size = 20, hjust = 0.5)
         )
     })
     
     #--- Clustering -----------------------------------------------------------------------------------------------------
     output$cluster_plot <- renderPlot({
       plot(df$rating, col = clusters()$cluster, main = "K-means Clustering")
       points(clusters()$centers, col = 1:input$clusters, pch = 8, cex = 2)
     })
     
  })
  }