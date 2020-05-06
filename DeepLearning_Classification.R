# Multilayer perceptron.
# Package: neuralnet
# Task: Classification in iris database.
# We need to make the "binarization" of the Species (class)


install.packages("neuralnet")
library(neuralnet)
myiris = iris

# BINARIZATION of Species. 

myiris = cbind(myiris,myiris$Species=='setosa')
myiris = cbind(myiris,myiris$Species=='versicolor')
myiris = cbind(myiris,myiris$Species=='virginica')
summary(myiris)
tail(myiris)
head(myiris)
names(myiris) [6] = 'setosa'
names(myiris) [7] = 'versicolor'
names(myiris) [8] = 'virginica'

# Creating training and test database

amostra = sample(2,150,replace=T,prob=c(0.7,0.3)) # Creating training and test data
myiristreino = myiris[amostra==1,]
myiristeste = myiris[amostra==2,]

#Creating the model with neuralnet
# Neuralnet does not accept (~ .)

modelo = neuralnet(setosa + versicolor + virginica ~ Sepal.Length + 
                     Sepal.Width + Petal.Length + Petal.Width,
                   myiristreino,
                   hidden = c(5,4))
# hidden = c(5,4) -> two hidden layers with 5 and 4 perceptrons

print(modelo)
plot(modelo) # We can see the layers, bias and weights

teste = compute(modelo, myiristeste[,1:4])
teste$net.result #for each class it atributes a weight.
resultado = as.data.frame(teste$net.result)
names(resultado)[1] = 'setosa'
names(resultado)[2] = 'versicolor'
names(resultado)[3] = 'virginica'
head(resultado)
resultado$class = colnames(resultado[,1:3])[max.col(resultado[,1:3],
                                                    ties.method = 'first')]
head(resultado)

# Testing the model

confusion_matrix = table(resultado$class, myiristeste$Species)
confusion_matrix

sum(diag(confusion_matrix))  #total of sucess
sum(diag(confusion_matrix)) / sum(confusion_matrix) #Sucess rate
