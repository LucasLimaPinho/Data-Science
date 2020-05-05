from sklearn import datasets
import numpy as np
from sklearn.metrics import confusion_matrix
# In Anaconda prompt -> pip install scikit-fuzzy
import skfuzzy

iris = datasets.load_iris()

# iris.data.T is necessary to transpose the matrix.
# it is necessary for the fuzzy-cmeans algortihm
# c=3 -> number of clusters
# m = 2 -> membership, recommended default in this library
# error = 0.005 -> stop criteria
# maxiter = 10000, max number of iterations
# init = None -> default


r = skfuzzy.cmeans(data = iris.data.T, c=3, m=2, error = 0.005,
                   maxiter = 1000, init = None)

# The most important in this result 'r' is the second line 
# where we can get the probability of each instancie to be part of
# one of the 3 groups (Setosa, Versicolor, Verginica)


previsoes_porcentagem = r[1] #******************Important. Thats what matters.
previsoes_porcentagem[0][0] 
previsoes_porcentagem[1][0] 
previsoes_porcentagem[2][0] 

previsoes = previsoes_porcentagem.argmax(axis = 0) #determines what group the
# instancie belongs based on the max value of probabilities
resultados = confusion_matrix(iris.target, previsoes)
# Erros: 16 instancies. Sucess rate next to 90%

