library(shiny)
library(tercen)
library(tidyverse)
library(kohonen)
library(reshape2)
library(ggsci)

############################################
#### This part should not be modified
getCtx <- function(session) {
  # retreive url query parameters provided by tercen
  query <- parseQueryString(session$clientData$url_search)
  token <- query[["token"]]
  taskId <- query[["taskId"]]
  
  # create a Tercen context object using the token
  ctx <- tercenCtx(taskId = taskId, authToken = token)
  return(ctx)
}
####
############################################

server <- shinyServer(function(input, output, session) {
  
  dataInput <- reactive({
    getValues(session)
  })
  
  mode = reactive({
    getMode(session)
  })
  
  pal = scale_color_jama()

  observe({
    shinyjs::disable("done")
    
    getVarLabels = reactive({
      lab = dataInput() %>%
        acast(.ci ~ .ri, value.var = "lab")
      lab[,1]
    })
    
    getObsColors = reactive({
      clr = dataInput() %>%
        acast(.ri ~.ci, value.var = "clr")
      clr[,1]
    })
    
    X = reactive({
      X  = dataInput() %>%
        acast(.ri ~ .ci, value.var = ".y") 
      colnames(X) = getVarLabels()
      X
    })
    
    dosom = reactive({
      sg = somgrid(xdim = input$xgrid, ydim = input$ygrid, topo = input$topo)
      X() %>%
        som(grid = sg, keep.data = TRUE)
    })
    
    clustern = reactive({
      aSom = dosom()
      cdf = data.frame(.ri = 1:dim(X())[1], cluster = aSom$unit.classif) %>%
        mutate(.ri = .ri-1)
    })
    
    output$vars = renderPlot({
      dosom() %>%
        plot()
    })
    output$map = renderPlot({
      idx = getObsColors() %>%
        as.integer()
      plot_clrs = pal$palette(max(idx))
      dosom() %>%
        plot(type = "map",col = plot_clrs[idx], pch = 16)
    })
    output$clusters = renderPlot({
      prt = dataInput() %>%
        left_join(clustern(), by = ".ri") %>%
        ggplot(aes(x = lab, y = .y, colour = clr, group = .ri))
      prt = prt + geom_line(alpha = 0.2) + scale_colour_jama()
      prt + facet_grid(cluster ~.) + theme_bw()
    })
    
    m = mode()
    if ( !is.null(m) && m == "run") {
      shinyjs::enable("done")
    }
    
    observeEvent(input$done, {
      shinyjs::disable("done")
      msgReactive$msg = "Running ... please wait ..."
      tryCatch({
        dataInput() %>%
          left_join(clustern(), by = ".ri") %>%
          select(.ri, .ci, cluster) %>%
          ctx$addNamespace() %>%
          ctx$save()
          msgReactive$msg = "Done"
      }, error = function(e) {
        msgReactive$msg = paste0("Failed : ", toString(e))
        print(paste0("Failed : ", toString(e)))
      })
    })
  })
})

getValues <- function(session){
  ctx = getCtx(session)
  df = ctx %>%
    select(.y, .ri, .ci)
  
  if(length(ctx$colors)>0){
    df$clr = ctx$select(ctx$colors) %>% interaction()
  } else {
    df = data.frame(df, clr = ".") %>%
      mutate(clr = clr %>%as.factor())
  }
  
  if(length(ctx$labels) == 1){
    df = df %>%
      bind_cols(ctx$select(ctx$labels))
  } else {
    df$lab = df$.ci
  }
  df %>%
    setNames(c(".y", ".ri", ".ci", "clr", "lab"))
}

getMode <- function(session){
  # retreive url query parameters provided by tercen
  query = parseQueryString(session$clientData$url_search)
  return(query[["mode"]])
}