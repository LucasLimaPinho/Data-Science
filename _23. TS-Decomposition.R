decompose(AirPassengers)
dec = decompose(AirPassengers)
dec
dec$random
dec$trend
dec$seasonal
plot(dec$seasonal)
plot(dec$trend)
plot(dec$random)
plot(dec)
# is there is a random element, the time series is stochastic

