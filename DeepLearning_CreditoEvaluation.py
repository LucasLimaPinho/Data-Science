import pandas as pd
from sklearn.preprocessing import LabelEncoder,OneHotEncoder
from sklearn.compose import make_column_transformer
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from keras.models import Sequential
from keras.layers import Dense, Dropout
from sklearn.metrics import confusion_matrix, accuracy_score

dataset = pd.read_csv('Credit2.csv', sep=";")
X = dataset.iloc[:,1:10].values
Y = dataset.iloc[:,10].values
#KERAS waits for arrays!
labelencoder = LabelEncoder()
X[:,0] = labelencoder.fit_transform(X[:,0])
onehotencoder = make_column_transformer((OneHotEncoder(categories='auto',
                                                       sparse=False),
                                                       [1]),remainder='passthrough')
X = onehotencoder.fit_transform(X)
#DUMMY VARIABLE TRAP -> high correlations between atributes. Aim to reduce the
# number of atributes.

X = X[:,1:]

# Categorical Encoding for y

labelencoder_02 = LabelEncoder()
Y = labelencoder_02.fit_transform(Y)

#FEATURE SCALLING - Standardization with Z_score.
x_training, x_test, y_training, y_test = train_test_split(X,
                                                          Y,
                                                          test_size = 0.2,
                                                          random_state =0)
sc = StandardScaler()
x_training = sc.fit_transform(x_training)
x_test = sc.fit_transform(x_test)

# All data centered around mean = 0, standard deviation =1.

modelo = Sequential()
modelo.add(Dense(units = 6, kernel_initializer = 'uniform', 
                 activation ='relu',
           input_dim=12))
modelo.add(Dense(units = 6, kernel_initializer = 'uniform', 
                 activation ='relu'))
modelo.add(Dense(units = 6, kernel_initializer = 'uniform', 
                 activation ='relu'))
modelo.add(Dense(units = 1, kernel_initializer = 'uniform', 
                 activation ='sigmoid'))

modelo.compile(optimizer = 'adam', loss = 'binary_crossentropy',
               metrics = ['accuracy'])
modelo.fit(x_training,y_training, batch_size=10, epochs=100)

Y_pred = modelo.predict(x_test)
# Sigmoid as activation function of the output layer gives us results
# in terms of probability. We need to transform that probabilities in
# actual classification if is a good payer or not.

Y_pred = (Y_pred > 0.5)
confusion = confusion_matrix(y_test, Y_pred)
taxa_acerto = accuracy_score(y_test, Y_pred)
