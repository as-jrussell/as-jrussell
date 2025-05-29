USE PerfStats; -- Replace with your database name
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[CaptureDBQueryPlans]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      -- Create an empty stored procedure if it doesn't exist
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[CaptureDBQueryPlans] AS RETURN 0;';
  END;

GO

ALTER PROCEDURE [dbo].[CaptureDBQueryPlans] (@ElapsedTimeThreshold BIGINT = 500000,-- Threshold for elapsed time in microseconds
                                           @WhatIf               BIT = 1,-- Default to 1 (Show data without inserting)
                                           @Verbose              BIT = 0,-- Default to 0 (Do not show code)
                                           @StoredProcName       NVARCHAR(128) = NULL,-- Optional stored procedure name
										   @Database       NVARCHAR(128) = NULL,-- Optional stored procedure name
                                           @DatabaseType         NVARCHAR(128) = 'USER',
                                           @Admin                BIT = 1)
WITH EXECUTE AS OWNER
AS
  /*
  -- Test 1: Show data without inserting
  EXEC PerfStats.dbo.CaptureDBQueryPlans

  -- Test 2: Insert data without showing the code
  EXEC PerfStats.dbo.CaptureDBQueryPlans @WhatIf = 0;
  
 --Test 3:  Shows specific all plans from a particular stored procedure with the default threshold
  EXEC PerfStats.dbo.CaptureDBQueryPlans @StoredProcName = 'getAuditLogin'
  
  --Test 4:  Shows specific all plans from a particular database with the default threshold
  EXEC PerfStats.dbo.CaptureDBQueryPlans @Database = 'DBA';

  --Test 5: On any method of the stored proc the threshold can be reset 
  EXEC PerfStats.dbo.CaptureDBQueryPlans @StoredProcName = 'getAuditLogin',  @ElapsedTimeThreshold = 0;

  -- Test 6: On any method of the stored proc can display what is being executed
  EXEC PerfStats.dbo.CaptureDBQueryPlans @Verbose = 1;



  */
  BEGIN
      -- SQL statement to capture query plans with unique PlanID
      DECLARE @SQL NVARCHAR(MAX) = N'
        SELECT 
            DB_NAME(sqltext.dbid) AS DatabaseName,  -- Database name
            SUBSTRING(sqltext.text, (deqs.statement_start_offset / 2) + 1, 
                      ((CASE deqs.statement_end_offset
                          WHEN -1 THEN DATALENGTH(sqltext.text)
                          ELSE deqs.statement_end_offset
                       END - deqs.statement_start_offset) / 2) + 1) AS QueryText,  -- Query text
            deqs.execution_count AS ExecutionCount,  -- Execution count
			deqs.last_elapsed_time/execution_count AS avg_elapsed_time,
