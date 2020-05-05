install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)
# Here we are using 'transacoes.txt' when we are going to file.choose()
transacoes = read.transactions(file.choose(), format = "basket",sep=",")
transacoes
# Format = Basket -> wish list / purchase list format

inspect(transacoes)
image(transacoes)
regras = apriori(transacoes, parameter = list(support=0.5,conf=0.5))
# if we dont stablish minimun values for suport and confidence,
# we are going to lose a lot of efficiency in running the algorithm
# When we talk abou associonation, we are dealing with millions of transactions
# we need to optimize the algorithm (major challenge). Putting some minimum criteria
# its important to make the processment feasible.
regras
inspect(regras)
plot(regras)
plot(regras,method="graph",control=list(type="items"))
# As higher the support is, the larger is the diameter of the circles
