USE PerfStats; -- Replace with your database name

GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[CompareQueryPlans]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      -- Create an empty stored procedure if it doesn't exist
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[CompareQueryPlans] AS RETURN 0;';
  END;

GO

ALTER PROCEDURE [dbo].[Comparequeryplans] (@WhatIf               BIT = 1,
                                           @ElapsedTimeThreshold BIGINT = 2000000,
                                           @DatabaseType         NVARCHAR(128) = 'USER')
AS
  BEGIN
  /*
  
  Displays all stored procedures that has changed 
  EXEC [PerfStats].[dbo].[CompareQueryPlans]
  
  Sends email out to groups if stored proc exceeds 2 seconds and is executed mulitple times 
  EXEC [PerfStats].[dbo].[CompareQueryPlans] @WhatIf=0
  
  */
      -- Declare a temporary table to hold the latest query plans
      DECLARE @LatestPlans TABLE
        (
           PlanID         VARBINARY(64),
           DatabaseName   VARCHAR(255),
           QueryText      VARCHAR(MAX),
           ExecutionCount INT,
           ProcedureName  VARCHAR(255),
           ExecutionTime  DATETIME,
           QueryPlan      XML,
           AvgElapsedTime BIGINT
        );

      -- Insert the latest query plans into the temporary table
      INSERT INTO @LatestPlans
      SELECT deqs.plan_handle                                                                                                    AS PlanID,
             Db_name(sqltext.dbid)                                                                                               AS DatabaseName,
             Substring(sqltext.text, ( deqs.statement_start_offset / 2 ) + 1, ( ( CASE deqs.statement_end_offset
                                                                                    WHEN -1 THEN Datalength(sqltext.text)
                                                                                    ELSE deqs.statement_end_offset
                                                                                  END - deqs.statement_start_offset ) / 2 ) + 1) AS QueryText,
             deqs.execution_count                                                                                                AS ExecutionCount,
             COALESCE(Object_name(sqltext.objectid, sqltext.dbid), 'Ad-Hoc Query')                                               AS ProcedureName,
             deqs.last_execution_time                                                                                            AS ExecutionTime,
             Isnull(detqp.query_plan, 'No available Plan')                                                                       AS QueryPlan,
             deqs.last_elapsed_time / deqs.execution_count                                                                       AS AvgElapsedTime
      FROM   sys.dm_exec_query_stats deqs
             CROSS APPLY sys.Dm_exec_sql_text(deqs.sql_handle) sqltext
             CROSS APPLY sys.Dm_exec_query_plan(deqs.plan_handle) detqp
             INNER JOIN sys.databases
                     ON sqltext.dbid = databases.database_id
      WHERE  ( deqs.last_elapsed_time / deqs.execution_count ) > @ElapsedTimeThreshold
             AND Db_name(sqltext.dbid) IN (SELECT DISTINCT DatabaseName
                                           FROM   DBA.INFO.[Database]
                                           WHERE  DatabaseType = @DatabaseType)
										    AND    deqs.execution_count > 1;
      -- Select new query plans with AvgElapsedTime > 500,000 microseconds
      DECLARE @NewPlans TABLE
        (
           PlanID         VARBINARY(64),
           DatabaseName   VARCHAR(255),
           QueryText      VARCHAR(MAX),
           ExecutionCount INT,
           ProcedureName  VARCHAR(255),
           ExecutionTime  DATETIME,
           AvgElapsedTime BIGINT,
           QueryPlan      XML
        );

      INSERT INTO @NewPlans
      SELECT LP.PlanID,
             LP.DatabaseName,
             LP.QueryText,
             LP.ExecutionCount,
             LP.ProcedureName,
             LP.ExecutionTime,
             LP.AvgElapsedTime,
             LP.QueryPlan
      FROM   @LatestPlans LP
             LEFT JOIN dbo.QueryPlanHistory QPH
                    ON LP.PlanID = QPH.PlanID
                       AND LP.QueryText = QPH.QueryText
      WHERE  QPH.PlanID IS NULL
             AND LP.AvgElapsedTime > @ElapsedTimeThreshold;
			
      IF @WhatIF = 1
        BEGIN
            -- Check if there are any new plans that match the criteria
            IF EXISTS (SELECT 1
                       FROM   @NewPlans)
              BEGIN
                  -- Display the new plans that meet the criteria
                  SELECT PlanID,
                         DatabaseName,
                         QueryText,
                         ExecutionCount,
                         ProcedureName,
                         ExecutionTime,
                         AvgElapsedTime,
                         QueryPlan
                  FROM   @NewPlans;

              END;
            ELSE
              BEGIN
                  PRINT 'NO STORED PROCEDURES ARE RUNNING OFF THE BOARD'
              END
        END
      ELSE
        BEGIN
            DECLARE @body NVARCHAR(MAX)
            DECLARE @Verbiage NVARCHAR(200)
            DECLARE @2ndVerbiage NVARCHAR(200)
            DECLARE @Name NVARCHAR(100)
            DECLARE @profile_name NVARCHAR(255)
            DECLARE @recipients NVARCHAR(255)
            DECLARE @FullBody NVARCHAR(MAX)

            SELECT TOP 1 @profile_name = ProfileName
            FROM   DBA.INFO.Email mp

		

      SELECT @recipients = CASE
                             WHEN (SELECT Count(*)
                                   FROM   msdb.dbo.sysoperators
                                   WHERE  email_address = 'services-alerts-UniTrac@alliedsolutions.net') = '1'
                                  AND (SELECT ServerEnvironment
                                       FROM   DBA.info.Instance) IN ( 'PRD', 'PROD' ) THEN 'services-alerts-UniTrac@alliedsolutions.net'
                             WHEN (SELECT Count(*)
                                   FROM   msdb.dbo.sysoperators
                                   WHERE  email_address = 'services-alerts-UniTrac@alliedsolutions.net') = '0'
                                  AND (SELECT ServerEnvironment
                                       FROM   DBA.info.Instance) IN ( 'PRD', 'PROD' ) THEN 'sysadmin-oncall@alliedsolutions.net;noc@alliedsolutions.net'
							ELSE 'HD-IT-DBA@AlliedSolutions.net'
                           END

      IF (SELECT Count(*)
          FROM   @NewPlans
          WHERE  ExecutionCount >= 1) >= 1
        BEGIN
            IF @WhatIf = 0
              BEGIN
                  SELECT DISTINCT @Name = Stuff((SELECT ', ' + ProcedureName
                                        FROM   @NewPlans
                                        FOR XML PATH('')), 1, 2, '											  ');

                  SET @Verbiage = 'We are showing that the following stored procedure has recently changed (since this morning capture)
						and executing on average 4 times higher than normal: '
                  -- Add a second line after @Name and several blank lines
                  SET @FullBody = @Verbiage + @Name
                                  + '<br>If you are not experiencing issues please disregard if you are experiencing issues please refer to the link: <br><br>
https://alliedsolutions.sharepoint.com/:w:/r/teams/DatabaseServices/Shared%20Documents/AlertSupport/PerfStats%20%E2%80%93%20QueryPlans.docx?d=wb9545ebdfdd14da59bc65b3b4697fd52&csf=1&web=1&e=S7ooMW <br><br><br><br>'; -- 4 blank lines
                  EXEC msdb.dbo.Sp_send_dbmail
                    @profile_name = @profile_name,
                    @recipients = @recipients,
                    @subject = 'Query Plans have changed',
                    @body = @FullBody,
                    @body_format = 'HTML';
              END
        END
  END

END;
GO 
