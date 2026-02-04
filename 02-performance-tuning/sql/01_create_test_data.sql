USE PortfolioETL;
GO

DROP TABLE IF EXISTS dbo.SalesPerfTest;
GO

CREATE TABLE dbo.SalesPerfTest
(
    SalesId INT IDENTITY PRIMARY KEY,
    CustomerId INT,
    ProductId INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
);
GO

;WITH n AS (
    SELECT TOP (200000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO dbo.SalesPerfTest (CustomerId, ProductId, OrderDate, Amount)
SELECT
    ABS(CHECKSUM(NEWID())) % 10000,
    ABS(CHECKSUM(NEWID())) % 500,
    DATEADD(day, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),
    RAND(CHECKSUM(NEWID())) * 100
FROM n;
GO
