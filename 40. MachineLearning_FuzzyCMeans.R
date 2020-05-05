#Partial Clustering with Fuzzy C-Means - we can have some instancies without groupes
# Those instancies are noise
# For fuzzy c-means, we also can have the clustering in some group
# based on a proability (difuse).
# The instancie does not necessarily belongs to one group specifficaly
# The number of centers is the number of classes.
library(e1071)
library(mltools)

cluster_02 = cmeans(iris[,1:4], center = 3)
cluster_02 #We receive the probability of each instancie belonging to a certain group

#Hard clustering: give us the group with hogher probability - 
#getting close to K-means

#confusion_matrix using TABLE in R

table(iris$Species, cluster_02$cluster)
#Got wrong in 16 instancies - close to 90% sucess rate


 
