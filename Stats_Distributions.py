# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""

from scipy.stats import binom
from scipy.stats import norm


#The probabiloty of cossing a toing 5 times and get heads three times?
#Binomial Distribution
prob = binom.pmf(3,5,0.5)
prob
binom.pmf(1,4,0.25)
binom.pmf(2,4,0.25)
binom.pmf(3,4,0.25)
binom.pmf(4,4,0.25)

#Cumulative Probability

binom.cdf(4,4,0.25)

# In a test, whats the chance of getting 7  questions right considering
# that each question has 4 alternatives

binom.pmf(7,12,0.25)

#To get all the questions right

binom.pmf(12,12,0.25)

#Normal Distribution - mean = 8, sd =2, < 6

norm.cdf(6,8,2)

#the probability of the weight being higher than 6 kg

1 - norm.cdf(6,8,2)
norm.sf(6,8,2)

#Whats the probabiloty of the weight being lower than 6 and higher than 10

norm.cdf(6,8,2) + norm.sf(10,8,2)


from scipy import stats

from scipy.stats import norm

import matplotlib.pyplot as plt

data = norm.rvs(size=100) #generate alleatory data in normal distribution
stats.probplot(data,plot = plt)
stats.shapiro(data)

# T-Student Distribution

from scipy.stats import t

# medium wage of data scientist being R$ 75 / hour,
# whats the probabilty of the wage being < 80 / hour?
# sample size = 9
# degrees of freedom = sample size - 1 = 8
# sd for the sample = 10

t.cdf(1.5, 8)
t.sf(1.5,8)
