# -*- coding: utf-8 -*-
"""
# FORECAST and ARIMA (autoregressive integrated moving average)

"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.arima_model import ARIMA
from pyramid.arima import auto_arima

base = pd.read_csv('AirPassengers.csv')
dataparse = lambda dates: pd.datetime.strptime(dates, '%Y-%m')
base = pd.read_csv('AirPassengers.csv', parse_dates = ['Month'],
                   index_col = 'Month', date_parser = dataparse)
ts =base['#Passengers']
plt.plot(ts)

# mean would only be useful with the series are stationary.
# Like we have a trend component, it's not a realible prediction

# Some might say we can use the data from last year

ts.mean() # = 280
ts['1960-01-01':'1960-12-01'].mean() # = 476

moving_avg = ts.rolling(window=12).mean() #moving average
#window determines the months to be considered
moving_avg
plt.plot(ts)
plt.plot(moving_avg,color='red')



predictions = []

for i in range(1,13):
    superior = len(moving_avg) - i
    inferior = superior - 11
    print(superior)
    print(inferior)
    print('----')
    predictions.append(moving_avg[inferior:superior].mean())
    
predictions = predictions[::-1] #inverting the values in predictions

plt.plot(predictions) #predictions for the next 12 months

# PREDICTIONS USING ARIMA
# 3 parameters for ARIMA
# p -> number of autorregressive terms
# q -> moving average
# d -> number of diff. non-seasonal
model = ARIMA(ts,order =(2,1,2) )
trained_model = model.fit()
trained_model.summary()
predictions = trained_model.forecast(steps = 12)[0]
plt.plot(predictions)
eixo = ts.plot()
trained_model.plot_predict('1960-01-01','1962-01-01',
                           ax = eixo, plot_insample = True)
trained_model.plot_predict('1960-01-01','1962-01-01',
                           ax = eixo, plot_insample = False)

trained_model.plot_predict('1960-01-01','1968-01-01',
                           ax = eixo, plot_insample = True)

trained_model.plot_predict('1960-01-01','1972-01-01',
                           ax = eixo, plot_insample = True)

#using anacond promp -> pip install pyramid-arima (using AUTO ARIMA)
# so we dont need to calculate the parameters p, q, d in ARIMA

modelo_auto = auto_arima(ts, m=12, seasonal = True, trace = True)

modelo_auto.summary()
