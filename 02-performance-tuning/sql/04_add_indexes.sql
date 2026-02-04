USE PortfolioETL
GO

CREATE NONCLUSTERED INDEX IX_SalesPerfTest_OrderDate
ON dbo.SalesPerfTest (OrderDate)
INCLUDE (CustomerId, Amount);
GO
