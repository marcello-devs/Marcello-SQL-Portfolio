USE PortfolioETL;
GO

-- Monthly revenue
SELECT
    d.YearMonth,
    SUM(f.SalesAmount) AS MonthlyRevenue
FROM mart3.FactSales f
JOIN mart3.DimDate d ON d.DateKey = f.DateKey
GROUP BY d.YearMonth
ORDER BY d.YearMonth;

-- Top customers
SELECT TOP 10
    c.CustomerName,
    SUM(f.SalesAmount) AS TotalRevenue
FROM mart3.FactSales f
JOIN mart3.DimCustomer c ON c.CustomerKey = f.CustomerKey
GROUP BY c.CustomerName
ORDER BY TotalRevenue DESC;

-- YoY comparison (by month)
WITH Monthly AS (
    SELECT
        d.[Year],
        d.[Month],
        SUM(f.SalesAmount) AS Revenue
    FROM mart3.FactSales f
    JOIN mart3.DimDate d ON d.DateKey = f.DateKey
    GROUP BY d.[Year], d.[Month]
)
SELECT
    [Month],
    SUM(CASE WHEN [Year] = YEAR(GETDATE()) THEN Revenue END) AS ThisYear,
    SUM(CASE WHEN [Year] = YEAR(GETDATE()) - 1 THEN Revenue END) AS LastYear
FROM Monthly
GROUP BY [Month]
ORDER BY [Month];
GO
