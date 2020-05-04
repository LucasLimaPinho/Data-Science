# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""

import numpy as np
from scipy.stats import chi2_contingency

soap = np.array([[19,6], [43,32]])
chi2_contingency(soap)
# p > alfa -> we cant reject the null hypothesis

