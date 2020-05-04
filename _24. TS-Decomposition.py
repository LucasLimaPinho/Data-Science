# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.seasonal import seasonal_decompose

base = pd.read_csv('AirPassengers.csv')
dateparse = lambda dates: pd.datetime.strptime(dates, '%Y-%m')
base = pd.read_csv('AirPassengers.csv', parse_dates = ['Month'],
                   index_col = 'Month', date_parser = dateparse)
ts = base['#Passengers']
ts

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.seasonal import seasonal_decompose

base = pd.read_csv('AirPassengers.csv')
dateparse = lambda dates: pd.datetime.strptime(dates, '%Y-%m')
base = pd.read_csv('AirPassengers.csv', parse_dates = ['Month'],
                   index_col = 'Month', date_parser = dateparse)
ts = base['#Passengers']
ts
plt.plot(ts)
decomposition = seasonal_decompose(ts)
decomposition
trend = decomposition.trend
trend
seasonal = decomposition.seasonal
random = decomposition.resid

plt.plot(trend)
plt.plot(seasonal)
plt.plot(random)
plt.subplot(4,1,1)
plt.plot(ts, label = "Original")
plt.legend(loc = 'best')
plt.subplot(4,1,2)
plt.plot(trend, label = "Trend")
plt.legend(loc = 'best')
plt.subplot(4,1,3)
plt.plot(seasonal, label = "Seasonal")
plt.legend(loc = 'best')
plt.subplot(4,1,4)
plt.plot(random, label = "Random")
plt.legend(loc = 'best')
