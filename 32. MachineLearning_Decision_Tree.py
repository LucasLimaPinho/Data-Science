import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.tree import DecisionTreeClassifier
import graphviz
from sklearn.tree import export_graphviz

credito = pd.read_csv('Credit.csv')
provisores = credito.iloc[:,0:20].values
classe = credito.iloc[:,20].values

labelencoder = LabelEncoder()
provisores[:,0] = labelencoder.fit_transform(provisores[:,0])
provisores[:,2] = labelencoder.fit_transform(provisores[:,2])
provisores[:,3] = labelencoder.fit_transform(provisores[:,3])
provisores[:,5] = labelencoder.fit_transform(provisores[:,5])
provisores[:,6] = labelencoder.fit_transform(provisores[:,6])
provisores[:,8] = labelencoder.fit_transform(provisores[:,8])
provisores[:,9] = labelencoder.fit_transform(provisores[:,9])
provisores[:,11] = labelencoder.fit_transform(provisores[:,11])
provisores[:,13] = labelencoder.fit_transform(provisores[:,13])
provisores[:,14] = labelencoder.fit_transform(provisores[:,14])
provisores[:,16] = labelencoder.fit_transform(provisores[:,16])
provisores[:,18] = labelencoder.fit_transform(provisores[:,18])
provisores[:,19] = labelencoder.fit_transform(provisores[:,19])

X_treinamento, X_teste, Y_treinamento, Y_teste = train_test_split(provisores,
                                                                  classe,
                                                                  test_size=0.3,
                                                                  random_state=0)
provisores[0][0]
tree = DecisionTreeClassifier()
tree.fit(X_treinamento, Y_treinamento)

#pip install graphviz -> view decision tree. Framework for vizualition for graphs

export_graphviz(tree, out_file = 'tree.dot')
# www.webgraphviz.com top generate decision tree

predictions = tree.predict(X_teste)
confusion = confusion_matrix(Y_teste,predictions)
taxa_acerto = accuracy_score(Y_teste, predictions)
taxa_erro = 1 - taxa_acerto
taxa_acerto
taxa_erro
