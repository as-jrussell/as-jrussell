DECLARE @sqlcmd       VARCHAR(max),
        @Factor       VARCHAR(4) ='.250', --a factor to be applied to the target size for every time DBCC SHRINKFILE is called.
        @DatabaseName VARCHAR(100) ='UiPathInsights'-- Database Name
        ,
        @logicalname  NVARCHAR(100)  --if this blank it pull from below. If there are multiple files on DB you want to use this
        ,
        @TYPE         NVARCHAR(10) = 'ROWS'--rows (databases) , log (logs) 
        ,
        @DryRun       INT = 0 --0 Runs script; 1 shows query

IF @logicalname IS NULL
BEGIN
    SELECT @logicalname = name
    FROM   sys.master_files
    WHERE  Db_name(database_id) = @DatabaseName
           AND type_desc = @Type
END

SELECT @sqlcmd = '
use [' + @DatabaseName
                 + ']






DECLARE @FileName sysname = N'''
                 + @logicalname + ''';
DECLARE @TargetSize INT = (SELECT 1 + size*8./1024 FROM sys.database_files WHERE name = @FileName);
DECLARE @Factor FLOAT = '
                 + @Factor + '
 
WHILE @TargetSize > 0
BEGIN
    SET @TargetSize *= @Factor;
    DBCC SHRINKFILE(@FileName, @TargetSize);
    DECLARE @msg VARCHAR(200) = CONCAT(''Shrink file completed. Target Size: '', 
         @TargetSize, '' MB. Timestamp: '',  CURRENT_TIMESTAMP );
    RAISERROR(@msg, 1, 1) WITH NOWAIT;
    WAITFOR DELAY ''00:00:01'';
END;'


 IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
