USE [PerfStats]
GO
/****** Object:  StoredProcedure [dbo].[CaptureAGLagStats]    Script Date: 2/3/2023 2:30:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[CaptureAGLagStats] (@DryRun BIT = 1, @Force BIT = 0)
AS

/*

---Shows all AGs this the default @Dryrun = 1
EXEC [PerfStats].[dbo].[CaptureAGlagstats]

--Does extra work - like auto healing
EXEC [PerfStats].[dbo].[CaptureAGlagstats]  @DryRun = 0,  @Force = 1

-- shows but does nothing 
EXEC [PerfStats].[dbo].[CaptureAGlagstats]  @DryRun = 0, 
*/


  BEGIN
  /* if we caputre on DB level proceudre should be called CaptureDBLagStats */
      /* moved declares and defining SELECT statements to top */
      DECLARE @query          VARCHAR(max),
              @broken         NVARCHAR(100),
              @normal         NVARCHAR(100),
              @info           NVARCHAR(100),
              @low            NVARCHAR(100),
              @medium         NVARCHAR(100),
              @high           NVARCHAR(100),
              @UnitsOfMeasure NVARCHAR(10),
              @ProcedureName  NVARCHAR(128),
              @SchemaName     NVARCHAR(100),
              @AGName         NVARCHAR(100),
              @enabled        BIT

      DECLARE @sqlcmd          VARCHAR(max)
      /* returns [DB].[SCHEMA].[PROCEDURE] */
      SELECT @ProcedureName = Quotename(Db_name()) + '.'
                              + Quotename(Object_schema_name(@@PROCID, Db_id()))
                              + '.'
                              + Quotename(Object_name(@@PROCID, Db_id()));

      SELECT @Enabled = [Enabled],
             /* all thresholds from DPA - even if not defined for event */
             @info =  Isnull([info], 900), /* Default value in seconds */
			 @low = Isnull([low], 1800),
			 @medium = Isnull([medium], 3600),
             @high = Isnull([high], 7200)
      /* event levels: broken , normal, infor, low, med , high! */
      --select *
      FROM   [PerfStats].[dbo].[ThresholdConfig]
      WHERE  [EventName] = @ProcedureName

      /* create Source table */
      IF Object_id(N'tempdb..#AGCheck') IS NOT NULL
        DROP TABLE #AGCheck

      CREATE TABLE #AGCheck
        (
           [seconds behind]                   INT,
           [Threshold_Level]                  VARCHAR(250),
           [ServerName]                       VARCHAR(250),
           [DatabaseName - secondary_replica] VARCHAR(250),
           [Is_Suspended]                     INT,
           [group_name]                       VARCHAR(100),
           [availability_mode_desc]           VARCHAR(100),
           [Current_DT]                       DATETIME,
           [IsProcessed]                      BIT
        );

  ;      /* resource information that is being pulled int the source table */
      WITH AG_Stats
           AS (SELECT AR.replica_server_name,
                      AG.name                  AS AGName,
                      HARS.role_desc,
                      Db_name(DRS.database_id) [DBName],
                      DRS.last_commit_time,
                      DRS.is_suspended,
                      AR.availability_mode_desc
               FROM   sys.dm_hadr_database_replica_states DRS
                      INNER JOIN sys.availability_replicas AR
                              ON DRS.replica_id = AR.replica_id
                      INNER JOIN sys.dm_hadr_availability_replica_states HARS
                              ON AR.group_id = HARS.group_id
                                 AND AR.replica_id = HARS.replica_id
                      INNER JOIN [sys].[availability_groups] AG
                              ON AG.group_id = AR.group_id),
           Pri_CommitTime
           AS (SELECT replica_server_name,
                      AGNAME,
                      DBName,
                      last_commit_time,
                      is_suspended,
                      availability_mode_desc
               FROM   AG_Stats
               WHERE  role_desc = 'PRIMARY'),
           Sec_CommitTime
           AS (SELECT replica_server_name,
                      AGNAME,
                      DBName,
                      last_commit_time,
                      is_suspended,
                      availability_mode_desc
               FROM   AG_Stats
               WHERE  role_desc = 'SECONDARY')
      INSERT INTO #AGCheck
      SELECT Datediff(ss, s.last_commit_time, p.last_commit_time) AS [Seconds Behind],
            CASE WHEN  Datediff(ss, s.last_commit_time, p.last_commit_time) <= @info THEN 'Info'
			WHEN  Datediff(ss, s.last_commit_time, p.last_commit_time) BETWEEN @info AND @low THEN 'Low'
			WHEN  Datediff(ss, s.last_commit_time, p.last_commit_time) BETWEEN @low AND @medium THEN 'Medium'
			WHEN  Datediff(ss, s.last_commit_time, p.last_commit_time) BETWEEN @medium AND @high THEN 'High'
			WHEN  Datediff(ss, s.last_commit_time, p.last_commit_time) >= @high THEN 'High'
			END AS 	'Threshold level',
             @@SERVERNAME,
             p.[DBName] + ' - ' + s.replica_server_name           AS [DatabaseName - secondary_replica],
             p.is_suspended,
             p.AGNAME,
             s.availability_mode_desc,
             Getdate(),
             0 -- IsProcessed
      FROM   Pri_CommitTime p
             LEFT JOIN Sec_CommitTime s
                    ON [s].[DBName] = [p].[DBName]
                       AND s.AGNAME = p.AGNAME

