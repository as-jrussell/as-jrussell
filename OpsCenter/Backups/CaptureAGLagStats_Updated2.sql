USE [PerfStats]
GO

/****** Object:  StoredProcedure [dbo].[CaptureAGLagStats]    Script Date: 2/1/2023 5:18:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Alter Stored Procedure */
CREATE PROCEDURE [dbo].[CaptureAGLagStats] (@DryRun BIT = 1,
                                           @Force  NVARCHAR(1) = 0)
AS

/*

---Shows all AGs this the default @Dryrun = 1, @Force = 0
EXEC [PerfStats].[dbo].[Captureaglagstats]

---View what is broken
EXEC [PerfStats].[dbo].[Captureaglagstats]   @DryRun = 1,  @Force = 1

--Does the work and add to table
EXEC [PerfStats].[dbo].[Captureaglagstats]  @DryRun = 0,  @Force = 1

--Does nothing 
EXEC [PerfStats].[dbo].[Captureaglagstats]  @DryRun = 0,  @Force = 0
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
              @DBName         NVARCHAR(100),
              @enabled        BIT

      /* returns [DB].[SCHEMA].[PROCEDURE] */
      SELECT @ProcedureName = Quotename(Db_name()) + '.'
                              + Quotename(Object_schema_name(@@PROCID, Db_id()))
                              + '.'
                              + Quotename(Object_name(@@PROCID, Db_id()));

      SELECT @Enabled = Isnull([Enabled], 0),/* Default value in seconds */
             /* all thresholds - even if no event defined */
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
           [ServerName]                       VARCHAR(250),
           [DatabaseName - secondary_replica] VARCHAR(250),
           [Is_Suspended]                     INT,
           [group_name]                       VARCHAR(100),
           [availability_mode_desc]           VARCHAR(100),
           [Current_DT]                       DATETIME
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
             @@SERVERNAME,
             p.[DBName] + ' - ' + s.replica_server_name           AS [DatabaseName - secondary_replica],
             p.is_suspended,
             p.AGNAME,
             s.availability_mode_desc,
             Getdate()
      FROM   Pri_CommitTime p
             LEFT JOIN Sec_CommitTime s
                    ON [s].[DBName] = [p].[DBName]
                       AND s.AGNAME = p.AGNAME


      /* Use this to get your schema */
SELECT       @DBName = [DatabaseName - secondary_replica]
      FROM   #AGCheck

      /* create schema */
      IF( @DBName = '' ) -- Maybe AGname not DBname
        BEGIN
            SET @SchemaName = 'dbo'
        END
      ELSE
        BEGIN
            SET @SchemaName = @DBName -- Maybe AGname not DBname
            SET @DBName = @DBName + '.'

            SELECT @query = 'CREATE SCHEMA [' + @SchemaName + '];';

            IF NOT EXISTS (SELECT *
                           FROM   sys.schemas
                           WHERE  name = @SchemaName)
              BEGIN
                  PRINT @query

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
END







	      /* Copy empty template table into Dbname /agname scpecific schema */
set @query = N'SELECT * into PerfStats.[' + @SchemaName
                + '].AGLagStats FROM PerfStats.dbo.AGlagStats WHERE 1=0;'



IF NOT EXISTS (SELECT *
               FROM   INFORMATION_SCHEMA.TABLES
               WHERE  TABLE_SCHEMA = @SchemaName
                      AND TABLE_NAME = 'RowStats') 

    BEGIN
 	      /* If there a table with this with the specific schema not created this will create it */               
DECLARE @sqlcmd          VARCHAR(max)

select @sqlcmd = '
DECLARE  @query AS NVARCHAR(4000),   @SchemaName     NVARCHAR(100)


SELECT @query = N''SELECT * into PerfStats.[' + @SchemaName
                + '].AGLagStats FROM PerfStats.dbo.AGlagStats WHERE 1=0;''
				PRINT ''CREATE TABLE''
EXECUTE sp_executesql @query, N''@SchemaName NVARCHAR(255)'',@SchemaName =@SchemaName'


                  IF( @DryRun = 0 ) AND  (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_SCHEMA = @SchemaName ) IS NULL
                    BEGIN
			  	
				 EXEC( @sqlcmd)
                    END
                  ELSE IF( @DryRun != 0 ) 
                    BEGIN
                     
							PRINT @sqlcmd
                    END
					
              END
   
/* Merge statement  */
DECLARE @SQLMerge   NVARCHAR(4000)
SET @SQLMerge ='
 		   MERGE INTO [PerfStats].['+ @SchemaName +'].[AGLagStats] 
		   AS TARGET
                USING #AGCheck AS SOURCE
                ON (TARGET.[ServerName] = SOURCE.[ServerName] AND TARGET.[Current_DT]  = SOURCE.[Current_DT] )
            WHEN NOT MATCHED AND SOURCE.[seconds behind]  >= '''+@High+'''
                OR SOURCE.[Is_Suspended] = '''+@force+''' -- maybe parameter
            THEN
                INSERT ([seconds behind],    [ServerName],     [DatabaseName - secondary_replica]  ,     [Is_Suspended]  ,  [group_name]   ,   [availability_mode_desc],  [Current_DT] )
                VALUES (SOURCE.[seconds behind],    SOURCE.[ServerName],     SOURCE.[DatabaseName - secondary_replica]  ,     SOURCE.[Is_Suspended] ,   SOURCE.[group_name]  ,    SOURCE.[availability_mode_desc],  SOURCE.[Current_DT] );'

IF( (@DryRun = 1) AND (@Force = 0) )
        BEGIN
             /* Do NOT invoke any change - show only everything */
			SELECT *
            FROM   #AGCheck
			ORDER  BY [seconds behind] DESC

			PRINT (	@SQLMerge )
        END
	ELSE IF( (@DryRun = 1) AND (@Force = 1) )
        BEGIN
            /* Do NOT invoke any change - show only what is broken */
			SELECT *
            FROM   #AGCheck
			WHERE[seconds behind]>= @High OR
			Is_Suspended = @Force
            ORDER  BY [seconds behind] DESC
	       PRINT (	@SQLMerge )
        END
    ELSE IF(@DryRun = 0 AND @force = 1)
        BEGIN
		 /* invoke any change of what is broken */
	EXEC (	@SQLMerge )
         END
   ELSE IF(@DryRun = 0 AND @force = 0)
   BEGIN
               /* Yep you broke the entire database time to put in your resume into Monster.com */
			PRINT 'WARNING: YOU ARE MISSING SOMETHING.......'
	END
	



GO

