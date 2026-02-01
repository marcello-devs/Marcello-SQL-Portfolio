# ETL Pipeline (CSV → Raw → Staging → Warehouse)

This project demonstrates a simple end-to-end ETL pipeline using SQL Server.

## Architecture
**CSV files** → `raw` (landing) → `stg` (typed/cleaned) → `dw` (star schema)  
Logging is captured in `etl.ETLRunLog`.

## What it shows
- Raw landing tables (text-first ingestion)
- Typed staging tables with data cleansing (`TRY_CONVERT`, trimming, null-handling)
- Dimensional model (star schema): `DimCustomer`, `DimProduct`, `DimDate`, `FactSales`
- Incremental loads via `MERGE` (upsert pattern)
- Pipeline logging (started/success/failed + row counts)

## How to run
1. Run scripts in order from `sql/`:
   - `01_create_db_and_schemas.sql`
   - `02_create_raw_tables.sql`
   - `03_create_staging_tables.sql`
   - `04_create_dw_tables.sql`
   - `05_create_etl_logging.sql`
   - `06_etl_procedures.sql`
   - `07_bulk_load_raw.sql`
2. Execute the pipeline:
   ```sql
   EXEC etl.usp_Run_Pipeline;
