# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import statsmodels.formula.api as sm

base = pd.read_csv('mtcars.csv')
base = base.drop(['model'], axis=1)

x = base.iloc[:,2].values
y = base.iloc[:,0].values
correlacao = np.corrcoef(x,y)
x = x.reshape(-1,1)


model = LinearRegression()
model.fit(x,y)
model.intercept_
model.coef_
model.score(x,y) # R^2 -> determination coefficient. Always positive.

# Other library to acess R^2 adjusted.

predictions = model.predict(x)

adjusted_model = sm.ols(formula = 'mpg ~ disp', data = base)
trained_model = adjusted_model.fit()
trained_model.summary()
plt.scatter(x,y)
plt.plot(x, predictions, color='red')
model.predict(200)
