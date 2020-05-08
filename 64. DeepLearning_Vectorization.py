# Vectorization for fastening DeepLearning algorithms
# In Deeplearning era, Vetorization is essential to avoid
# a lot of for loops in the code.
#  Before Deepleraning era, vectorization was seen as a GP for
# gaining computational performance. Now it is seen as a must have
# to perform deeplearning algortihms.



import numpy as np
import time #Time how long different operations take

a = np.array([1,2,3,4])
print(a)
a = np.random.rand(1000000)
b = np.random.rand(1000000)
tic=time.time()
c=np.dot(a,b) #NP.DOT -> Vectorization
# c = a1*b1 + a2*b2 + a3*b3 + ...+ a1000000*b1000000
toc =time.time()
print(c)
print("Vectorized version:" +str(1000*(toc-tic))+ " ms")

c = 0
tic = time.time()
for i in  range(1000000):
    c += a[i]*b[i]
toc=time.time()
print(c)
print("For loop:" + str(1000*(toc-tic)) + "ms")

# Now we can see that Vectorization makes the algorithm performance
# is way better then the version with the loop.
# VECTORIZATION is really important for GRADIENT DESCENT in 
# optimization phase of the deeplearning neural network.
