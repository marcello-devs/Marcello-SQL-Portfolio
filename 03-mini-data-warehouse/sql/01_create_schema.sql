USE PortfolioETL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'mart3')
    EXEC('CREATE SCHEMA mart3');
GO