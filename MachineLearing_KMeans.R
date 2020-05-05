dim(iris) 
head(iris)
summary(iris)

#150 instancies, 4 attributes and 1 class. 
#Iris is used a lot for CLASSIFICATION methods.
# Clustering -> we need to pass for the algorithm the 4 atributes in terms
# of sepals and petals
# for K-means we need to give to the algorithm the number of groups.
# In this case: 3 groups
# compare the groups created by the algortihm using TABLE
# comparing the clusters created with the real species

cluster = kmeans(iris[1:4], center = 3)
#Center =3 established that we want 03 centroid -> 03 groups created
# K-means is a clustering algorithm that has the need for the user to give the 
# number of groups to be created
cluster
#K-Means clustering with 3 clusters of sizes 50, 38, 62.
# They all sum up to 150 (the number of instancies). 

table(iris$Species, cluster$cluster)
# The algorithm is strugling with Verginica. Got it right for Setosas.
# 16 deviations - 84% of sucess rate.

plot(iris[,1:4], col = cluster$cluster)
#Looking the graph, the red in the plot is Setosa (100% of sucess rate)
# there is some overlap in plot between Verginica and versicolot