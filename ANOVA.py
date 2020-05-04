# -*- coding: utf-8 -*-
"""


@author: LucasLimaPinho
"""

import pandas as pd
from scipy import stats
import statsmodels.api as sm
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import MultiComparison

treatment = pd.read_csv('anova.csv', sep = ";")

treatment.boxplot(by = 'Remedio', grid = False)

model = ols('Horas ~ Remedio', data = treatment).fit()
results_01 = sm.stats.anova_lm(model)


model02 = ols('Horas ~ Remedio * Sexo', data = treatment).fit()
resultados02 = sm.stats.anova_lm(model02)

mc = MultiComparison(treatment['Horas'], treatment ['Remedio'])
resultado_test = mc.tukeyhsd()
print(resultado_test)
resultado_test.plot_simultaneous()
