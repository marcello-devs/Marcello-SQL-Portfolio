# Marcello SQL & Data Engineering Portfolio

This repository contains hands-on projects demonstrating SQL Server data engineering fundamentals, including ETL pipelines, SSIS orchestration, dimensional modeling, logging, and performance tuning.

Each project is designed to mirror real-world production scenarios.

---

## 📁 Project 1 — End-to-End ETL Pipeline (SQL Server + SSIS)

Location: 01-etl-pipeline-ssis/

### Overview

Built a full ETL pipeline using SQL Server with two execution paths:

- **T-SQL execution** (BULK INSERT + stored procedures)
- **SSIS orchestration** (CSV ingestion + pipeline execution)

Both approaches feed the same transformation and warehouse logic.

### Key Features

- Layered architecture: `raw` → `stg` → `dw`
- Star schema warehouse (FactSales + Dimensions)
- Central pipeline stored procedure (`etl.usp_Run_Pipeline`)
- Incremental loading using `MERGE`
- Step-level ETL logging with row counts
- SQLCMD one-click environment setup
- SSIS package for CSV ingestion
- Architecture diagrams and execution screenshots

### Skills Demonstrated

- ETL design patterns
- SQL Server Integration Services (SSIS)
- Dimensional modeling
- Stored procedure pipelines
- Logging frameworks
- SQLCMD automation

---

## 📁 Project 2 — SQL Server Performance Tuning

Location: 02-performance-tuning/

### Overview

Demonstrates identifying and resolving a slow reporting query using execution plan analysis and indexing.

### Key Features

- Test data generation (200k rows)
- Slow aggregation query baseline
- Execution plan analysis
- Covering index design
- Before/after performance comparison

### Skills Demonstrated

- Execution plan interpretation
- Logical IO analysis
- Index strategy
- Query optimization
- Performance documentation

Screenshots show clustered index scans replaced by index seeks with reduced logical reads.

---

## 📁 Project 3 — Mini Data Warehouse (Dimensional Modeling)

Location: 03-mini-data-warehouse/

This project demonstrates a Kimball-style star schema built in SQL Server, focused on analytical querying and dimensional modeling best practices.

### Core model

- FactSales (transaction grain)
- DimCustomer (SCD Type 2)
- DimDate

### What this project demonstrates

- Star schema design for analytics
- Slowly Changing Dimension (SCD Type 2) implementation
- Surrogate keys and natural keys
- Fact-to-dimension relationships
- Analytical queries on top of the warehouse
- Query performance validation using execution plans

### Example analytics

- Monthly revenue trends
- Top customers by revenue
- Year-over-Year (YoY) comparisons

### Why this matters

This project shows how raw transactional data is transformed into a query-optimized analytical model, suitable for BI tools, reporting, and decision support.

📌 See the project README for schema diagrams, SCD2 examples, and performance screenshots.

---

## Tech Stack

- SQL Server Developer Edition
- SSMS
- SSIS (Visual Studio)
- GitHub

---

## About

These projects focus on practical data engineering workflows including ingestion, transformation, warehousing, orchestration, and performance optimization.

They reflect patterns commonly used in production environments.

---

## Next Steps

Planned extensions include:

- Slowly Changing Dimensions (Type 2)
- Data quality checks
- Azure SQL / cloud deployment
- Scheduling and automation
