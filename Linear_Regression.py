# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from yellowbrick.regressor import ResidualsPlot

base = pd.read_csv('cars.csv')
base = base.drop(['Unnamed: 0'], axis = 1) #axis = 1 -> erase per collumns

x= base.iloc[:, 1].values
x=x.reshape(-1,1)
y= base.iloc[:, 0].values
correlacao = np.corrcoef(x,y)
model = LinearRegression()
model.fit(x,y)
model.intercept_
model.coef_
plt.scatter(x,y)
plt.plot(x,model.predict(x), color="red")
model.predict(22)
model._residues
visual = ResidualsPlot(model)
visual.fit(x,y)
visual.poof()