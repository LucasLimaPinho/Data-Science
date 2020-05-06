#DeepLearning in Python with TensorFlow


# There is a need to install TensorFlow in Anaconda Prompt
# pip install tensorflow
# pip install keras

from sklearn import datasets
from sklearn.model_selection import train_test_split
from yellowbrick.classifier import ConfusionMatrix
from keras.models import Sequential
from keras.layers import Dense
from keras.utils import np_utils
from keras.utils.vis_utils import plot_model
import numpy as np
from sklearn.metrics import confusion_matrix

base = datasets.load_iris()
previsores = base.data
classe = base.target
# Classification problem with more then 2 possible results (3 in this case)
# we need to transform 'classe'. We have 03 perceptrons in the output layer
classe_dummy = np_utils.to_categorical(classe)

# Creating the data for training and test
x_training, x_test, y_training, y_test = train_test_split(previsores,
                                                          classe_dummy,
                                                          test_size=0.3,
                                                          random_state =0)
#Creating the model
# units = 5 -> number of neurons in the hidden layer
# input_dim -> number of neurons in the input layer. It has to be the number
# of attributes.

modelo = Sequential()
modelo.add(Dense(units = 5, input_dim = 4)) #Input layer
modelo.add(Dense(units = 4)) # Hidden layer with 4 neuros
modelo.add(Dense(units = 3, activation = 'softmax')) # Output layer

modelo.summary()
# optimizer = adam -> algorithm used to backpropagation, ajust weights and bias
# loss = 'categorical_crossentropy' -> funtion used to calculate the deviation
modelo.compile(optimizer = 'adam', loss = 'categorical_crossentropy',
               metrics = ['accuracy'])
modelo.fit(x_training, y_training, epochs = 1000,
           validation_data = (x_test, y_test))
predictions = modelo.predict(x_test)
predictions
predictions = (predictions > 0.5) # visualization of ConfusionMatrix
y_test_matrix = [np.argmax(t) for t in y_test]
predictions_matrix = [np.argmax(t) for t in predictions]
confusion = confusion_matrix(y_test_matrix, predictions_matrix)
