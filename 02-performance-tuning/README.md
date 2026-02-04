# SQL Server Performance Tuning

This project demonstrates identifying and resolving a slow query using execution plans and indexing.

## Scenario

A reporting query on a 200k-row table performed a full scan and showed high logical reads.

## Steps

1. Generate test data
2. Run slow aggregation query
3. Capture execution plan (before)
4. Add covering index
5. Re-run query and compare

## Results

After adding a covering index on `OrderDate`:

- Clustered Index Scan was replaced with an Index Seek
- Logical reads were significantly reduced
- Query execution time improved noticeably

This demonstrates how targeted indexing based on execution plan analysis can dramatically improve query performance in reporting workloads.

Before and after execution plans and statistics are available in the `screenshots/` folder.

## Key Concepts Demonstrated

- Execution plan analysis
- Index design
- Covering indexes
- IO statistics
