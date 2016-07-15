### Loading the anomaly detection data
temperatures <- read.csv(file.choose(), header = TRUE)

library(lubridate)

head(temperatures)
temperatures$Date <- dmy(temperatures$Date)

library(ggplot2)

ggplot(temperatures, aes(x = Date, y = Pump.Temp)) + geom_point()
ggplot(temperatures, aes(x = Time, y = Pump.Temp)) + geom_point()
## Visually we can find the outliers that are according to the day and 
## according to the hour

### Need to get the variation
### Model should fit on the historical model

### Using Exponential Weighted Averages
## y(pred) = lambda * y(t-avg) + (1- lambda) * y(t-1)

## First need to calculate y(tavg)
y.tavg = mean(temperatures$Pump.Temp)

## Need to fix a lambda for the values
lambda <- seq(from = 0, to = 1, by = 0.1)

### To find the value of last t
t <- seq(1:nrow(temperatures))

## Variable for y(pred)
y.pred <- c()

lambda <- 0.3

for (j in seq(1:nrow(temperatures))){
    y.pred[j] <- lambda * y.tavg + (1 - lambda) * temperatures$Pump.Temp[j+1]
}

y.pred

LCL <- mean(y.pred, na.rm = TRUE) - 2*sd(y.pred, na.rm = TRUE)
UCL <- mean(y.pred, na.rm = TRUE) + 2*sd(y.pred, na.rm = TRUE)
 
plot(temperatures$Pump.Temp)
lines(y.pred, col = "red")
abline(h = LCL, col = "blue")
abline(h = UCL, col ="blue")
