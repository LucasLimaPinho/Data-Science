#Ensamble learning focused on random forest

install.packages("randomForest", dependencies = T)
library(randomForest)
credito = read.csv(file.choose(), sep = ",", header = T)
sampling = sample(2,1000,replace = T, prob = c(0.7,0,3))
creditotreino = credito[sampling==1,]
creditoteste = credito[sampling==2,]
dim(creditoteste)
dim(creditotreino)
forest = randomForest(class ~ . , data = creditotreino, ntree= 100,
                      importance = T)
varImpPlot(forest)
prediction = predict(forest, creditoteste)
confusion = table(prediction, creditoteste$class)
taxaacerto = (confusion[1]+confusion[4]) / sum(confusion)
taxaacerto
taxaerro = (confusion[2] + confusion [3]) / sum(confusion)
taxaerro
