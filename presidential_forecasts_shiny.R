## Let's build our own (This is due next Tuesday as a problem set)

#1 ) 
#### As our first step, we are going to make a UI that does nothing.  We are going to say:

# Presidential Forecasts

# Here are the results of presidential forecasts from 1952-2008
# (this should be in a lower font)

#2)
## As our second step, we are going to follow example 2 above and have it show the last X elections (as selected by the user)

#3) Now we are going to have it plot the election results 

# https://shiny.rstudio.com/reference/shiny/1.0.2/plotOutput.html

# 4) Now we are going to add a line to add a dropdown window to add a specific forecast to the plot

# 5) Now we are going to make it so it prints out the data points when clicked on

# https://shiny.rstudio.com/articles/plot-interaction.html


install.packages("EBMAforecast")


# Load EBMA forecast library
# Pull data and display it
# output$view = 'dataset name'
# plot election results, one of the columns is called actual, incumbent party's 2-party vote share
# want to plot actual election outcomes
# show predicted outcomes from one of the forecasting teams' forecasts
##

library(shiny)
# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Presidential Forecasts"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Numeric entry for number of obs to view ----
      numericInput(inputId = "obs",
                   label = "Number of elections to display:",
                   value = 15),
      
      # Input: Selector for choosing comparison predictor to plot against ----
      selectInput(inputId = "predictor",
                  label = "Choose a predictor for comparison:",
                  choices = c("Campbell", "Lewis-Beck", "EWT2C2", "Fair", "Hibbs", "Abramowitz")),
    
      # Include clarifying text ----
      helpText("Here are the results from presidential forecasts from 1952-2008")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      tableOutput("view"),
      plotOutput("plot", click = "plot_click"), verbatimTextOutput("info")
      )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  library("EBMAforecast")
  data("presidentialForecast")
  output$view <- renderTable({presidentialForecast})
  
  # Return the requested dataset ----
  datasetInput <- reactive({presidentialForecast})
  
  # Show the first "n" observations ----
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
  # Return the requested dataset ----
  forecast <- reactive({
    switch(input$predictor,
           "Campbell" = presidentialForecast$Campbell,
           "Lewis-Beck" = presidentialForecast$`Lewis-Beck`,
           "EWT2C2" = presidentialForecast$EWT2C2,
           "Fair" = presidentialForecast$Fair,
           "Hibbs" = presidentialForecast$Hibbs,
           "Abramowitz" = presidentialForecast$Abramowitz)
  })
  
  # Plot actual observations
  output$plot <- renderPlot({
    input$newplot
    plot(x=1:15, y=presidentialForecast$Actual, main="Actual & Predicted Election Results from 1952-2008",
        xlab="Indexed election year from 1952-2008 (1 ~ 1952, 15 ~ 2008)",
        ylab="Actual two-party vote share of incumbent party", col="red")
    legend(12.5,62, c("Actual","Predictor"),
           lty=c(3,3), col=c("red","black"))
    points(x=1:15, y=forecast())
  })

  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)

