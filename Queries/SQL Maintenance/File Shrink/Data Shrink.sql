DECLARE @sqlcmd       VARCHAR(max),
        @logicalname NVARCHAR(50) ,
	   @DatabaseName VARCHAR(100) ='',
        @DryRun       INT = 0




select top 1 @logicalname =  name from sys.master_files
where DB_NAME(database_id) = @DatabaseName
AND type_desc = 'ROWS'



SELECT @sqlcmd = '
use [' + @DatabaseName
                 + ']






DECLARE @FileName sysname = N'''
                 + @logicalname
                 + ''';
DECLARE @TargetSize INT = (SELECT 1 + size*8./1024 FROM sys.database_files WHERE name = @FileName);
DECLARE @Factor FLOAT = .999;
 
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
