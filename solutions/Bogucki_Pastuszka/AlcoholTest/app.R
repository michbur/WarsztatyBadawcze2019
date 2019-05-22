#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(FFTrees)
data(wine)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
      numericInput(inputId ="fixed.acidity", label = "fixed.acidity", value = 0),
      numericInput(inputId="volatile.acidity", label = "volatile.acidity", value = 0),
      numericInput(inputId="citric.acid", label = "citric.acid", value = 0),
      numericInput(inputId="residual.sugar", label = "residual.sugar", value = 0),
      numericInput(inputId="chlorides", label = "chlorides", value = 0),
      numericInput(inputId="free.sulfur.dioxide", label = "free.sulfur.dioxide", value = 0),
      numericInput(inputId="total.sulfur.dioxide", label = "total.sulfur.dioxide", value = 0),
      numericInput(inputId="density", label = "density", value = 0),
      numericInput(inputId="pH", label = "pH", value = 0),
      numericInput(inputId="sulphates", label = "sulphates", value = 0),
      numericInput(inputId="alcohol", label = "alcohol", value = 0),
      selectInput(inputId="type",label = "type",choices = c("red", "white"))),
      
      # Show a plot of the generated distribution
      mainPanel(
         textOutput("wynik")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    load(file = "model.RData")
  
  row_r <- reactive({lapply(setdiff(colnames(wine), c("quality")), function(i) input[[i]])})
   
   output$wynik <- renderText({
     
     out <- predict(model, newdata = as.data.frame(row_r(), col.names = setdiff(colnames(wine), c("quality"))))
     ifelse(as.character(out$data$response)=="1","Dooobre wino","Zle wino") 
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

