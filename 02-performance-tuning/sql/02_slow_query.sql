USE PortfolioETL
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT
    CustomerId,
    SUM(Amount) AS TotalSales
FROM dbo.SalesPerfTest
WHERE OrderDate >= DATEADD(day,-90,GETDATE())
GROUP BY CustomerId
ORDER BY TotalSales DESC;
GO
