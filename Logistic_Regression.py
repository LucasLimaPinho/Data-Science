# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import LogisticRegression


database = pd.read_csv('Eleicao.csv', sep = ";")
plt.scatter(database.DESPESAS, database.SITUACAO)
database.describe()
np.corrcoef(database.DESPESAS, database.SITUACAO) # strong positive correlation


x = database.iloc[:, 2].values
x = x[:, np.newaxis]
y = database.iloc[:, 1].values

model_logistic = LogisticRegression()
model_logistic.fit(x,y)
model_logistic.coef_
model_logistic.intercept_
plt.scatter(x,y)


x_test = np.linspace(10, 3000, 100)
def model(x):
    return 1/(1+np.exp(-x)) #return sigmoid function

result = model(x_test * model_logistic.coef_ + model_logistic.intercept_).ravel()
plt.plot(x_test, result, color = 'red')

predictions = pd.read_csv('NovosCandidatos.csv', sep = ";")
expanses= predictions.iloc[:,1].values
expanses = expanses.reshape(-1,1)
predictions_test = model_logistic.predict(expanses)
predictions = np.column_stack((predictions, predictions_test))
