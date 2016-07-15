library(shiny)

### Creating a UI for the Temperature Outlier Detector
shinyUI(
  
  fluidPage(
    title = "Temperature Controller",
    
    plotOutput("plot"),
    # column(4, verbatimTextOutput("value")),
    
    hr(),
    
    fluidRow(
      column(4,
             h4("Upload the file here"),
             fileInput("upload", "File", multiple = FALSE, width = NULL)),
      column(4, 
             h4("Change the Lambda value here"),
             sliderInput("lambda", label = h3("Lambda"), min = 0, max = 1, value = 0.3)),
      column(4,
             h4("UCL"),
             verbatimTextOutput("UCL"),
             h4("LCL"),
             verbatimTextOutput("LCL"))
    )
  )
)