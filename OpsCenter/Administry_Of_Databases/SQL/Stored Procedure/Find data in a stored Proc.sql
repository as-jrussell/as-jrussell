DECLARE @SQL VARCHAR(max)
DECLARE @username NVARCHAR(200)
DECLARE @DatabaseName SYSNAME
DECLARE @DBName SYSNAME =''
DECLARE @definition VARCHAR(150) = 'select transaction_id from sys.dm_tran_current_transaction';
DECLARE @type_desc VARCHAR(150) = '';
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
DECLARE @Verbose INT =0 --1 preview / 0 executes it 


IF OBJECT_ID(N'tempdb..#TableFileSize') IS NOT NULL
        DROP TABLE #TableFileSize;

    CREATE TABLE #TableFileSize (
        [DatabaseName] VARCHAR(100),
        [O_Name] VARCHAR(100),
        [Module_Name] VARCHAR(100),
        [Object_Name] VARCHAR(100),
        [type_desc] VARCHAR(100)
    );
/* 
-- In a world the DBA maintenance tables doesn't exist this can be used. 
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
ORDER  BY database_id
*/


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
      SELECT DatabaseName,
             0 -- SELECT *
      FROM   [DBA].[backup].[Schedule]  S
	  join sys.databases D on S.DatabaseName = D.name

      -- Loop through the remaining databases
      WHILE EXISTS(SELECT *
                   FROM   #TempDatabases
                   WHERE  IsProcessed = 0)
        BEGIN
            -- Fetch 1 DatabaseName where IsProcessed = 0
            SELECT TOP 1 @DatabaseName = DatabaseName
            FROM   #TempDatabases
            WHERE  IsProcessed = 0

            -- Prepare SQL Statement
            SELECT @SQL = '
USE [' + @DatabaseName
                          + ']
INSERT INTO #TableFileSize
 SELECT DISTINCT
    DB_NAME() AS DatabaseName,
    OBJECT_NAME(o.object_id),
    OBJECT_NAME(m.object_id),
    o.name AS Object_Name,
    o.type_desc
FROM sys.sql_modules m
INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE m.definition LIKE ''%' + @definition + '%'' 
  AND o.type_desc LIKE ''%' + @type_desc + '%''
'



            -- You know what we do here if it's 1 then it'll give us code and 0 executes it
            IF @DryRun = 0
              BEGIN
                  PRINT ( @DatabaseName )

                  EXEC ( @SQL)
              END
            ELSE
              BEGIN
                  PRINT ( @SQL )
              END

            -- Update table
            UPDATE #TempDatabases
            SET    IsProcessed = 1
            WHERE  DatabaseName = @databaseName
        END




IF @Verbose = 0
BEGIN 
  select *
  From #TableFileSize
  WHERE DatabaseName LIKE '%'+@DBName+'%'
END