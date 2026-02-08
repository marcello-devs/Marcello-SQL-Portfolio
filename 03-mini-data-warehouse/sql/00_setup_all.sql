USE master;
GO

PRINT 'Starting full ETL setup...';

:r D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\sql\01_create_db_and_schemas.sql
:r D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\sql\02_create_raw_tables.sql
:r D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\sql\03_create_staging_tables.sql
:r D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\sql\04_create_dw_tables.sql
:r D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\sql\05_create_etl_logging.sql
:r D:\Coding\GitHub\Marcello-SQL-Portfolio\01-etl-pipeline-ssis\sql\06_etl_procedures.sql


PRINT 'Database objects created successfully.';
GO