deqs.total_rows/execution_count AS avg_rows,
            COALESCE(OBJECT_NAME(sqltext.objectid, sqltext.dbid), ''Ad-Hoc Query'') AS ProcedureName,  -- Procedure name or ''Ad-Hoc Query''
			GETDATE() AS CurrentTime,
            deqs.creation_time AS CreationTime,  -- Query plan creation time
            deqs.last_execution_time AS ExecutionTime,  -- Current timestamp
			            NEWID() AS QueryID,
            deqs.plan_handle AS PlanID,  -- Use plan handle as the unique identifier for the plan
            ISNULL(detqp.query_plan, ''No available Plan'') AS QueryPlan  -- Query plan in XML format
        FROM 
            sys.dm_exec_query_stats deqs
            CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) sqltext
            CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) detqp
            INNER JOIN sys.databases
                ON sqltext.dbid = databases.database_id
        WHERE  
            DB_NAME(sqltext.dbid) IN (
                SELECT DISTINCT DatabaseName
                FROM DBA.INFO.[Database]
                WHERE DatabaseType = '''
        + @DatabaseType
        + '''
            )
            AND (deqs.total_elapsed_time / deqs.execution_count) > '
        + Cast(@ElapsedTimeThreshold AS NVARCHAR(20))
      -- Use MERGE to handle both insert and update scenarios
      DECLARE @MergeSQL NVARCHAR(MAX) = N'
        MERGE INTO QueryPlanHistory AS target
        USING (' + @SQL + ') AS source ( DatabaseName, QueryText, ExecutionCount, [Average_Lapse_Time (탎)], AverageRows,ProcedureName, CurrentTime, CreationTime, ExecutionTime,QueryID, PlanID, QueryPlan)
        ON Target.PlanID = source.PlanID AND target.QueryText = source.QueryText AND target.ProcedureName = source.ProcedureName  AND  target.ExecutionCount = source.ExecutionCount
		AND target.[Average_Lapse_Time (탎)] = source.[Average_Lapse_Time (탎)] AND target.AverageRows = source.AverageRows
        WHEN MATCHED THEN
            UPDATE SET 
                target.DatabaseName = source.DatabaseName,
                target.QueryText = source.QueryText,
                target.ExecutionCount = source.ExecutionCount,
                target.[Average_Lapse_Time (탎)] = source.[Average_Lapse_Time (탎)],
                target.AverageRows = source.AverageRows,
                target.ProcedureName = source.ProcedureName,
                target.CurrentTime = source.CurrentTime,
                target.CreationTime = source.CreationTime,
                target.ExecutionTime = source.ExecutionTime,
							target.PlanID = source.PlanID,
                target.QueryID = source.QueryID,    
                target.QueryPlan = source.QueryPlan
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (DatabaseName, QueryText, ExecutionCount, [Average_Lapse_Time (탎)], AverageRows,ProcedureName, CurrentTime, CreationTime, ExecutionTime,QueryID, PlanID,  QueryPlan)
            VALUES ( source.DatabaseName, source.QueryText, source.ExecutionCount, source.[Average_Lapse_Time (탎)], source.AverageRows, source.ProcedureName, source.CurrentTime, source.CreationTime, source.ExecutionTime, source.QueryID, source.PlanID,source.QueryPlan);
    
	';

      IF @StoredProcName IS NOT NULL
        BEGIN
            SET @SQL = @SQL
                       + N' AND (OBJECT_NAME(sqltext.objectid, sqltext.dbid)) = '''
                       + @StoredProcName + ''''
        END


		
      IF @Database IS NOT NULL
        BEGIN
            SET @SQL = @SQL
                       + N' AND  DB_NAME(sqltext.dbid)  = '''
                       + @Database + ''''
        END

      IF @Admin = 0
        DECLARE @SQLcmd NVARCHAR(MAX)

      SELECT @sqlcmd = Concat('DBCC FREEPROCCACHE (', CONVERT(VARCHAR(max), plan_handle, 1), ')')
      FROM   sys.dm_exec_query_stats deqs
             CROSS APPLY sys.Dm_exec_sql_text(deqs.sql_handle) sqltext
             CROSS APPLY sys.Dm_exec_query_plan(deqs.plan_handle) detqp
      WHERE  ( Object_name(sqltext.objectid, sqltext.dbid) ) = @StoredProcName

      -- If WhatIf is enabled, execute the query and show the data
      IF @WhatIf = 1
        BEGIN
            IF @StoredProcName IS NOT NULL
               AND @Admin = 0
               AND (SELECT Count(*)
                    FROM   sys.dm_exec_query_stats deqs
                           CROSS APPLY sys.Dm_exec_sql_text(deqs.sql_handle) sqltext
                           CROSS APPLY sys.Dm_exec_query_plan(deqs.plan_handle) detqp
                    WHERE  ( Object_name(sqltext.objectid, sqltext.dbid) ) = @StoredProcName) >= 1
              BEGIN
                  EXEC (@SQLCMD)

                  DECLARE @ExecCommand   VARCHAR(max),
                          @ProcedureName NVARCHAR(128)

                  SELECT @ProcedureName = Quotename(Db_name()) + '.'
                                          + Quotename(Object_schema_name(@@PROCID, Db_id()))
                                          + '.'
                                          + Quotename(Object_name(@@PROCID, Db_id()));

                  SET @ExecCommand = 'EXEC ' + @ProcedureName + ', @Admin = '
                                     + CONVERT(CHAR(1), @Admin)
                                     + '; Query Plan Code that was Cleared = '
                                     + @SQLCMD + ';'

                  INSERT INTO [DBA].[deploy].[ExecHistory]
                              ([TimeStampUTC],
                               [UserName],
                               [Command],
                               [ErrorMessage],
                               [Result])
                  VALUES      ( Getdate(),
                                Original_login(),
                                @ExecCommand,
                                'No error handling',
                                1 )
              END
            ELSE
              BEGIN
                  EXEC (@SQL);
              END
        END
      ELSE
        BEGIN
            EXEC (@MergeSQL);
        END

      -- If Verbose is enabled, print the SQL statement
      IF @Verbose = 1
        BEGIN
            IF @StoredProcName IS NOT NULL
              BEGIN
                  PRINT ( @SQL );
              END
            ELSE
              BEGIN
                  PRINT ( @SQL );

                  PRINT ( @MergeSQL );
              END
        END
  END;

GO