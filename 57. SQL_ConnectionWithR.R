#install.packages("RPostgreSQL")
library("RPostgreSQL")
conexao = dbConnect("PostgreSQL", dbname="CD", host="localhost", port=5432,
                    user="postgres", password=123456)

sql = " SELECT QUANTIDADE, VALORTOTAL, PRODUTO, TOTAL FROM ITENSVENDA  IV
      INNER JOIN VENDAS V ON (IV.IDVENDA = V.IDVENDA) 
      INNER JOIN PRODUTOS P ON (IV.IDPRODUTO = P.IDPRODUTO)"

vendas = dbGetQuery(conexao, sql)

class(vendas)
dim(vendas)


