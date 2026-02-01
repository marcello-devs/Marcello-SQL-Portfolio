USE PortfolioETL;
GO

DROP TABLE IF EXISTS dw.FactSales;
DROP TABLE IF EXISTS dw.DimProduct;
DROP TABLE IF EXISTS dw.DimCustomer;
DROP TABLE IF EXISTS dw.DimDate;
GO

CREATE TABLE dw.DimCustomer
(
    CustomerKey         int IDENTITY(1,1) PRIMARY KEY,
    CustomerNaturalKey  varchar(20) NOT NULL UNIQUE,
    FullName            varchar(201) NULL,
    Email               varchar(200) NULL,
    Country             varchar(100) NULL,
    EffectiveFromDts    datetime2(0) NOT NULL DEFAULT sysdatetime()
);

CREATE TABLE dw.DimProduct
(
    ProductKey          int IDENTITY(1,1) PRIMARY KEY,
    ProductNaturalKey   varchar(20) NOT NULL UNIQUE,
    ProductName         varchar(200) NULL,
    Category            varchar(100) NULL,
    ListPrice           decimal(12,2) NULL,
    EffectiveFromDts    datetime2(0) NOT NULL DEFAULT sysdatetime()
);

CREATE TABLE dw.DimDate
(
    DateKey     int NOT NULL PRIMARY KEY, -- YYYYMMDD
    [Date]      date NOT NULL UNIQUE,
    [Year]      int NOT NULL,
    [Month]     int NOT NULL,
    MonthName   varchar(20) NOT NULL
);

CREATE TABLE dw.FactSales
(
    SalesKey        bigint IDENTITY(1,1) PRIMARY KEY,
    OrderNaturalKey varchar(20) NOT NULL,
    DateKey         int NOT NULL,
    CustomerKey     int NOT NULL,
    ProductKey      int NOT NULL,
    Quantity        int NOT NULL,
    UnitPrice       decimal(12,2) NOT NULL,
    SalesAmount     AS (Quantity * UnitPrice) PERSISTED,

    CONSTRAINT FK_FactSales_DimDate     FOREIGN KEY (DateKey)     REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_FactSales_DimCustomer FOREIGN KEY (CustomerKey) REFERENCES dw.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_DimProduct  FOREIGN KEY (ProductKey)  REFERENCES dw.DimProduct(ProductKey)
);
GO
