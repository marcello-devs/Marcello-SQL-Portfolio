USE PortfolioETL;
GO

-- Re-load for demo repeatability
TRUNCATE TABLE mart3.FactSales;
GO

INSERT INTO mart3.FactSales
(
    DateKey,
    CustomerKey,
    ProductKey,
    OrderNaturalKey,
    Quantity,
    UnitPrice,
    SalesAmount
)
SELECT
    fs.DateKey,
    mc.CustomerKey,              
    mp.ProductKey,               
    fs.OrderNaturalKey,
    fs.Quantity,
    fs.UnitPrice,
    fs.SalesAmount
FROM dw.FactSales fs
JOIN dw.DimCustomer dwc
    ON dwc.CustomerKey = fs.CustomerKey
JOIN mart3.DimCustomer mc
    ON mc.CustomerNaturalKey = dwc.CustomerNaturalKey
   AND mc.IsCurrent = 1
JOIN dw.DimProduct dwp
    ON dwp.ProductKey = fs.ProductKey
JOIN mart3.DimProduct mp
    ON mp.ProductNaturalKey = dwp.ProductNaturalKey;
GO
