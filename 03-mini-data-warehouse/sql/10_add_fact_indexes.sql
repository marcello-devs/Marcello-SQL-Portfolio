USE PortfolioETL;
GO

/* 
Indexing strategy:
- Most analytics filter by DateKey and group by customer/product.
*/

-- Join/filter support
CREATE INDEX IX_mart3FactSales_DateKey     ON mart3.FactSales(DateKey);
CREATE INDEX IX_mart3FactSales_CustomerKey ON mart3.FactSales(CustomerKey);
CREATE INDEX IX_mart3FactSales_ProductKey  ON mart3.FactSales(ProductKey);

-- Composite index for common reporting patterns (monthly revenue, date filtering)
CREATE INDEX IX_mart3FactSales_Date_Cust_Prod
ON mart3.FactSales(DateKey, CustomerKey, ProductKey)
INCLUDE (SalesAmount, Quantity);
GO
