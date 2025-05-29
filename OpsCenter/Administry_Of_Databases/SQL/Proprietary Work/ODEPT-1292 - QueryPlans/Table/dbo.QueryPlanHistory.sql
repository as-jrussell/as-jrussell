use PerfStats


IF NOT EXISTS (
    SELECT * 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[QueryPlanHistory]') 
    AND type in (N'U')
)
BEGIN
    CREATE TABLE QueryPlanHistory (
        DatabaseName VARCHAR(255),
        QueryText VARCHAR(MAX),
        ExecutionCount INT,
        [Average_Lapse_Time (µs)] INT,
        AverageRows INT,
        ProcedureName VARCHAR(255),
        CurrentTime DATETIME DEFAULT GETDATE(),
        CreationTime DATETIME DEFAULT GETDATE(),
        ExecutionTime DATETIME DEFAULT GETDATE(),
		QueryID UNIQUEIDENTIFIER DEFAULT NEWID(),
        PlanID VARBINARY(64),
        QueryPlan XML,
        PRIMARY KEY (QueryID)
    );
    PRINT 'QueryPlanHistory table created.';
END
ELSE
BEGIN
    PRINT 'QueryPlanHistory table already exists.';
END;
GO



