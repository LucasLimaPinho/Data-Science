import pandas as pd
from sklearn.preprocessing import LabelEncoder,OneHotEncoder
from sklearn.compose import make_column_transformer
dataset = pd.read_csv('Credit.csv')

# We are going to encode two columns - Personal Status and  other_parties
# Personal Status -> index 8
# other_parties -> index 9

X = dataset.iloc[:,8:10].values #Taking Personal Status and other_parties

labelencoder = LabelEncoder()
X[:,0] = labelencoder.fit_transform(X[:,0])

onehotencoder = make_column_transformer((OneHotEncoder(categories='auto', 
                                                       sparse=False),[1]),
                                         remainder = "passthrough")
X = onehotencoder.fit_transform(X)

