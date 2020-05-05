library(mltools)
library(data.table)
boxplot(iris[,1:4])

#Standardization (Z_Score)
# All values around the mean value. Don't affect outliers.
# Different boxplot pattern then original values - we can have negative values

iris_standard = scale(iris[,1:4])
boxplot(iris_standard[,1:4])

#Normalize - all values are positive. Remove outliers.
# Same pattern for boxplot as original data.

normaliza = function(x){
  return((x-min(x))/(max(x) - min(x)))
}

iris_norm = normaliza(iris[,1:4])
boxplot(iris_norm[,1:4])
