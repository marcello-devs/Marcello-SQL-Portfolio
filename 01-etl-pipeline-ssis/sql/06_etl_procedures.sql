USE PortfolioETL;
GO

/* Simple logging helper: insert STARTED rows, then update with SUCCESS/FAILED */
CREATE OR ALTER PROCEDURE etl.usp_LogStep
    @PipelineName varchar(200),
    @StepName     varchar(200),
    @Status       varchar(30),
    @RowsAffected int = NULL,
    @Message      varchar(4000) = NULL,
    @ETLRunId     bigint = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Status = 'STARTED'
    BEGIN
        INSERT INTO etl.ETLRunLog (PipelineName, StepName, Status, RowsAffected, Message)
        VALUES (@PipelineName, @StepName, @Status, @RowsAffected, @Message);

        SET @ETLRunId = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE etl.ETLRunLog
    SET Status = @Status,
        RowsAffected = COALESCE(@RowsAffected, RowsAffected),
        Message = COALESCE(@Message, Message),
        EndDts = sysdatetime()
    WHERE ETLRunId = @ETLRunId;
END
GO

/* Load typed staging tables from raw (MERGE for upsert behavior) */
CREATE OR ALTER PROCEDURE etl.usp_Load_Staging
AS
BEGIN
    SET NOCOUNT ON;

    -- Customers
    MERGE stg.Customers AS tgt
    USING (
        SELECT
            CustomerNaturalKey,
            NULLIF(LTRIM(RTRIM(FirstName)), '') AS FirstName,
            NULLIF(LTRIM(RTRIM(LastName)), '')  AS LastName,
            NULLIF(LTRIM(RTRIM(Email)), '')     AS Email,
            NULLIF(LTRIM(RTRIM(Country)), '')   AS Country
        FROM raw.Customers
    ) AS src
    ON tgt.CustomerNaturalKey = src.CustomerNaturalKey
    WHEN MATCHED THEN
        UPDATE SET
            FirstName = src.FirstName,
            LastName  = src.LastName,
            Email     = src.Email,
            Country   = src.Country,
            LoadDts   = sysdatetime()
    WHEN NOT MATCHED THEN
        INSERT (CustomerNaturalKey, FirstName, LastName, Email, Country)
        VALUES (src.CustomerNaturalKey, src.FirstName, src.LastName, src.Email, src.Country);

    -- Products
    MERGE stg.Products AS tgt
    USING (
        SELECT
            ProductNaturalKey,
            NULLIF(LTRIM(RTRIM(ProductName)), '') AS ProductName,
            NULLIF(LTRIM(RTRIM(Category)), '')    AS Category,
            TRY_CONVERT(decimal(12,2), NULLIF(LTRIM(RTRIM(ListPrice)), '')) AS ListPrice
        FROM raw.Products
    ) AS src
    ON tgt.ProductNaturalKey = src.ProductNaturalKey
    WHEN MATCHED THEN
        UPDATE SET
            ProductName = src.ProductName,
            Category    = src.Category,
            ListPrice   = src.ListPrice,
            LoadDts     = sysdatetime()
    WHEN NOT MATCHED THEN
        INSERT (ProductNaturalKey, ProductName, Category, ListPrice)
        VALUES (src.ProductNaturalKey, src.ProductName, src.Category, src.ListPrice);

    -- Orders
    MERGE stg.Orders AS tgt
    USING (
        SELECT
            OrderNaturalKey,
            TRY_CONVERT(date, NULLIF(LTRIM(RTRIM(OrderDate)), '')) AS OrderDate,
            NULLIF(LTRIM(RTRIM(CustomerNaturalKey)), '') AS CustomerNaturalKey,
            NULLIF(LTRIM(RTRIM(ProductNaturalKey)), '')  AS ProductNaturalKey,
            TRY_CONVERT(int, NULLIF(LTRIM(RTRIM(Quantity)), '')) AS Quantity,
            TRY_CONVERT(decimal(12,2), NULLIF(LTRIM(RTRIM(UnitPrice)), '')) AS UnitPrice
        FROM raw.Orders
    ) AS src
    ON tgt.OrderNaturalKey = src.OrderNaturalKey
    WHEN MATCHED THEN
        UPDATE SET
            OrderDate          = src.OrderDate,
            CustomerNaturalKey = src.CustomerNaturalKey,
            ProductNaturalKey  = src.ProductNaturalKey,
            Quantity           = src.Quantity,
            UnitPrice          = src.UnitPrice,
            LoadDts            = sysdatetime()
    WHEN NOT MATCHED THEN
        INSERT (OrderNaturalKey, OrderDate, CustomerNaturalKey, ProductNaturalKey, Quantity, UnitPrice)
        VALUES (src.OrderNaturalKey, src.OrderDate, src.CustomerNaturalKey, src.ProductNaturalKey, src.Quantity, src.UnitPrice);
END
GO

/* Load DimDate for a date range */
CREATE OR ALTER PROCEDURE etl.usp_Load_DimDate
    @StartDate date,
    @EndDate   date
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH d AS
    (
        SELECT @StartDate AS [Date]
        UNION ALL
        SELECT DATEADD(day, 1, [Date]) FROM d WHERE [Date] < @EndDate
    )
    INSERT INTO dw.DimDate (DateKey, [Date], [Year], [Month], MonthName)
    SELECT
        CONVERT(int, FORMAT([Date], 'yyyyMMdd')) AS DateKey,
        [Date],
        DATEPART(year, [Date])  AS [Year],
        DATEPART(month, [Date]) AS [Month],
        DATENAME(month, [Date]) AS MonthName
    FROM d
    WHERE NOT EXISTS (SELECT 1 FROM dw.DimDate x WHERE x.[Date] = d.[Date])
    OPTION (MAXRECURSION 32767);
