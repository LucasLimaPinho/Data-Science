import pandas as pd
from sklearn.preprocessing import LabelEncoder,OneHotEncoder
from sklearn.compose import make_column_transformer
from sklearn.preprocessing import StandardScaler, MinMaxScaler
dataset = pd.read_csv('Credit.csv')

# We are going to scale values in three colums
# Duration -> index 1
# Pcredit_amount -> index 4
# installment_commitment -> index 7

X = dataset.iloc[:,[1,4,7]].values #Taking Personal Status and other_parties
sc = StandardScaler()
y = sc.fit_transform(X)

ns = MinMaxScaler()
w = ns.fit_transform(X)

