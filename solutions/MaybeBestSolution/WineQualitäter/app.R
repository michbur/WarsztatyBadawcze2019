library(shiny)
library(DT)
library(FFTrees)
library(dplyr)
library(mlr)
library(ranger)

load("model.RData")
#predict(model,newdata=input$wineTable)
ui <- fluidPage(
  titlePanel("Profesjonalny koneser win, który zawsze (w 88% przypadków) mówi prawdę o winie"),
  
  fluidRow(
    dataTableOutput("wineTable"),
    verbatimTextOutput("tekst")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  proxy <- dataTableProxy("wineTable")
  
  observeEvent(input[["wineTable_cell_edit"]], {
    browser()
    info <- input[["wineTable_cell_edit"]]
    i <- info[["row"]]
    j <- info[["col"]]
    v <- info[["value"]]
    wine_full[i, j] <<- DT::coerceValue(v, wine_full[i, j])
    replaceData(proxy, wine_full[71,], resetPaging = FALSE)  # important
  })
  output$wineTable<-renderDataTable(wine_full[1,], editable = TRUE)

  stan<-reactive({
    predict(lrn2,newdata=wine_full[71,])
    
    })
  
  output$tekst<-renderPrint(stan())
}
# Run the application 
shinyApp(ui = ui, server = server)

