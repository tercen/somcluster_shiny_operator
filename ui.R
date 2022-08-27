library(shiny)
library(shinyjs)

ui <- shinyUI(
  fluidPage(
    shinyjs::useShinyjs(),
    tags$script(HTML('setInterval(function(){ $("#hiddenButton").click(); }, 1000*30);')),
    tags$footer(shinyjs::hidden(actionButton(inputId = "hiddenButton", label = "hidden"))),
    
    titlePanel("SOM"),
    
    sidebarPanel(
      numericInput("xgrid", "X grid dimension", min = 1, step = 1, value = 2),
      numericInput("ygrid", "Y grid dimension", min = 1, step = 1, value = 2),
      selectInput("topo", "Grid type", choices = c("rectangular", "hexagonal"), selected = 1),
      actionButton("done", "Return clusters to Tercen")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Variables",
                 plotOutput("vars")
        ),
        tabPanel("Observation mapping",
                 plotOutput("map")
        ),
        tabPanel("Clusters",
                 plotOutput("clusters")
        )
      )
    )
  )
)
