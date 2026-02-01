# SSIS Package - Portfolio ETL

This folder contains the SSIS solution used to orchestrate CSV ingestion and execute the SQL ETL pipeline.

SSIS is responsible only for:

- Truncating raw tables
- Loading CSV files into raw.*
- Executing etl.usp_Run_Pipeline

All transformations occur inside SQL Server.

---

## Control Flow

1. Execute SQL Task - Truncate raw tables
2. Data Flow - Customers CSV → raw.Customers
3. Data Flow - Products CSV → raw.Products
4. Data Flow - Orders CSV → raw.Orders
5. Execute SQL Task - Run etl.usp_Run_Pipeline

Each CSV is loaded in its own Data Flow task.

---

## Prerequisites

- SQL Server running locally (localhost)
- PortfolioETL database created
- CSV files present in:

    01-etl-pipeline-ssis/data/

Files:

- customers.csv
- products.csv
- orders.csv

---

## How to Run

1. Open the solution in:

    ssis/PortfolioETL-SSIS/

2. Press Start in Visual Studio.

---

## Verify

After execution:

    SELECT TOP 10 * FROM etl.ETLRunLog ORDER BY ETLRunId DESC;
    SELECT COUNT(*) FROM dw.FactSales;

---

Screenshots are available in:

    screenshots/ssis/
