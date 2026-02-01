USE PortfolioETL;
GO

DROP TABLE IF EXISTS etl.ETLRunLog;
GO

CREATE TABLE etl.ETLRunLog
(
    ETLRunId        bigint IDENTITY(1,1) PRIMARY KEY,
    PipelineName    varchar(200)  NOT NULL,
    StepName        varchar(200)  NOT NULL,
    Status          varchar(30)   NOT NULL, -- STARTED, SUCCESS, FAILED
    RowsAffected    int           NULL,
    Message         varchar(4000) NULL,
    StartDts        datetime2(0)  NOT NULL DEFAULT sysdatetime(),
    EndDts          datetime2(0)  NULL
);
GO
