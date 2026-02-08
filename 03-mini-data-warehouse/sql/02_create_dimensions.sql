USE PortfolioETL;
GO

DROP TABLE IF EXISTS mart3.FactSales;
DROP TABLE IF EXISTS mart3.DimCustomer;
DROP TABLE IF EXISTS mart3.DimProduct;
DROP TABLE IF EXISTS mart3.DimDate;
GO

-- DimDate
CREATE TABLE mart3.DimDate
(
    DateKey     INT NOT NULL PRIMARY KEY,  -- YYYYMMDD
    [Date]      DATE NOT NULL,
    [Year]      INT NOT NULL,
    [Month]     INT NOT NULL,
    MonthName   VARCHAR(20) NOT NULL,
    YearMonth   CHAR(7) NOT NULL,          -- YYYY-MM
    Quarter     INT NOT NULL
);
GO

-- DimProduct (Type 1)
CREATE TABLE mart3.DimProduct
(
    ProductKey        INT IDENTITY(1,1) PRIMARY KEY,
    ProductNaturalKey VARCHAR(20) NOT NULL,          
    ProductName       NVARCHAR(200) NULL,
    Category          NVARCHAR(100) NULL,
    LoadDts           DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_DimProduct_NK UNIQUE (ProductNaturalKey)
);
GO

-- DimCustomer (SCD Type 2)
CREATE TABLE mart3.DimCustomer
(
    CustomerKey        INT IDENTITY(1,1) PRIMARY KEY,
    CustomerNaturalKey VARCHAR(20) NOT NULL,         
    CustomerName       NVARCHAR(200) NULL,
    Email              NVARCHAR(200) NULL,
    ValidFromDts       DATETIME2(0) NOT NULL,
    ValidToDts         DATETIME2(0) NOT NULL,
    IsCurrent          BIT NOT NULL,
    LoadDts            DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    Country            VARCHAR(100) NULL

);
GO

CREATE INDEX IX_DimCustomer_NK_Current
ON mart3.DimCustomer(CustomerNaturalKey, IsCurrent);
GO
