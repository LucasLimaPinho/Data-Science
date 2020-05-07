-- APELIDOS (NICKNAMES)

SELECT cliente, total FROM vendas V
INNER JOIN clientes C ON (V.IDCliente = C.IDCLiente);

