USE PortfolioETL;
GO

/* 1) Create temp tables matching CSV structure ONLY (no LoadDts) */
DROP TABLE IF EXISTS #CustomersCSV;
DROP TABLE IF EXISTS #ProductsCSV;
DROP TABLE IF EXISTS #OrdersCSV;

CREATE TABLE #CustomersCSV
(
    CustomerNaturalKey  varchar(20)  NOT NULL,
    FirstName           varchar(100) NULL,
    LastName            varchar(100) NULL,
    Email               varchar(200) NULL,
    Country             varchar(100) NULL
);

CREATE TABLE #ProductsCSV
(
    ProductNaturalKey   varchar(20)   NOT NULL,
    ProductName         varchar(200)  NULL,
    Category            varchar(100)  NULL,
    ListPrice           varchar(50)   NULL
);

CREATE TABLE #OrdersCSV
(
    OrderNaturalKey     varchar(20)  NOT NULL,
    OrderDate           varchar(50)  NULL,
    CustomerNaturalKey  varchar(20)  NULL,
    ProductNaturalKey   varchar(20)  NULL,
    Quantity            varchar(50)  NULL,
    UnitPrice           varchar(50)  NULL
);
GO

/* 2) Clear raw tables */
TRUNCATE TABLE raw.Customers;
TRUNCATE TABLE raw.Products;
TRUNCATE TABLE raw.Orders;
GO

/* 3) BULK INSERT into temp tables */
BULK INSERT #CustomersCSV
FROM 'D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\data\customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a', -- Windows line endings (CRLF)
    CODEPAGE = '65001',       -- UTF-8
    TABLOCK
);

BULK INSERT #ProductsCSV
FROM 'D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\data\products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    CODEPAGE = '65001',
    TABLOCK
);

BULK INSERT #OrdersCSV
FROM 'D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\data\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/* 4) Insert into raw tables (LoadDts defaults automatically) */
INSERT INTO raw.Customers (CustomerNaturalKey, FirstName, LastName, Email, Country)
SELECT CustomerNaturalKey, FirstName, LastName, Email, Country
FROM #CustomersCSV;

INSERT INTO raw.Products (ProductNaturalKey, ProductName, Category, ListPrice)
SELECT ProductNaturalKey, ProductName, Category, ListPrice
FROM #ProductsCSV;

INSERT INTO raw.Orders (OrderNaturalKey, OrderDate, CustomerNaturalKey, ProductNaturalKey, Quantity, UnitPrice)
SELECT OrderNaturalKey, OrderDate, CustomerNaturalKey, ProductNaturalKey, Quantity, UnitPrice
FROM #OrdersCSV;
GO

/* 5) Quick rowcount check */
SELECT COUNT(*) AS Customers FROM raw.Customers;
SELECT COUNT(*) AS Products  FROM raw.Products;
SELECT COUNT(*) AS Orders    FROM raw.Orders;
GO
