# -*- coding: utf-8 -*-
"""
Created on Mon May  4 06:04:17 2020

@author: camil
"""


import pandas as pd
import matplotlib.pyplot as plt
from pyod.models.knn import KNN

iris = pd.read_csv('iris.csv')
plt.boxplot(iris.iloc[:,1])
plt.boxplot(iris.iloc[:,1], showfliers = False) #does not show the outliers
outliers = iris[(iris['sepal.width'] > 4.0) | (iris['sepal.width'] < 2.1)]
outliers
#Python Outlier Detection (PYOD) - KNN Method

sepal_width = iris.iloc[:,1].values
sepal_width = sepal_width.reshape(-1,1)
detector_outlier = KNN()
detector_outlier.fit(sepal_width)
predictions = detector_outlier.labels_
predictions
