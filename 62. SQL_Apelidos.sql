-- JOIN -> unite data using Private Key (PK) and Foreign Key (FK)
-- We need JOIN to take the name of vendors using IDVendedor with JOIN with TABLE vendedores
-- INNER JOIN -> intersection
-- LEFT JOIN
-- RIGHT JOIN
-- FULL JOIN -> union
-- WE need equivalency between Primary Key and FOreign Key
SELECT nome, total FROM vendas, vendedores
WHERE vendas.IDvendedor = vendedores.IDvendedor; -- Without using JOIN, but the same spirit

SELECT COUNT(*) FROM vendas
INNER JOIN vendedores
ON (vendas.IDVendedor = vendedores.IDVendedor);
SELECT COUNT(*) FROM vendas
LEFT JOIN vendedores
ON (vendas.IDVendedor = vendedores.IDVendedor) -- LEFT JOIN, also the total of all sales.

INSERT INTO vendedores(nome) VALUES ('Lucas Lima');
SELECT COUNT(*) FROM vendas 
RIGHT JOIN vendedores
ON (vendas.IDVendedor = vendedores.IDVendedor);

SELECT COUNT(*) FROM vendas 
LEFT JOIN vendedores
ON (vendas.IDVendedor = vendedores.IDVendedor);

SELECT COUNT(*) FROM vendas 
INNER JOIN vendedores
ON (vendas.IDVendedor = vendedores.IDVendedor);

SELECT COUNT(*) FROM vendas 
FULL JOIN vendedores
ON (vendas.IDVendedor = vendedores.IDVendedor);



-- APELIDOS (NICKNAMES)

SELECT cliente, total FROM vendas V
INNER JOIN clientes C ON (V.IDCliente = C.IDCLiente);

