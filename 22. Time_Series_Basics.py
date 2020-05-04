# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import LogisticRegression
from datetime import datetime

base = pd.read_csv('AirPassengers.csv') 

#It is necessary to transform the column "Month" to a data type

print(base.dtypes) #now column Month is a object

dateparse = lambda dates: pd.datetime.strptime(dates, '%Y-%m')

base = pd.read_csv('AirPassengers.csv', parse_dates = ['Month'],
                   index_col = 'Month', date_parser = dateparse)

print(base.dtypes)
base.index #Times Series -> the index needs to be the time

ts = base['#Passengers'] #DataType = series
ts[1]
ts[0]
ts['1949-02-1']
ts['1960-12-1']
ts[datetime(1949,2,1)]
datetime(1949,2,1)
ts['1950-01-01':'1950-07-01']
ts[:'1950-07-31']
ts['1950']
ts.index.max()
ts.index.min()


plt.plot(ts) #plotting the time series

ts_year = ts.resample('A').sum() #aggregating by year
plt.plot(ts_year)
ts_month = ts.groupby([lambda x: x.month]).sum() #aggregating by month
ts_month
plt.plot(ts_month)

ts_datas = ts['1960-01-01' : '1960-12-01']
plt.plot(ts_datas)
ts_datas
