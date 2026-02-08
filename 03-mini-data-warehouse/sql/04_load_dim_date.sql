USE PortfolioETL;
GO

INSERT INTO mart3.DimDate (DateKey, [Date], [Year], [Month], MonthName, YearMonth, Quarter)
SELECT
    d.DateKey,
    d.[Date],
    d.[Year],
    d.[Month],
    DATENAME(MONTH, d.[Date]),
    CONVERT(CHAR(7), d.[Date], 120),
    DATEPART(QUARTER, d.[Date])
FROM dw.DimDate d
WHERE NOT EXISTS (SELECT 1 FROM mart3.DimDate x WHERE x.DateKey = d.DateKey);
GO
