IF NOT EXISTS (
    SELECT * 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[QueryPlanHistory]') 
    AND type in (N'U')
)
BEGIN
    CREATE TABLE QueryPlanHistory (
        QueryID UNIQUEIDENTIFIER DEFAULT NEWID(),
        PlanID VARBINARY(64),
        DatabaseName VARCHAR(255),
        QueryText VARCHAR(MAX),
        ExecutionCount INT,
        ProcedureName VARCHAR(255),
        ExecutionTime DATETIME DEFAULT GETDATE(),
        QueryPlan XML,
        PRIMARY KEY (QueryID)
    );
    PRINT 'QueryPlanHistory table created.';
END
ELSE
BEGIN
    PRINT 'QueryPlanHistory table already exists.';
END;
