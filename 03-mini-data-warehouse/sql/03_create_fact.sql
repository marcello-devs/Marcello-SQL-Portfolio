USE PortfolioETL;
GO

DROP TABLE IF EXISTS mart3.FactSales;
GO

CREATE TABLE mart3.FactSales
(
    SalesKey          BIGINT IDENTITY(1,1) PRIMARY KEY,
    DateKey           INT NOT NULL,
    CustomerKey       INT NOT NULL,           -- FK to mart3.DimCustomer (SCD2)
    ProductKey        INT NOT NULL,           -- FK to mart3.DimProduct (Type 1)
    OrderNaturalKey   VARCHAR(20) NOT NULL,   
    Quantity          INT NOT NULL,
    UnitPrice         DECIMAL(12,2) NULL,     
    SalesAmount       DECIMAL(23,2) NOT NULL, -- store value (dw is computed)
    LoadDts           DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_mart3FactSales_Date     FOREIGN KEY (DateKey)     REFERENCES mart3.DimDate(DateKey),
    CONSTRAINT FK_mart3FactSales_Customer FOREIGN KEY (CustomerKey) REFERENCES mart3.DimCustomer(CustomerKey),
    CONSTRAINT FK_mart3FactSales_Product  FOREIGN KEY (ProductKey)  REFERENCES mart3.DimProduct(ProductKey)
);
GO
