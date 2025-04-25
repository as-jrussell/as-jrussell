DECLARE @sqlcmd       VARCHAR(max),
        @sqlcmdforce  VARCHAR(max),
        @logicalname  NVARCHAR(100),
        @DatabaseName VARCHAR(100),
        @Factor       VARCHAR(4) ='.250',--a factor to be applied to the target size for every time DBCC SHRINKFILE is called.
        @SIZE         NVARCHAR(100) = 1024,--size of temp file in MB
        @TYPE         NVARCHAR(10) = 'ROWS'--rows (databases) , log (logs) 
        ,
        @Force        INT = 0 --0 Runs script. PLEASE ONLY USE AS NECESSARY DOING THIS WILL REMOVE ANY AND ALL TEMP FILES CURRENTLY ON DRIVE
        ,
        @DryRun       INT = 0 --0 Runs script; 1 shows query
SELECT @DatabaseName = name
FROM   sys.databases
WHERE  database_id = (SELECT Db_id('tempdb'))

-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases

CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed  BIT
  )

-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases
            (DatabaseName,
             IsProcessed)
SELECT name,
       0 -- SELECT *
FROM   sys.master_files
WHERE  database_id = (SELECT Db_id('tempdb'))
       AND type_desc = @TYPE
ORDER  BY database_id

IF @logicalname IS NULL
  BEGIN
      WHILE EXISTS(SELECT *
                   FROM   #TempDatabases
                   WHERE  IsProcessed = 0)
        BEGIN
            -- Fetch 1 DatabaseName where IsProcessed = 0
            SELECT TOP 1 @logicalname = DatabaseName
            FROM   #TempDatabases
            WHERE  IsProcessed = 0

            SELECT @sqlcmdforce = '
use [' + @DatabaseName + ']


	DBCC FREEPROCCACHE
	DBCC DROPCLEANBUFFERS 
	DBCC FREESYSTEMCACHE (''ALL'')
	DBCC FREESESSIONCACHE



	 DBCC SHRINKFILE(''' + @logicalname + ''',' + @size
                             + ')

'

            SELECT @sqlcmd = '
use [' + @DatabaseName
                             + ']

ALTER DATABASE TempDB MODIFY FILE (NAME = '''
                             + @logicalname + ''', SIZE = ' + @size
                             + 'MB);


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

            IF @Force = 0
               AND @DryRun = 0
              BEGIN
                  EXEC ( @sqlcmdforce)
              END
			  ELSE
			                BEGIN
                  PRINT ( @sqlcmdforce)
              END

            IF @DryRun = 0
              BEGIN
                  PRINT ( @logicalname )

                --  EXEC ( @SQLcmd)
              END
            ELSE
              BEGIN
                  PRINT ( @SQLcmd )

                  PRINT ( @logicalname )
              END

            --   -- Update table
            UPDATE T
            SET    IsProcessed = 1 --SELECT *
            FROM   #TempDatabases T
            WHERE  DatabaseName = @logicalname
        END
  END 
