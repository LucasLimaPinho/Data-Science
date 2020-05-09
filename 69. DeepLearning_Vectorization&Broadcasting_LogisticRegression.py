# Whenever possible, avoid explicit 'for' loops.
#Whenever you need to use a for loop, take a look in packages and librarys that can help you
# do it without explicit for loops.
# NUMPY is a module that has a lot of functions that can do vectorization and speed up algorithms without using 
# explicit 'for' loops.

import numpy as np

u = np.exp(v)
u = np.log(v)
u = np.abs(v)
u = np.maximum(v,0)

# VECTORIZATION OF LOGISTIC REGRESSION (not using explicit for loop), FORWARD PROPAGATION

#J = 0  Cost Function when using Logistic Regression as Activation Function for perceptrons
#Taking into account only two weights
#dw1 = 0 Derivatives for weight 1, (dJ\dw1)
#dw2 = 0  Derivative for weight 2, (dJ\dw2)
#db = 0 Derivative for bias, (dj\db)
#m = number of training samples
#X -> training set matrix. Its a matriz with shape (Nx, m)
# m (number of training samples) will be the number of columns.
#[z1 z2 ... znx] = w_transpose*X + [b1 b2 b3 ... bm]
# w_transpose will be a row vector. the result of the multiplication by X also a row vector
# Z = np.dot(w_transpose, X) + b ---------> Python automaticaly turns b into a row vector, not just a number (1,1)
# This is called BROADCASTING. 
# A = sigmoid(z) -----> sigmoid = (1 \ (1+e^(-z)) 
# A = [a1 a2 a3 ... am]
###################### 1 line of code to compute A
###################### 1 line of code to compute Z
###################### no need for explicit for loops lagging the algorithm

# VECTORIZATION OF LOGISTICS REGRESSION - Regressions Gradient Computation, backpropagation


# dz1 = a1 - y1
# dz2 = a2 - y2
# dzm = am - ym
# Z = [dz1, dz2,...,dzm] 1xm
# A = [a1, a2,..., am] stacked horizontally
# dz = A - Y = [a1-y1, a2-y2, ..., am - ym] 1 line of code to compute at the same time
# db = (1\m) * sum(dz) for i = 1 to m
# in Python with vectorization -> db = (1\m) * np.sum(dz)
# dw = (1\m)*X*dz_transpose -----------> dz_transpose is a column vector with dimension m
# The product X*dz_transpose is going to give us a (nx x 1) row vector


# Z = np.dot(w_transpose*X) + b ---> forward propagation
# A = sigmoid(z) ---> forward propagation
# dz = A - Y ---> forward propagation
# dw = (1\m) * X x dz_transpose ---> backpropagation
# db = (1\m) * np.sum(dz) ---> backpropagation
# forward propagation + backpropagation in 5 lines with one for loop (number of iterations of gradiente descent)
# for sigmoid as a activation function

# Updating......

# w = w - learning_rate * dw
# b = b - learning_rate * db

# You might still need a unique for loop for the nummber of iterations for GRADIENT DESCENT algorithm

# BROADCASTING IN PYTHON ,another technique to make your python algorithm run faster.

# Example for broadcasting in python

import numpy as np
A= np.array([[56,0,4.4,68],
             [1.2,104,52,8],
             [1.8,135,99,0.9]])
print(A)
cal = A.sum(axis=0) # Axis = 0 determines that the sum is going to be in the column
print(cal)
percentage = 100*A/cal.reshape(1,4) #reshape is really cheap to call.  WE can to make sure.
print(percentage)
example_broadcast = np.array([1,2,3,4])  + 100
print(example_broadcast)
example_broadcast02 = np.array([[1,2,3],[4,5,6]]) + np.array([100,200,300])
print(example_broadcast02)

# TIPS AND TRICKS -> when programming neural networks algorithms, avoid vectors in the shape (x,)

a = np.random.randn(5)
print(a)
print(a.shape) #avoid (5,)
print(a.T) #transpose
print(np.dot(a,a.T))
b = np.random.randn(5,1)
print(b)
print(b.shape)
print(b.T)
print(np.dot(b,b.T))







    
