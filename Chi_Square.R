# Chi-Squared Test
# @author: LucasLimaPinho

soap = matrix(c(19,6,43,32), nrow =2, byrow=T)
fix(soap)
rownames(soap) = c("Male","Female")
colnames(soap) = c("Do Watch", "Don't Watch")
fix(soap)
chisq.test(soap) #Does not reject the null hypothesis p=0.1535


