from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.neighbors import KNeighborsClassifier
from sklearn import datasets
from scipy import stats

iris = datasets.load_iris()
stats.describe(iris.data)
classe = iris.target
previsores = iris.data
x_training, x_test, y_training, y_test = train_test_split(previsores,
                                                          classe,
                                                          test_size=0.3,
                                                          random_state=0)

KNN = KNeighborsClassifier(n_neighbors = 3)
KNN.fit(x_training, y_training)
predictions = KNN.predict(x_test)

# Testing the KNearestNeighbor algorithm.

confusion = confusion_matrix(y_test, predictions)
taxa_acerto = accuracy_score(y_test, predictions)
taxa_erro = 1-taxa_acerto

# It got right 98% of the cases
# Wrong classification in 2% of the cases