USE PortfolioETL;
GO

/* 
SCD2 Demo:
1) Pick one customer (current)
2) Change an attribute in dw.DimCustomer (e.g., Country)
3) Re-run: 06_load_dim_customer_scd2.sql
4) Verify the history in mart3.DimCustomer
*/

-- Step 1: Pick a customer to change (choose one natural key)
SELECT TOP 1 CustomerNaturalKey, FullName, Email, Country
FROM dw.DimCustomer
ORDER BY CustomerNaturalKey;
GO

-- Step 2: Change an attribute (example: Country)
-- Replace 'C001' with the CustomerNaturalKey you got above
UPDATE dw.DimCustomer
SET Country = CASE WHEN Country = 'UK' THEN 'Portugal' ELSE 'UK' END
WHERE CustomerNaturalKey = 'C001';
GO

-- Step 3: Run SCD2 load again
-- (Run this script separately in SSMS)
-- :r 06_load_dim_customer_scd2.sql

-- Step 4: Verify history
SELECT
    CustomerNaturalKey,
    CustomerName,
    Email,
    Country,
    ValidFromDts,
    ValidToDts,
    IsCurrent
FROM mart3.DimCustomer
WHERE CustomerNaturalKey = 'C001'
ORDER BY ValidFromDts;
GO
