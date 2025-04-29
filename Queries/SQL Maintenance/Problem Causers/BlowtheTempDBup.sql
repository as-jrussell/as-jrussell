USE ThePlayPen;
GO

IF OBJECT_ID('dbo.LabBigData') IS NOT NULL DROP TABLE dbo.LabBigData;

CREATE TABLE dbo.LabBigData (
    ID INT IDENTITY(1,1),
    Name NVARCHAR(100),
    Value1 INT,
    Value2 INT,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Populate with data
INSERT INTO dbo.LabBigData (Name, Value1, Value2)
SELECT TOP (100000) 
    'TestName' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR),
    ABS(CHECKSUM(NEWID()) % 1000),
    ABS(CHECKSUM(NEWID()) % 1000)
FROM sys.all_objects a CROSS JOIN sys.all_objects b;








SET NOCOUNT ON;
GO

IF OBJECT_ID('tempdb..#TempExplode') IS NOT NULL DROP TABLE #TempExplode;
CREATE TABLE #TempExplode (
    ID INT,
    Name NVARCHAR(100),
    Value1 INT,
    Value2 INT,
    CreatedDate DATETIME
);

DECLARE @i INT = 1;
WHILE @i <= 50000
BEGIN
    INSERT INTO #TempExplode
    SELECT * FROM dbo.LabBigData;
    SET @i += 1;
END