END
GO

/* Load warehouse (dimensions + facts) from staging */
CREATE OR ALTER PROCEDURE etl.usp_Load_Warehouse
AS
BEGIN
    SET NOCOUNT ON;

    -- DimCustomer
    MERGE dw.DimCustomer AS tgt
    USING (
        SELECT
            CustomerNaturalKey,
            CONCAT(
                COALESCE(FirstName,''),
                CASE WHEN FirstName IS NOT NULL AND LastName IS NOT NULL THEN ' ' ELSE '' END,
                COALESCE(LastName,'')
            ) AS FullName,
            Email,
            Country
        FROM stg.Customers
    ) AS src
    ON tgt.CustomerNaturalKey = src.CustomerNaturalKey
    WHEN MATCHED THEN
        UPDATE SET
            FullName = src.FullName,
            Email    = src.Email,
            Country  = src.Country
    WHEN NOT MATCHED THEN
        INSERT (CustomerNaturalKey, FullName, Email, Country)
        VALUES (src.CustomerNaturalKey, src.FullName, src.Email, src.Country);

    -- DimProduct
    MERGE dw.DimProduct AS tgt
    USING (
        SELECT ProductNaturalKey, ProductName, Category, ListPrice
        FROM stg.Products
    ) AS src
    ON tgt.ProductNaturalKey = src.ProductNaturalKey
    WHEN MATCHED THEN
        UPDATE SET
            ProductName = src.ProductName,
            Category    = src.Category,
            ListPrice   = src.ListPrice
    WHEN NOT MATCHED THEN
        INSERT (ProductNaturalKey, ProductName, Category, ListPrice)
        VALUES (src.ProductNaturalKey, src.ProductName, src.Category, src.ListPrice);

    -- DimDate range based on Orders
    DECLARE @minDate date = (SELECT MIN(OrderDate) FROM stg.Orders);
    DECLARE @maxDate date = (SELECT MAX(OrderDate) FROM stg.Orders);

    IF @minDate IS NOT NULL AND @maxDate IS NOT NULL
        EXEC etl.usp_Load_DimDate @minDate, @maxDate;

    -- FactSales (prevent duplicates by OrderNaturalKey + ProductKey)
    INSERT INTO dw.FactSales (OrderNaturalKey, DateKey, CustomerKey, ProductKey, Quantity, UnitPrice)
    SELECT
        o.OrderNaturalKey,
        CONVERT(int, FORMAT(o.OrderDate, 'yyyyMMdd')) AS DateKey,
        c.CustomerKey,
        p.ProductKey,
        ISNULL(o.Quantity, 0) AS Quantity,
        ISNULL(o.UnitPrice, 0) AS UnitPrice
    FROM stg.Orders o
    JOIN dw.DimCustomer c ON c.CustomerNaturalKey = o.CustomerNaturalKey
    JOIN dw.DimProduct  p ON p.ProductNaturalKey  = o.ProductNaturalKey
    WHERE o.OrderDate IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM dw.FactSales f
          WHERE f.OrderNaturalKey = o.OrderNaturalKey
            AND f.ProductKey = p.ProductKey
      );
END
GO

/* One procedure to run the whole pipeline with logging */
CREATE OR ALTER PROCEDURE etl.usp_Run_Pipeline
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @runId bigint = NULL;

    BEGIN TRY
        EXEC etl.usp_LogStep
            @PipelineName = 'ETL Portfolio Pipeline',
            @StepName     = 'Pipeline',
            @Status       = 'STARTED',
            @ETLRunId     = @runId OUTPUT;

        EXEC etl.usp_LogStep
            @PipelineName = 'ETL Portfolio Pipeline',
            @StepName     = 'Load Staging',
            @Status       = 'STARTED',
            @ETLRunId     = @runId OUTPUT;

        EXEC etl.usp_Load_Staging;

        EXEC etl.usp_LogStep
            @PipelineName = 'ETL Portfolio Pipeline',
            @StepName     = 'Load Staging',
            @Status       = 'SUCCESS',
            @ETLRunId     = @runId OUTPUT;

        EXEC etl.usp_LogStep
            @PipelineName = 'ETL Portfolio Pipeline',
            @StepName     = 'Load Warehouse',
            @Status       = 'STARTED',
            @ETLRunId     = @runId OUTPUT;

        EXEC etl.usp_Load_Warehouse;

        EXEC etl.usp_LogStep
            @PipelineName = 'ETL Portfolio Pipeline',
            @StepName     = 'Load Warehouse',
            @Status       = 'SUCCESS',
            @ETLRunId     = @runId OUTPUT;

        EXEC etl.usp_LogStep
            @PipelineName = 'ETL Portfolio Pipeline',
            @StepName     = 'Pipeline',
            @Status       = 'SUCCESS',
            @ETLRunId     = @runId OUTPUT;
    END TRY
    BEGIN CATCH
        DECLARE @msg nvarchar(2048) = ERROR_MESSAGE();
        DECLARE @msg_varchar varchar(4000) = LEFT(CONVERT(varchar(4000), @msg), 4000);

        -- log failure (use variable, no CONVERT inside EXEC)
        EXEC etl.usp_LogStep
            @PipelineName = 'ETL Portfolio Pipeline',
            @StepName     = 'Pipeline',
            @Status       = 'FAILED',
            @Message      = @msg_varchar,
            @ETLRunId     = @runId OUTPUT;

        -- explicit re-throw (semicolon before THROW matters in some parsers)
        ;THROW 50000, @msg, 1;
    END CATCH
END
GO