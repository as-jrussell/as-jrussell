-- Query to identify query using any speicific stored proc
DECLARE @stpredproc VARCHAR(100) ='CPGetBillingGroupDetails_new',
        @DBName     VARCHAR(255)= 'Unitrac',
        @sqlcmd     VARCHAR(max),
        @DryRun     INT = 0

SELECT @sqlcmd = 'USE ' + @DBName
                 + '
--How to Find Stored Procedure Execution Count 
SELECT DB_NAME(database_id) DatabaseName,
OBJECT_NAME(object_id) ProcedureName,
cached_time, type_desc, last_execution_time, execution_count,
total_elapsed_time/execution_count AS avg_elapsed_time,
total_elapsed_time/execution_count/1000 AS avg_elapsed_time_in_seconds,
total_elapsed_time/execution_count/1000/60 AS avg_elapsed_time_in_minutes
--select  OBJECT_NAME(object_id), *
FROM sys.dm_exec_procedure_stats

WHERE OBJECT_NAME(object_id) like ''%'
                 + @stpredproc + '%''' + ' 
AND DB_NAME(database_id) = ''' + @DBName +'''
ORDER BY execution_count DESC ;
'

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 



  
