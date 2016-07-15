library(lubridate)
library(ggplot2)

shinyServer(function(input, output) {
  
  temperature <- reactive({
    inFile <- input$upload
    
    if(is.null(inFile))
      return (NULL)
    
    ### Loading the anomaly detection data
    temperatures <- read.csv(inFile$datapath, header = TRUE)
    
    temperatures$Date <- dmy(temperatures$Date)
    temperatures
    
  })
  
  # 
  # ggplot(temperatures, aes(x = Date, y = Pump.Temp)) + geom_point()
  # ggplot(temperatures, aes(x = Time, y = Pump.Temp)) + geom_point()
  ## Visually we can find the outliers that are according to the day and 
  ## according to the hour
  
  ### Need to get the variation
  ### Model should fit on the historical model
  
  ### Using Exponential Weighted Averages
  ## y(pred) = lambda * y(t-avg) + (1- lambda) * y(t-1)
  
  ## First need to calculate y(tavg)
  y.tavg <- reactive({mean(temperature()$Pump.Temp)})
  
  ## Need to fix a lambda for the values
  lambda <- reactive({input$lambda})
  
  #Just for testing
  # Need to 
  # output$value <- renderPrint({lambda()})
  
  ### To find the value of last t
  # t <- seq(1:nrow(temperatures))
  
  ## Variable for y(pred)
  ypred <- function()({
    y.pred <- c()
    for (j in seq(1:nrow(temperature()))){
      y.pred[j] <- ({lambda() * y.tavg() + (1 - lambda()) * temperature()$Pump.Temp[j+1]})
    }
    
    return (y.pred)
  })
  
  # output$myTable <- DT::renderDataTable({DT::datatable(ypred())})
  
  LCL <- reactive({mean(ypred(), na.rm = TRUE) - 2*sd(ypred(), na.rm = TRUE)})
  UCL <- reactive({mean(ypred(), na.rm = TRUE) + 2*sd(ypred(), na.rm = TRUE)})
  
  #To update the values of UCL and LCL
  output$UCL <- renderText({UCL()})
  output$LCL <- renderText({LCL()})
  
  output$plot <- renderPlot({plot(temperature()$Pump.Temp)
  lines(ypred(), col = "red")
  abline(h = LCL(), col = "blue")
  abline(h = UCL(), col ="black")
  legend("bottomright", c("Predicted", "UCL", "LCL"), lty = c(1,1), lwd = c(2.5,2.5,2.5), col = c("red","blue","black"))
  })

}
)

### Reactive programming
## ***** If you use reactive elements in an equation, the resulting storage
## should be reactive element as well