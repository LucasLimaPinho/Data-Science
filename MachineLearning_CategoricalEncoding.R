install.packages("mltools")
install.packages("data.table")
library(mltools)

library(data.table)
Titanic
class(Titanic)

tit = as.data.frame(Titanic)
class(tit)

#LabelEncoding

labelencode = data.matrix(tit[,1:3]) #Function Data.Matrix does Label Encoding

#One-Hot Encoding

#Funcion one_hot makes part of "mltools"
#One_Hot needs a data table as input

hotencode = one_hot(as.data.table(tit[,1:3]))
