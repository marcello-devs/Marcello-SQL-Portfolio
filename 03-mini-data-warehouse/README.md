# Mini Data Warehouse (Kimball Star Schema)

This project implements a Kimball-style star schema to support analytics reporting.

## Star Schema
- `mart3.FactSales` (grain: one row per order line)
- `mart3.DimCustomer` (SCD Type 2)
- `mart3.DimProduct` (Type 1)
- `mart3.DimDate`

## Why this design? (Source data → Dimensions (SCD handling) → Fact table → Analytics queries)
- Fact table stores measurable events (sales).
- Dimensions provide descriptive context for slicing/reporting.
- Customer is modeled as SCD2 to preserve history when attributes change.

## Analytics examples
- Monthly revenue
- Top customers
- Year-over-year comparison

## How to run
Run scripts in `/sql` in order:
1. `01_create_schema.sql`
2. `02_create_dimensions.sql`
3. `03_create_fact.sql`
4. `04_load_dim_date.sql`
5. `05_load_dim_product.sql`
6. `06_load_dim_customer_scd2.sql`
7. `07_load_fact_sales.sql`
8. `08_analytics_queries.sql`
9. `99_verify.sql`

## SCD Type 2 (DimCustomer)

`mart3.DimCustomer` is modeled as a Slowly Changing Dimension Type 2 to preserve customer attribute history.

### What it means
If a customer attribute changes (e.g., name, email, country), the previous record is **expired** and a new record becomes the **current** version.

### How it works in this project
- Current rows have:
  - `IsCurrent = 1`
  - `ValidToDts = 9999-12-31`
- When a change is detected:
  - the current row is updated to `IsCurrent = 0`
  - `ValidToDts` is set to the current timestamp
  - a new row is inserted with updated attributes and `IsCurrent = 1`

### Demo
A sample change + reload workflow is included in:
- `sql/09_scd2_demo_change.sql`

## SCD Type 2 Demo (Proof)

A controlled change was applied to customer `C001` in the source dimension and the SCD2 load was re-run.

Result:
- Previous customer record was expired (`IsCurrent = 0`)
- New record was inserted as current (`IsCurrent = 1`)
- Validity windows do not overlap

This confirms correct SCD Type 2 behavior.

See proof: `screenshots/scd2_history_C001.png`

## Why SCD Type 2 Matters

In analytical systems, historical accuracy is critical.

Without SCD Type 2, reports would show customer attributes (such as country or name) as they are *today*, even when analyzing past transactions. This leads to incorrect historical reporting.

By implementing SCD Type 2:
- Attribute changes are preserved over time
- Facts remain historically accurate
- Analysts can correctly answer questions like:
  - “What was revenue by country last year?”
  - “How did customer demographics change over time?”

This project demonstrates SCD Type 2 using effective date ranges, surrogate keys, and a single-current-row strategy.

## Indexing Strategy
- Clustered primary key on surrogate keys
- Foreign key indexes to support star-join queries

## Query Performance

Analytics queries were validated using actual execution plans.

- Fact table access uses indexed seeks
- Joins leverage surrogate keys
- Aggregations operate on pre-shaped star schema

See execution plan:
![Execution Plan](screenshots/analytics_execution_plan.png)

## Star Schema

The warehouse follows a Kimball-style star schema optimized for analytical queries.

![Star Schema](screenshots/star_schema.png)
