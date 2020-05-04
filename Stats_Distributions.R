#Binomial Distribution

dbinom(2,2,0.5) #find probability
pbinom(2,2,0.5) #find cummulative distribution


 dbinom(3,5,0.5)
 
 #Normal Distribution
 
 
 # mean =8, sd = 2, object < 6
 
 x = pnorm(6,8,2) #finds the probability mentioned above
 z = pnorm(6,8,2, lower.tail = F) #finds the probability to be higher than 6
 w = pnorm(6,8,2) + pnorm(10,8,2,lower.tail = F) #probabilty of being higher than
 #6 and lower than 10
 
 y = rnorm(100)
 qqnorm(y) # generates dispersion graph
 qqline(y) # generates the line
 shapiro.test(y)#normality tst- Shapiro-Wilk
 