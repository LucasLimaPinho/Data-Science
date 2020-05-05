install.packages("class", dependencies = T)
library(class)
head(iris)
summary(iris) #150 instancies, 5 attributes
amostra = sample(2,150,replace=T, prob=c(0.7,0.3))
iristreino = iris[amostra==1,]
irisclassificar = iris[amostra==2,]
dim(iristreino)
dim(irisclassificar)
prediction = knn(iristreino[,1:4], irisclassificar[,1:4],
  iristreino[,5],k=3)
table(irisclassificar[,5], prediction) #COnfusion_Table
#Tryes to classificate in terms of the nearest neighbour


