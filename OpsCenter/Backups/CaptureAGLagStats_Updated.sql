USE [PerfStats]
GO

/****** Object:  StoredProcedure [dbo].[CaptureAGLagStats]    Script Date: 1/20/2023 12:41:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/* Alter Stored Procedure */
CREATE OR ALTER PROCEDURE [dbo].[CaptureAGLagStats] ( @WhatIF BIT = 1, @Force BIT = 0 )
AS 
BEGIN
    /* if we caputre on DB level proceudre should be called CaptureDBLagStats */

    /* moved declares and defining SELECT statements to top */
    DECLARE @enabled  BIT,
            @broken [nvarchar](100),
            @normal [nvarchar](100),
            @info [nvarchar](100),
            @low [nvarchar](100),
            @medium [nvarchar](100),
            @high [nvarchar](100),
            @UnitsOfMeasure nvarchar(10),
            @ProcedureName NVARCHAR(128)

    /* returns [DB].[SCHEMA].[PROCEDURE] */
    SELECT @ProcedureName
        = QUOTENAME(DB_NAME()) + '.' + QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID, DB_ID())) + '.'
          + QUOTENAME(OBJECT_NAME(@@PROCID, DB_ID()));

    SELECT  @Enabled = IsNull([Enabled], 0),  /* Default value in seconds */
            /* all thresholds - even if no event defined */
            @high = IsNull([High], 900) 
            /* event levels: broken , normal, infor, low, med , high! */
    FROM  [PerfStats].[dbo].[ThresholdConfig]
    WHERE [EventName] = @ProcedureName 

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
	     [Current_DT] datetime
      );

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
           s.availability_mode_desc, GETDATE()
    FROM   Pri_CommitTime p
           LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName] AND s.AGNAME = p.AGNAME
    WHERE P.is_suspended = 1 -- maybe parameter
        OR Datediff(ss, s.last_commit_time, p.last_commit_time) = @High
	--WHERE P.is_suspended = @Source OR Datediff(ss, s.last_commit_time, p.last_commit_time) = @Seconds


    /* We may need to create a new schema to store database specific information MAybe AGName not DB name
    	IF( @DBName = '' ) -- Maybe AGname not DBname
		BEGIN
			SET @SchemaName = 'dbo'
		END
	ELSE
		BEGIN
			SET @SchemaName = @DBName -- Maybe AGname not DBname
			SET @DBName = @DBName +'.'
			SELECT @query = 'CREATE SCHEMA ['+ @SchemaName +'];';
			IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = @SchemaName)
			BEGIN
				PRINT @query
				IF( @DryRun = 0) EXEC( @query)
			END
		END
    -- Copy empty template table into Dbname /agname scpecific schema
    SELECT @query = N'SELECT * into PerfStats.'+ @SchemaName +'.AGLagStats FROM PerfStats.PerfStats.AGlagStats WHERE 1=0;'
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @SchemaName AND  TABLE_NAME = 'RowStats')
    BEGIN
	    Print @query
	    IF( @DryRun = 0) EXEC sp_executesql @query, N'@SchemaName nvarchar(128)', @SchemaName
    END 
    
    -- Merge into PerfStats.'+ @SchemaName +'.AGLagStats
        
    
    */


    IF( (@WhatIF = 1) OR (@Enabled = 0) )
        BEGIN
            /* Do NOT invoke any change - display what would happen */
			SELECT *
            FROM   #AGCheck
            ORDER  BY [seconds behind] DESC
        END
    ELSE IF( (@WhatIF = 0) OR (@Enabled = 1) OR (@force = 1) )
        BEGIN
            /* Invoke changes */
            MERGE PerfSTats.dbo.AGLagStats AS TARGET
                USING #AGCheck AS SOURCE
                ON (TARGET.[ServerName] = SOURCE.[ServerName] AND TARGET.[Current_DT]  = SOURCE.[Current_DT] )
            WHEN NOT MATCHED AND SOURCE.[seconds behind] <> @High
                OR SOURCE.[Is_Suspended] <> 1 -- maybe parameter
            THEN
                INSERT ([seconds behind],    [ServerName],     [DatabaseName - secondary_replica]  ,     [Is_Suspended]  ,  [group_name]   ,   [availability_mode_desc],  [Current_DT] ) 
                VALUES (SOURCE.[seconds behind],    SOURCE.[ServerName],     SOURCE.[DatabaseName - secondary_replica]  ,     SOURCE.[Is_Suspended] ,   SOURCE.[group_name]  ,    SOURCE.[availability_mode_desc],  SOURCE.[Current_DT] );
         END
   
END




GO

