-- Query to identify query using any speicific stored proc
DECLARE @stpredproc    VARCHAR(255) ='GetInteractionHistory',
        @sqlcmd   VARCHAR(max),
		@sym varchar(10) = '>=',
		@Count varchar(10) = 0,
		@Database nvarchar(10) = '',
        @DryRun   INT = 0



SELECT @sqlcmd = 
                 '
SELECT 		databases.name,
SUBSTRING(sqltext.text, (deqs.statement_start_offset / 2) + 1,
(CASE deqs.statement_end_offset
WHEN -1 THEN DATALENGTH(sqltext.text)
ELSE deqs.statement_end_offset
END - deqs.statement_start_offset) / 2 + 1) AS sqltext,
deqs.execution_count,
deqs.total_logical_reads/execution_count AS avg_logical_reads,
deqs.total_logical_writes/execution_count AS avg_logical_writes,
deqs.total_worker_time/execution_count AS avg_cpu_time,
deqs.last_elapsed_time/execution_count AS avg_elapsed_time,
deqs.total_rows/execution_count AS avg_rows,
deqs.creation_time,
deqs.last_execution_time,
CAST(query_plan AS xml) as plan_xml,
CONCAT(''DBCC FREEPROCCACHE ('',CONVERT(VARCHAR(max), plan_handle, 1), '')'') [Query Clearing]
FROM sys.dm_exec_query_stats deqs
CROSS APPLY sys.dm_exec_sql_text(deqs.plan_handle)  AS sqltext
CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) as detqp
INNER JOIN sys.databases
ON sqltext.dbid = databases.database_id
WHERE
sqltext.text LIKE ''%' + @stpredproc + '%'' 
AND deqs.execution_count '+@sym +' '+@Count +'
AND databases.name LIKE ''%' + @Database + '%''
ORDER BY deqs.last_execution_time DESC
OPTION (MAXDOP 1, RECOMPILE);

'



IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 





