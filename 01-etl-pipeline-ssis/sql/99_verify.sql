USE PortfolioETL;
GO

PRINT '===== ETL VERIFICATION =====';

PRINT 'Raw counts';
SELECT 'Customers' AS TableName, COUNT(*) Rows FROM raw.Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM raw.Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM raw.Orders;

PRINT 'Warehouse counts';
SELECT 'DimCustomer', COUNT(*) FROM dw.DimCustomer
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM dw.DimProduct
UNION ALL
SELECT 'DimDate', COUNT(*) FROM dw.DimDate
UNION ALL
SELECT 'FactSales', COUNT(*) FROM dw.FactSales;

PRINT 'Latest ETL runs';
SELECT TOP 10 *
FROM etl.ETLRunLog
ORDER BY ETLRunId DESC;

PRINT 'Sample facts';
SELECT TOP 10 *
FROM dw.FactSales
ORDER BY SalesKey DESC;
GO
