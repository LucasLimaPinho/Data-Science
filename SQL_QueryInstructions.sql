SELECT cliente, sexo, status FROM clientes  
WHERE status = 'Platinum' or status = 'Gold';
SELECT * FROM clientes; 
SELECT cliente, status FROM clientes;
SELECT cliente, sexo, status FROM clientes
WHERE STATUS IN ('Gold', 'Platinum');
SELECT cliente, sexo, status FROM clientes
WHERE cliente LIKE '%Alb%';
SELECT MIN(TOTAL) FROM VENDAS;
SELECT MAX(TOTAL) FROM VENDAS;
SELECT AVG(TOTAL) FROM VENDAS;
SELECT SUM(TOTAL) FROM VENDAS;
SELECT SUM(TOTAL) FROM VENDAS
WHERE TOTAL>6000;
SELECT IDVendedor, COUNT(IDVendedor) FROM VENDAS
GROUP BY IDVendedor;

SELECT IDVendedor, COUNT(IDVendedor) FROM VENDAS
GROUP BY IDVendedor
HAVING COUNT(IDVendedor) > 40;
