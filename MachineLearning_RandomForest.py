#RandomForest -

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.ensemble import RandomForestClassifier


credito = pd.read_csv('Credit.csv')
previsores = credito.iloc[:, 0:20].values
classe = credito.iloc[:,20].values

# For RandomForestClassifier, the attributes can't be categorical.
# They need to me transformed in numeric attributes
# LabelEncoder does this for us!
# Choosing all the attributes that are categorical and transforming into
# numeric using labelencoder.fit_transform

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


x_training, x_test, y_training, y_test = train_test_split(previsores,
                                                          classe,
                                                          test_size = 0.3,
                                                          random_state =0)
 
forest = RandomForestClassifier(n_estimators = 100) # Is going to create
# 100 different decision trees. For the classification, will not use the response
# of only one tree. Gets the classification response for 100 decision trees

forest.fit(x_training, y_training) #generates the 100 decision trees
previsoes = forest.predict(x_test)
confusao = confusion_matrix(y_test,previsoes)
taxa_acerto = accuracy_score(y_test, previsoes)
taxa_erro = 1 - taxa_acerto
forest.estimators_ #shows all the trees that were created
forest.estimators_[1]


