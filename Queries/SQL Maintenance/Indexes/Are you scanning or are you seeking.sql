DECLARE @SQL VARCHAR(max)
DECLARE @DatabaseName SYSNAME ='';
DECLARE  @TableName    VARCHAR(255) =''
DECLARE	@IndexName  VARCHAR(255) =''
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
DECLARE @Verbose INT =0 --1 preview / 0 executes it 


IF Object_id(N'tempdb..#IndexStats') IS NOT NULL
    DROP TABLE #IndexStats;

CREATE TABLE #IndexStats (
	DatabaseName sysname,
    TableName sysname,
    IndexName sysname,
    IndexType nvarchar(60),
    IndexSizeKB bigint,
    NumOfSeeks bigint,
    NumOfScans bigint,
    NumOfLookups bigint,
    NumOfUpdates bigint,
    LastSeek datetime,
    LastScan datetime,
    LastLookup datetime,
    LastUpdate datetime
);


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
SELECT name, 0 -- SELECT *
FROM   sys.databases
ORDER  BY database_id

            -- Prepare SQL Statement
SELECT @SQL = ' USE ' + @DatabaseName
                 + '
INSERT INTO #IndexStats
SELECT DB_NAME(), 
OBJECT_NAME(IX.OBJECT_ID) Table_Name
	   ,IX.name AS Index_Name
	   ,IX.type_desc Index_Type
	   ,SUM(PS.[used_page_count]) * 8 IndexSizeKB
	   ,IXUS.user_seeks AS NumOfSeeks
	   ,IXUS.user_scans AS NumOfScans
	   ,IXUS.user_lookups AS NumOfLookups
	   ,IXUS.user_updates AS NumOfUpdates
	   ,IXUS.last_user_seek AS LastSeek
	   ,IXUS.last_user_scan AS LastScan
	   ,IXUS.last_user_lookup AS LastLookup
	   ,IXUS.last_user_update AS LastUpdate
FROM sys.indexes IX
INNER JOIN sys.dm_db_index_usage_stats IXUS ON IXUS.index_id = IX.index_id AND IXUS.OBJECT_ID = IX.OBJECT_ID
INNER JOIN sys.dm_db_partition_stats PS on PS.object_id=IX.object_id
WHERE OBJECTPROPERTY(IX.OBJECT_ID,''IsUserTable'') = 1
AND  OBJECT_NAME(IX.OBJECT_ID) IN (''' + @TableName + ''')
AND IX.name LIKE ''%'+ @IndexName + '%''
GROUP BY OBJECT_NAME(IX.OBJECT_ID) ,IX.name ,IX.type_desc ,IXUS.user_seeks ,IXUS.user_scans ,IXUS.user_lookups,IXUS.user_updates ,IXUS.last_user_seek ,IXUS.last_user_scan ,IXUS.last_user_lookup ,IXUS.last_user_update
order by IXUS.user_seeks desc'



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





IF @Verbose = 0 AND @DryRun =0
BEGIN 
  select * From #IndexStats
  WHERE DatabaseName = @DatabaseName
  end 
