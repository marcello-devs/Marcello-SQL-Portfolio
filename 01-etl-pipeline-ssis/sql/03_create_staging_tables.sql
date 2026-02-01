USE PortfolioETL;
GO

DROP TABLE IF EXISTS stg.Customers;
DROP TABLE IF EXISTS stg.Products;
DROP TABLE IF EXISTS stg.Orders;
GO

CREATE TABLE stg.Customers
(
    CustomerNaturalKey  varchar(20)  NOT NULL PRIMARY KEY,
    FirstName           varchar(100) NULL,
    LastName            varchar(100) NULL,
    Email               varchar(200) NULL,
    Country             varchar(100) NULL,
    LoadDts             datetime2(0) NOT NULL DEFAULT sysdatetime()
);

CREATE TABLE stg.Products
(
    ProductNaturalKey   varchar(20)   NOT NULL PRIMARY KEY,
    ProductName         varchar(200)  NULL,
    Category            varchar(100)  NULL,
    ListPrice           decimal(12,2) NULL,
    LoadDts             datetime2(0)  NOT NULL DEFAULT sysdatetime()
);

CREATE TABLE stg.Orders
(
    OrderNaturalKey     varchar(20)   NOT NULL PRIMARY KEY,
    OrderDate           date          NULL,
    CustomerNaturalKey  varchar(20)   NULL,
    ProductNaturalKey   varchar(20)   NULL,
    Quantity            int           NULL,
    UnitPrice           decimal(12,2) NULL,
    LoadDts             datetime2(0)  NOT NULL DEFAULT sysdatetime()
);
GO
