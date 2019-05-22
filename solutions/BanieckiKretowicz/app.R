library(shiny)
library(e1071)
load("model2.rdata")
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("fixed.acidity",
                        "fixed.acidity:",
                        min = 0,
                        max = 20,
                        value = 8.4),
            sliderInput("volatile.acidity",
                        "volatile.acidity:",
                        min = 0,
                        max = 1.8,
                        value = 0.67),
            sliderInput("citric.acid",
                        "citric.acid:",
                        min = 0,
                        max = 1.8,
                        value = 0.19),
            sliderInput("residual.sugar",
                        "residual.sugar:",
                        min = 0,
                        max = 70,
                        value = 2.2),
            sliderInput("chlorides",
                        "chlorides:",
                        min = 0,
                        max = 70,
                        value = 0.093),
            sliderInput("free.sulfur.dioxide",
                        "free.sulfur.dioxide:",
                        min = 0,
                        max = 300,
                        value = 11),
            sliderInput("total.sulfur.dioxide",
                        "total.sulfur.dioxide:",
                        min = 0,
                        max = 500,
                        value = 75),
            sliderInput("density",
                        "density:",
                        min = 0.95,
                        max = 1.05,
                        value = 0.99736),
            sliderInput("pH",
                        "pH:",
                        min = 2,
                        max = 5,
                        value = 3.2),
            sliderInput("sulphates",
                        "sulphates:",
                        min = 0,
                        max = 2.1,
                        value = 0.59),
            sliderInput("alcohol",
                        "alcohol:",
                        min = 6,
                        max = 18,
                        value = 0.92)
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            textOutput("prediction")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    
        result <- reactive({
            #browser()
            print(predict(svmModel, data.frame(
                fixed.acidity = input$fixed.acidity,
                volatile.acidity = input$volatile.acidity,
                citric.acid = input$citric.acid,
                residual.sugar = input$residual.sugar,
                chlorides = input$chlorides,
                free.sulfur.dioxide = input$free.sulfur.dioxide,
                total.sulfur.dioxide = input$total.sulfur.dioxide,
                density = input$density,
                pH = input$pH,
                sulphates = input$sulphates,
                alcohol = input$alcohol,
                type = 0)))
            predict(svmModel, data.frame(
                fixed.acidity = input$fixed.acidity,
                volatile.acidity = input$volatile.acidity,
                citric.acid = input$citric.acid,
                residual.sugar = input$residual.sugar,
                chlorides = input$chlorides,
                free.sulfur.dioxide = input$free.sulfur.dioxide,
                total.sulfur.dioxide = input$total.sulfur.dioxide,
                density = input$density,
                pH = input$pH,
                sulphates = input$sulphates,
                alcohol = input$alcohol,
                type = 0
            ))
        })

    output$prediction <- renderText(result()[[1]])
}

# Run the application

shinyApp(ui = ui, server = server)
