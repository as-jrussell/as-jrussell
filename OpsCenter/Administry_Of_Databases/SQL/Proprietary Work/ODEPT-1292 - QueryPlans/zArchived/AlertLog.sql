use PerfStats


IF NOT EXISTS (
    SELECT * 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[AlertLog]') 
    AND type in (N'U')
)
BEGIN
    CREATE TABLE AlertLog (
        AlertID INT IDENTITY(1,1) PRIMARY KEY,
        QueryID UNIQUEIDENTIFIER,
        AlertTime DATETIME DEFAULT GETDATE(),
        AlertType VARCHAR(255),
        AlertDetails VARCHAR(MAX)
    );
    PRINT 'AlertLog table created.';
END
ELSE
BEGIN
    PRINT 'AlertLog table already exists.';
END;
