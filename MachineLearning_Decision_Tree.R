install.packages("rpart", dependencies = T)
library(rpart)
credito = read.csv(file.choose(), sep=",", header = T)
sampling = sample(2,1000,replace=T, prob=c(0.7,0.3))
creditotreino = credito[sampling==1,]
creditoteste = credito[sampling==2,]
dim(credito)
tree = rpart(class~.,data=creditotreino,method="class")
print(tree)
plot(tree)
text(tree, use.n=T, all=T, cex=.2)
teste = predict(tree,newdata=creditoteste)
teste #the prediction is a probability of being a bad or good payer
cred = cbind(creditoteste, teste)
fix(cred)
cred['Result'] = ifelse(cred$bad >=0.5, "bad", "good")
fix(cred)
confusion = table(cred$class, cred$Result)
confusion
taxa_acerto = (confusion[1] + confusion[4]) / sum(confusion)
taxa_erro = (confusion[2] + confusion[3]) /sum(confusion)
taxa_acerto
taxa_erro

