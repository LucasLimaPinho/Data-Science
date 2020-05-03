dim(iris)
sample_01 = sample(c(0,1),150, replace=T, prob=c(0.5,0.5))
sample_01
length(sample_01[sample_01==1]) 

set.seed(2346) #Establishing a seed for sampling. Everytime that seed changes,
#we get a different result for sample

sample(c(100),1)
summary(iris) 
install.packages("sampling")
library(sampling)
sample_02 = strata(iris, c("Species"), size = c(25,25,25), method = "srswor") 
#strata generates an stratified sample of the database
sample_02
summary(sample_02)
infert
summary(infert)
sample_03 = strata(infert, c("education"), size = c(5,48,47), method = "srswor" )
summary(sample_03)
# Sampling technique that allows that the collumn education
# has the same probability without reposition
# help (strata) can help with another techniques for sampling

#################### Systematic Sampling ################

install.packages("TeachingSampling")
library (TeachingSampling)
sample_04 = S.SY(150, 10) # generates one sample in alleatory mode.
# Afterwards adds *10* (or other parameter stablished) for each one
# of the samples
sample_04 #only the first number is alleatory

sampleiris = iris[sample_04,]
sampleiris

