election = read.csv(file.choose(), sep =";", header =T)
fix(election)
plot(election$DESPESAS, election$SITUACAO)
summary(election)
cor(election$DESPESAS, election$SITUACAO) #Strong positive correlation
model = glm(SITUACAO ~ DESPESAS, data = election, family = "binomial")
#general linear model, family = binomial is saying that is to fit to a 
# logistic regression
model
summary(model)
plot(election$DESPESAS, election$SITUACAO, col = 'red', pch = 20) #pch = 20, filled dots
points(election$DESPESAS, model$fitted.values, pch = 4)
predictions_election = read.csv(file.choose(), sep=";", header = T)
fix(predictions_election)
predictions_election$RESULT = predict(model, 
                                      newdata = predictions_election,
                                      type = "response")
fix(predictions_election)

