USE [PerfStats]
GO
/****** Object:  StoredProcedure [dbo].[CaptureAGLagStats]    Script Date: 1/16/2023 2:03:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CaptureAGLagStats]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CaptureAGLagStats] AS RETURN 0;';
END;
GO


/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[CaptureAGLagStats] ( @WhatIF BIT = 1 )
AS 
BEGIN

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

  DECLARE @Seconds  INT,
          @Source    varchar(1),
		  @JobName      NVARCHAR(100)='CaptureAGLagStats'


    SELECT @Seconds = [Seconds],
             @Source = [Source]
      FROM  [PerfStats].[dbo].[PurgeConfig]
      WHERE  JobName = @JobName
             

;
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
       LEFT JOIN Sec_CommitTime s
              ON [s].[DBName] = [p].[DBName]
                 AND s.AGNAME = p.AGNAME
				 WHERE P.is_suspended = @Source OR Datediff(ss, s.last_commit_time, p.last_commit_time) = @Seconds

    IF( @WhatIF = 1 )
        BEGIN
            /* Do NOT invoke any change - display what would happen */
			      SELECT *
      FROM   #AGCheck
      ORDER  BY [seconds behind] DESC
        END
    ELSE
        BEGIN
            /* Invoke changes */
               MERGE PerfSTats.dbo.AGLagStats AS TARGET
  USING #AGCheck AS SOURCE
  ON (TARGET.[ServerName] = SOURCE.[ServerName] AND TARGET.[Current_DT]  = SOURCE.[Current_DT] )
  WHEN NOT MATCHED AND SOURCE.[seconds behind] <> @Seconds
  OR SOURCE.[Is_Suspended] <> @Source
 THEN
  INSERT ([seconds behind],    [ServerName],     [DatabaseName - secondary_replica]  ,     [Is_Suspended]  ,  [group_name]   ,   [availability_mode_desc],  [Current_DT] ) 
 VALUES (SOURCE.[seconds behind],    SOURCE.[ServerName],     SOURCE.[DatabaseName - secondary_replica]  ,     SOURCE.[Is_Suspended] ,   SOURCE.[group_name]  ,    SOURCE.[availability_mode_desc],  SOURCE.[Current_DT] );
 END
   
        END




