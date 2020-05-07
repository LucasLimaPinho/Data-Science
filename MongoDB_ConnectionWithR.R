install.packages("mongolite")
library(mongolite)
connection = mongo(collection = "baseteste", db = "dbmidias",
                   url = "mongodb://localhost")
data = connection$find()
class(data) #We have now a dataframe coming from a json file
data = connection$find('{"nome":"Lucas"}') # Following find in MongoDB