/* 
    If LAG is greater than a threshold 
    Create Scheam
    Create empty table
    Record 
*/

    /* Trim the waste */
    UPDATE #AGCheck SET IsProcessed = 1 WHERE [seconds behind] = 0

    WHILE EXISTS ( SELECT [group_name] FROM #AGCheck WHERE IsProcessed != 1 )
    BEGIN
        /* Use this to get your schema */
        SELECT TOP 1 @AGName = [group_name]
        FROM   #AGCheck
        WHERE IsProcessed != 1

        /* create schema */
        IF( @AGName = '' ) -- Maybe AGname not DBname
            BEGIN
                SET @SchemaName = 'dbo'
            END
        ELSE
            BEGIN
                SET @SchemaName = @AGName -- group_name


                SELECT @query = 'CREATE SCHEMA [' + @SchemaName + '];';

                IF NOT EXISTS (SELECT *
                               FROM   sys.schemas
                               WHERE  name = @SchemaName)
                BEGIN
                    IF( @DryRun = 0 )
                        BEGIN
                            EXEC( @query)
                        END
                    ELSE
                        BEGIN
                            PRINT @query
                        END
                END
            END

        /* Copy empty template table into Dbname /agname scpecific schema */
        set @sqlcmd = N'SELECT * into PerfStats.[' + @SchemaName + '].AGLagStats FROM PerfStats.PerfStats.AGlagStats WHERE 1=0;'


        IF NOT EXISTS (SELECT *
               FROM   INFORMATION_SCHEMA.TABLES
               WHERE  TABLE_SCHEMA = @SchemaName
                      AND TABLE_NAME = 'AGlagStats') 

            BEGIN
 	          /* If there a table with this with the specific schema not created this will create it */               


                    IF( @DryRun = 0 )
                        BEGIN
				            EXEC( @sqlcmd)
                        END
                    ELSE IF( @DryRun != 0 ) 
                        BEGIN
					        PRINT @sqlcmd
                        END
					
                END
            ELSE
                BEGIN
                    IF( @DryRun =1 ) PRINT 'Schema exists: '+ @SchemaName
                END

        /* udpate temp table */
        UPDATE #AGCheck
        SET IsProcessed = 1
        WHERE IsProcessed != 1 AND [group_name] = @AGName

    END --WHILE EXISTS ( SELECT [group_name] FROM #AGCheck WHERE IsProcessed != 1 )




   
/* Merge statement  */
DECLARE @SQLMerge   NVARCHAR(4000)
SET @SQLMerge ='
 		   MERGE INTO [PerfStats].['+ @SchemaName +'].[AGLagStats] 
		   AS TARGET
                USING #AGCheck AS SOURCE
                ON (TARGET.[ServerName] = SOURCE.[ServerName] AND TARGET.[Current_DT]  = SOURCE.[Current_DT] )
            WHEN NOT MATCHED AND SOURCE.[seconds behind]  >= '''+@low+'''
                        THEN
                INSERT ([seconds behind], [Threshold_Level],  [ServerName],     [DatabaseName - secondary_replica]  ,     [Is_Suspended]  ,  [group_name]   ,   [availability_mode_desc],  [Current_DT] )
                VALUES (SOURCE.[seconds behind], SOURCE.[Threshold_Level],    SOURCE.[ServerName],     SOURCE.[DatabaseName - secondary_replica]  ,     SOURCE.[Is_Suspended] ,   SOURCE.[group_name]  ,    SOURCE.[availability_mode_desc],  SOURCE.[Current_DT] );'

 IF (@DryRun = 1)
        BEGIN
            /* Do NOT invoke any change - show only what is broken */
			SELECT *
            FROM   #AGCheck
			ORDER  BY [seconds behind] DESC
	       PRINT (	@SQLMerge )
        END
    ELSE IF(@DryRun = 0)
        BEGIN
		 /* invoke any change of what is broken */
	EXEC (	@SQLMerge )
         END
  
	

END;



