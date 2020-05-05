import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import confusion_matrix, accuracy_score

base = pd.read_csv('Credit.csv', sep = ",")

previsores = base.iloc[:, 0:20].values
previsores
classe = base.iloc[:, 20].values
classe

#GaussianNB does not work with categoric data. We need to make a transformation
# Transform categoric attributes into numeric values
previsores[0][0]
labelencoder = LabelEncoder()
previsores[:,0] = labelencoder.fit_transform(previsores[:,0])
previsores[:,2] = labelencoder.fit_transform(previsores[:,2])
previsores[:,3] = labelencoder.fit_transform(previsores[:,3])
previsores[:,5] = labelencoder.fit_transform(previsores[:,5])
previsores[:,6] = labelencoder.fit_transform(previsores[:,6])
previsores[:,8] = labelencoder.fit_transform(previsores[:,8])
previsores[:,9] = labelencoder.fit_transform(previsores[:,9])
previsores[:,11] = labelencoder.fit_transform(previsores[:,11])
previsores[:,13] = labelencoder.fit_transform(previsores[:,13])
previsores[:,14] = labelencoder.fit_transform(previsores[:,14])
previsores[:,16] = labelencoder.fit_transform(previsores[:,16])
previsores[:,18] = labelencoder.fit_transform(previsores[:,18])
previsores[:,19] = labelencoder.fit_transform(previsores[:,19])
previsores[:,0]
previsores[0][0] #after codification with labelencoder because GaussianNB
# cannot work with categoric attributes

previsores[:,0]

X_treinamento, X_teste, Y_treinamento, Y_teste = train_test_split(previsores,
                                                                  classe,
                                                                  test_size=0.3,
                                                                  random_state=0)

naive_bayes = GaussianNB()
naive_bayes.fit(X_treinamento, Y_treinamento)
predictions = naive_bayes.predict(X_teste)

confusao = confusion_matrix(Y_teste,predictions)
taxaacerto = accuracy_score(Y_teste, predictions)
taxa_erro = 1 - taxaacerto

from yellowbrick.classifier import ConfusionMatrix
v = ConfusionMatrix(GaussianNB())
v.fit(X_treinamento, Y_treinamento)
v.score(X_teste, Y_teste)
v.poof()
