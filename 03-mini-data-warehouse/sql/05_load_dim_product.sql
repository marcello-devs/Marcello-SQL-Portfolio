USE PortfolioETL;
GO

MERGE mart3.DimProduct AS tgt
USING (
    SELECT ProductNaturalKey, ProductName, Category
    FROM dw.DimProduct
) AS src
ON tgt.ProductNaturalKey = src.ProductNaturalKey
WHEN MATCHED THEN
    UPDATE SET
        tgt.ProductName = src.ProductName,
        tgt.Category = src.Category
WHEN NOT MATCHED THEN
    INSERT (ProductNaturalKey, ProductName, Category)
    VALUES (src.ProductNaturalKey, src.ProductName, src.Category);
GO
