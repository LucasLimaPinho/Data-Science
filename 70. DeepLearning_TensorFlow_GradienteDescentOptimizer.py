import numpy as np
import tensorflow as tf

alfa = 0.01 # learning_rate
w = tf.Variable(0, dtype = float32) #initializing w
cost = tf.add(np.power(w,2),np.multiply(-10.,w),25)
train = tf.train.GrandientDescentOptimizer(alfa).minimize(cost)

init = tf.global_variables_initializer()
session = tf.Session()
session.run(init)
print(session.run(w))
session.run(train)

for i  in range(1000):
  session.run(train)
print(session.run(w))
