# Predictions from Linear Regression Models using AirPassengers DB
#@author: LucasLimaPinho
#AirPassengers is not stationary.
#AirPassengers is stochastic
#AirPassengers contains trend, seasonal and random elements
#We can do extrapolation fitting into a model

#one option to make predictions would be based on the last year
#we can do this by using 'window' function

mean(window(AirPassengers, start=c(1960,1), end=c(1960,12)))

#Other mean: Moving Average -> using forecast package

install.packages("forecast")
library(forecast)
moving_avg = ma(AirPassengers, order=12) #order -> how many months will be considered
moving_avg
plot(moving_avg)
moving_avg = ma(AirPassengers, order=2) #order -> how many months will be considered
moving_avg
moving_avg = ma(AirPassengers, order=12) #order -> how many months will be considered
prediction = forecast(moving_avg,h=12) #making forecast prediction over the 
# next 12 months determined by parameter h
prediction #there is a level of confidence for each prediction
plot(prediction)

## ARIMA: autoregressive integrated moving average

arima = auto.arima(AirPassengers)
arima
prediction_02 = forecast(arima, h=30)
plot(prediction_02)
