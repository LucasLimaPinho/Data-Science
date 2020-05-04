# Analysis of Variance (ANOVA)

#T-Test: only if there are 2 groups. More then 2 calls for ANOVA

treatment = read.csv(file.choose(), sep = ";", header = T)
fix(treatment)
boxplot(treatment$Horas ~treatment$Remedio)

#1-factor Analysis of Variance

AN = aov(Horas ~ Remedio, data = treatment)
summary(AN)

AN_02 = aov(Horas ~ Remedio * Sexo, data = treatment)
summary(AN_02)

Tukey = TukeyHSD(AN)
Tukey
