USE PortfolioETL;
GO

DROP TABLE IF EXISTS raw.Customers;
DROP TABLE IF EXISTS raw.Products;
DROP TABLE IF EXISTS raw.Orders;
GO

CREATE TABLE raw.Customers
(
    CustomerNaturalKey  varchar(20)  NOT NULL,
    FirstName           varchar(100) NULL,
    LastName            varchar(100) NULL,
    Email               varchar(200) NULL,
    Country             varchar(100) NULL,
    LoadDts             datetime2(0) NOT NULL DEFAULT sysdatetime()
);

CREATE TABLE raw.Products
(
    ProductNaturalKey   varchar(20)   NOT NULL,
    ProductName         varchar(200)  NULL,
    Category            varchar(100)  NULL,
    ListPrice           varchar(50)   NULL,  -- raw as text (common real-world)
    LoadDts             datetime2(0)  NOT NULL DEFAULT sysdatetime()
);

CREATE TABLE raw.Orders
(
    OrderNaturalKey     varchar(20)  NOT NULL,
    OrderDate           varchar(50)  NULL,  -- raw as text
    CustomerNaturalKey  varchar(20)  NULL,
    ProductNaturalKey   varchar(20)  NULL,
    Quantity            varchar(50)  NULL,  -- raw as text
    UnitPrice           varchar(50)  NULL,  -- raw as text
    LoadDts             datetime2(0) NOT NULL DEFAULT sysdatetime()
);
GO
