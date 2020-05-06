from sklearn import datasets
from sklearn.model_selection import train_test_split
from yellowbrick.classifier import ConfusionMatrix
from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.utils import np_utils
from keras.utils.vis_utils import plot_model
import numpy as np
from sklearn.metrics import confusion_matrix
from keras.datasets import mnist
import matplotlib.pyplot as plt

#####PREPROCESSING

(x_training, y_training), (x_test,y_test) = mnist.load_data()
plt.imshow(x_training[1])
#x_training.shape[1:] -> for a shape equals to (60000,28,28), it will
# give us back (,28,28).
# When we use np.prod, we will come up with 28*28 = 784.

x_training = x_training.reshape((len(x_training), np.prod(x_training.shape[1:])))
x_test = x_test.reshape((len(x_test), np.prod(x_test.shape[1:])))
x_training = x_training.astype('float32')
x_test = x_test.astype('float32')
#Normalization of training data.
x_training = x_training/255 #between 0 and 1

#Without normalization, results are going to be poor.
#Keras -> important to make normalization.
#Normalization is also important to reduce the time of training

x_test = x_test/255
y_training = np_utils.to_categorical(y_training, 10)
# 10 equals the parameter 'number of classes'. We are dealing with images
# from numbers 0 to 9 -> so number of classes equals 10.
y_test = np_utils.to_categorical(y_test, 10)
# We need to do this because we are going to have 10 neurons in the output layer

##############MODELLING

modelo = Sequential() #Sequential -> we are going to add the layers manually
# Using Dense we guarantee that the layer is going to be connected to all neurons
# Dropout -> avoid overfitting. The parameter that we give to Dropout is a
# percentage of values that will not go ahead in the neural network. 
# Dropout is going to give value 0 for those neurons that are not going
# to be activated during training. 
# input_dim only in the first layer
modelo.add(Dense(units = 64, activation = 'relu', input_dim=784))
modelo.add(Dropout(0.2))
modelo.add(Dense(units = 64, activation = 'relu'))
modelo.add(Dropout(0.2))
modelo.add(Dense(units = 64, activation = 'relu'))
modelo.add(Dropout(0.2))
modelo.add(Dense(units = 10, activation = 'softmax')) #output layer
modelo.summary()

# loss = categorical_crossentropy -> classification model with more then 2 classes

modelo.compile(optimizer = 'adam', loss = 'categorical_crossentropy',
               metrics = ['accuracy'])
historico = modelo.fit(x_training, y_training, epochs = 20,
           validation_data = (x_test, y_test))
plt.plot(historico.history['val_loss'])
plt.plot(historico.history['val_accuracy'])
predictions = modelo.predict(x_test)
y_test_matrix = [np.argmax(t) for t in y_test]
predictions_matrix = [np.argmax(t) for t in predictions]
confusion = confusion_matrix(y_test_matrix, predictions_matrix)
