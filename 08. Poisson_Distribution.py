# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""

from scipy.stats import poisson

# mean accidents per day = 2
# Whats the probability of having 3 accidents?

poisson.pmf(3,2)

# Whats the probability of having 3 or less accidents per day?

poisson.cdf(3,2)

# Whats the probability of having more then 3 accidents?

poisson.sf(3,2)
