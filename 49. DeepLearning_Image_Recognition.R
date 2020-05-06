# Uploading files for training and testing
install.packages("h2o")
digitos = read.csv(gzfile(file.choose()), header = F)
dim(digitos) # 60.000 instancies for training, 785 columns

#784 are pixels (28 x 28 images).[7895] we have the label -> what is the number in the image

head(digitos)

####### Print the image 28x28 ###################

split.screen(figs=c(2,2))
# Just to see the image in row 20. We need to put in a matrix form (28x28)

dig = t(matrix(unlist(digitos[20,-785]), nrow = 28, byrow = F))
dig = t(apply(dig,2,rev))
screen(1)
image(dig, col = grey.colors(255))
digitos[20,785] #checking if the image is equal to the number in column 785
screen(2)
dig = t(matrix(unlist(digitos[2,-785]), nrow = 28, byrow = F))
dig = t(apply(dig,2,rev))
image(dig, col = grey.colors(255))
screen(3)
dig = t(matrix(unlist(digitos[4,-785]), nrow = 28, byrow = F))
dig = t(apply(dig,2,rev))
image(dig, col = grey.colors(255))
screen(4)
dig = t(matrix(unlist(digitos[5,-785]), nrow = 28, byrow = F))
dig = t(apply(dig,2,rev))
image(dig, col = grey.colors(255))

library(h2o)
h2o.init() #Java SE 14.0.1 not supported. 

# We need to transform class in factors 

treino = h2o.importFile(file.choose())
teste = h2o.importFile(file.choose())

# Distribution = "AUTO" -> the model will chose automatically the best distribution
# activation -> activation function
# hidden = c(64,64,64) -> 03 hidden layers with 64 perceptrons in each one
# epochs = 20 -> number of backpropagations in training process

modelo = h2o.deeplearning(x = colnames(treino[,1:784]), y="C785",
                          training_frame = treino,
                          validation_frame = teste,
                          distribution = "AUTO",
                          activation = "RectifierWithDropout",
                          hidden = c(64,64,64),
                          sparse = TRUE,
                          epochs = 20)
