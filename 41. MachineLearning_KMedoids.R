install.packages("cluster", dependecies = T)
library(cluster)
cluster = pam(iris[,1:4], k=3) #k equals number of centers
#Medoids are real points - real instancies

plot(cluster)

#Confusion Matrix

table(iris$Species, cluster$clustering)

#Erros: 16. CLose to 80% sucess rate.
