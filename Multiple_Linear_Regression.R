#MUltiple Linear Regression

dim(mtcars)
colnames(mtcars)
mtcars[1:4]
cor(mtcars[1:4]) #correlation between the first 4 attributes
model = lm(mpg ~ disp, data = mtcars)
model
summary(model)
summary(model)$r.squared
summary(model)$adj.r.squared #always lower than r.squared. Tends to get bigger
#when we add variables to the model

plot(mpg~disp, data=mtcars)
abline(model)
predict(model, data.frame(disp=c(200)))
#Adding other independent variables - Multiple Linear Regression

model_02 = lm(mpg ~ disp + hp + cyl, data=mtcars)
model_02
summary(model_02)
summary(model_02)$r.squared #higher then model 01
summary(model_02)$adj.r.squared
predict(model_02, data.frame(disp=200,hp=100,cyl=4)) #prediction with
# multiple Linear Regression with adjusted r_squared higher than 0.7


