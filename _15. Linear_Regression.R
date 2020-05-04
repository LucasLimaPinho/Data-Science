
dim(cars) #database to be used in this example
head (cars)
cor (cars) #checks the correlation between columns in the DB.

# cor >= 0.7 -> strong correlation

# Creating the model to build new predictions based on linear regression

model = lm(speed ~ dist, data = cars)
model #gives me the a and b -> y = ax+b

plot(model)

plot(speed~dist,data=cars)
abline(model) #line with better fit (to make predictions)
model$coefficients
model$coefficients[1] + model$coefficients[2]*22 #'manually' predicting with
#the values of the coefficients from the linear regression model

predict(model, data.frame(dist=22)) #same thing as above using function predict

summary(model)

model$residuals #distance between real data and the line with better fit coming
# from abline(model)

model$fitted.values #used to create the line that better fits the model

plot (model$fitted.values, cars$dist)

