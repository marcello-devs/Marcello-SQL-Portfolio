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

- Clustered index scan replaced by index seek
- Logical reads significantly reduced
- Query execution time improved

Screenshots available in screenshots/.

## Key Concepts Demonstrated

- Execution plan analysis
- Index design
- Covering indexes
- IO statistics
