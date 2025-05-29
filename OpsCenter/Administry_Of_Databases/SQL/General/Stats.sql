DECLARE @sqlcmd VARCHAR(max),
        @Date   VARCHAR(20) = '2022-09-12',
        @Stats  VARCHAR(1)= '3',--1 Just Auto Created Stats, 2 Just SQL Server Stats, 3 both 
        @DryRun INT = 0

SELECT @sqlcmd = '	USE [?]
SELECT DB_NAME(), OBJECT_NAME(stat.object_id),
sp.stats_id, 
       name, 
       filter_definition, 
       last_updated, 
       rows, 
       rows_sampled, 
       steps, 
       unfiltered_rows, 
       modification_counter
FROM sys.stats AS stat
     CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp'

IF @DryRun = 0
  BEGIN
      IF Object_id(N'tempdb..#stats') IS NOT NULL
        DROP TABLE #stats

      CREATE TABLE #stats
        (
           [DatabaseName]         NVARCHAR(250),
           [TableName]            NVARCHAR(250),
           [stats_id]             INT,
           [Stats_Name]           NVARCHAR(250),
           [Filter_Definition]    NVARCHAR(250),
           [Last Updated]         DATETIME,
           [Rows]                 INT,
           [Rows_Sampled]         INT,
           [Steps]                INT,
           [Unfiltered_Rows]      INT,
           [Modification_Counter] INT
        )

      INSERT INTO #stats
      EXEC Sp_msforeachdb
        @SQLcmd

      IF @Stats = 1
        BEGIN
            SELECT *
            FROM   #stats
            WHERE  [Stats_Name] LIKE '_WA%'
                   AND [Last Updated] >= @date
        END

      IF @Stats = 2
        BEGIN
            SELECT *
            FROM   #stats
            WHERE  [Stats_Name] NOT LIKE '_WA%'
                   AND [Last Updated] >= @date
        END

      IF @Stats = 3
        BEGIN
            SELECT *
            FROM   #stats
            WHERE  [Last Updated] >= @date
        END
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
