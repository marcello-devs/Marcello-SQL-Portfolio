IF DB_ID('PortfolioETL') IS NULL
BEGIN
    CREATE DATABASE PortfolioETL;
END
GO

USE PortfolioETL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'raw') EXEC('CREATE SCHEMA raw');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg') EXEC('CREATE SCHEMA stg');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dw')  EXEC('CREATE SCHEMA dw');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'etl') EXEC('CREATE SCHEMA etl');
GO
