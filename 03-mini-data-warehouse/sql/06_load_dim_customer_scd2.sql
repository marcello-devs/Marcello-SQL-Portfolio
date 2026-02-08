USE PortfolioETL;
GO

DECLARE @Now DATETIME2(0) = SYSUTCDATETIME();
DECLARE @EndOfTime DATETIME2(0) = '9999-12-31 00:00:00';

--------------------------------------------------------------------------------
-- STEP 1: Expire current records where attributes changed
--------------------------------------------------------------------------------
UPDATE tgt
SET
    tgt.ValidToDts = @Now,
    tgt.IsCurrent  = 0
FROM mart3.DimCustomer tgt
JOIN dw.DimCustomer src
    ON src.CustomerNaturalKey = tgt.CustomerNaturalKey
WHERE tgt.IsCurrent = 1
  AND (
        ISNULL(tgt.CustomerName,'') <> ISNULL(src.FullName,'')
     OR ISNULL(tgt.Email,'')        <> ISNULL(src.Email,'')
     OR ISNULL(tgt.Country,'')      <> ISNULL(src.Country,'')
  );

--------------------------------------------------------------------------------
-- STEP 2: Insert new current records (new OR changed customers)
--------------------------------------------------------------------------------
INSERT INTO mart3.DimCustomer
(
    CustomerNaturalKey,
    CustomerName,
    Email,
    Country,
    ValidFromDts,
    ValidToDts,
    IsCurrent
)
SELECT
    src.CustomerNaturalKey,
    src.FullName,
    src.Email,
    src.Country,
    @Now,
    @EndOfTime,
    1
FROM dw.DimCustomer src
LEFT JOIN mart3.DimCustomer cur
    ON cur.CustomerNaturalKey = src.CustomerNaturalKey
   AND cur.IsCurrent = 1
WHERE cur.CustomerKey IS NULL
   OR (
        ISNULL(cur.CustomerName,'') <> ISNULL(src.FullName,'')
     OR ISNULL(cur.Email,'')        <> ISNULL(src.Email,'')
     OR ISNULL(cur.Country,'')      <> ISNULL(src.Country,'')
   );
GO
