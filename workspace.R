source("ui.R")
source("server.R")

options("tercen.workflowId"= "88d0de31468a3f46080a3d475200b1fb")
options("tercen.stepId"= "bd2af8e8-d465-4543-89f9-40c547840618")

runApp(shinyApp(ui, server))  
