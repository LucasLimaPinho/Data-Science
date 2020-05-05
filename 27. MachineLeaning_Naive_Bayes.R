#e1071 -> package for NaiveBayes
#klaR -> package for NaiveBayes


install.packages("e1071",dependencies = T)
library (e1071)
credito = read.csv(file.choose(), sep=",", header = T)
head(credito)
dim(credito)
#1000 instancies, 21 attributes
# the last column is the class - is he a good or bad payer
# by the fact that has a class - supervisioned model

# you need to build a good model. Train with different data that 
# is used to test. 70% og the historical record is going to be used for training
# 30% used for testing the machine learning
# we can use the function sample that is available in file 01. Sampling in GitHub
# we need to use sampling to separate 70% for training and 30% for testing

sampling = sample(2, 1000, replace = T, prob=c(0.7,0.3)) #establishing probabilites
# to track training sample and testing sample

sampling

credito_train = credito[sampling==1,] #*important: alleatory formation of training data
credito_train
credito_teste = credito[sampling==2,] #*important: formation of testing data
credito_teste
dim(credito_train)
dim(credito_teste)
credito_teste

model = naiveBayes(class ~ .,credito_train) #two parameters: establish how I am going to train my model
# and the second paramteter is establishing wich are the data
# First atribute to naivebayes is the attributes to train the model. 
# Class is the response that we want to get from the model and it is 
# related to all ohter atributes in the relationship 'credito'
#R provide us a tool when using naiveBayes whilst using a dot '.'
# it brings all the attributes without the need to write one by one
# in this case - 21 attributes.

model
class(model)

# We create models to make predictions. We need to evaluate the performance
# of the model that was created. If the performance it is ok, we can bring it
# to the production enviroment and make real predictions. We need 
# the test sampling made above. It allows to make tests based on the
# the real class data that we already know.

#Analysing the performance of the model with database credito_teste
previsao = predict(model, credito_teste)
previsao
credito_teste
credito_train
confusao = table(credito_teste$class, previsao)
confusao
