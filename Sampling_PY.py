import pandas as pd 
from sklearn.model_selection import train_test_split
import numpy as np 

base = pd.read_csv('iris.csv')
base
base.shape
np.random.seed(2345)
sample = np.random.choice(a = [0, 1], size = 150, replace = True, 
                          p = [0.5, 0.5])

sample
len(sample)
len(sample[sample==1])
len(sample[sample==0])


 
# Stratified Sampling 

iris = pd.read_csv('iris.csv')
iris['variety'].value_counts()



X, _, Y, _ = train_test_split(iris.iloc[:, 0:4], iris.iloc[:, 4],
                              test_size = 0.5, stratify = iris.iloc[:, 4])


Y.value_counts()


infert = pd.read_csv('infert.csv')
infert['education'].value_counts() #Counts the different number of
#registers in terms of education

X1, _, Y1, _ = train_test_split(infert.iloc[:, 2:9], infert.iloc[:,1],
                                test_size = 0.6, stratify = infert.iloc[:, 1])

Y1.value_counts()

# Step by step implementation of systematic sampling

from math import ceil #rounding

pop = 150
sample = 15
aux = ceil(pop/sample) #k need to be rounded because it will be used for 
# sorting

r = np.random.randint(low = 1, high = aux + 1, size = 1)
acumulate = r[0]
sorting = []
for i in range (sample):
   # print(acumulate)
    sorting.append(acumulate)
    acumulate += aux

base = pd.read_csv('iris.csv')

base_final = base.loc[sorting]
base_final




