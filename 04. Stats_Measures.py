# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""

import numpy as np
from scipy import stats 

soccer_players = [40000, 18000, 12000, 250000, 30000, 140000, 300000, 40000, 800000]

np.mean(soccer_players)
quartis = np.quantile(soccer_players, [0,0.25,0.5,0.75,1])
np.std(soccer_players, ddof = 1)
stats.describe(soccer_players)
