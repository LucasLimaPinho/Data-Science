#OUTLIERS

# boxplot -> visualização
# boxplot.stats -> numbers
# Outliers -> package

boxplot(iris$Sepal.Width)
boxplot (iris$Sepal.Width, outline=F) #Does not show outliers
boxplot.stats(iris$Sepal.Width)
boxplot.stats(iris$Sepal.Width)$out
install.packages('outliers')
library(outliers)
outlier(iris$Sepal.Width)
outlier(iris$Sepal.Width, opposite = T)
