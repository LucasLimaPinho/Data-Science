from sklearn import datasets
from sklearn.metrics import confusion_matrix
import numpy as np

#For Windows users in Anaconda Prompt -> pip install pyclustering
from pyclustering.cluster.kmedoids import kmedoids
from pyclustering.cluster import cluster_visualizer

iris = datasets.load_iris()


cluster = kmedoids(iris.data[:,0:2], [3,12,20]) 


# Only using the first 02 attributes - does not catch upper bound
# [3, 12, 20] -> alleatory index that establishes the points where the algortihm
# starts looking for medoids. A lot of tests were made and the results
# were very close to other values (initial_index_medoids -> initialization)



cluster.get_medoids() #medoids obtained from the algortihm -> real data.
cluster.process() #really make the processing and executing the training
cluster.get_medoids() #after processing, the value of medoids are changed.
previsoes = cluster.get_clusters() #previsoes will give us the index from 
# all the instancies that were assigned to each one of the 3 groups of 
# clustering
medoides = cluster.get_medoids()


v = cluster_visualizer()
v.append_clusters(previsoes,iris.data[:,0:2])
v.append_cluster(medoides, data= iris.data[:,0:2], marker = '*',
                 markersize=15)
v.show()

lista_previsoes = []

lista_real = []

for i in range(len(previsoes)):
    print('------')
    print(i)
    print('-------')
    for j in range(len(previsoes[i])):
        print(previsoes[i][j])
        lista_previsoes.append(i)
        lista_real.append(iris.target[previsoes[i][j]])
