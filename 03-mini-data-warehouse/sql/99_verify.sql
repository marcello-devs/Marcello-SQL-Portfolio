USE PortfolioETL;
GO

SELECT 'DimDate' AS TableName, COUNT(*) AS Rows FROM mart3.DimDate
UNION ALL SELECT 'DimProduct', COUNT(*) FROM mart3.DimProduct
UNION ALL SELECT 'DimCustomer', COUNT(*) FROM mart3.DimCustomer
UNION ALL SELECT 'FactSales', COUNT(*) FROM mart3.FactSales;

-- Orphan checks
SELECT TOP 10 * FROM mart3.FactSales f
WHERE NOT EXISTS (SELECT 1 FROM mart3.DimCustomer c WHERE c.CustomerKey = f.CustomerKey);

SELECT TOP 10 * FROM mart3.FactSales f
WHERE NOT EXISTS (SELECT 1 FROM mart3.DimProduct p WHERE p.ProductKey = f.ProductKey);

SELECT TOP 10 * FROM mart3.FactSales f
WHERE NOT EXISTS (SELECT 1 FROM mart3.DimDate d WHERE d.DateKey = f.DateKey);
GO
