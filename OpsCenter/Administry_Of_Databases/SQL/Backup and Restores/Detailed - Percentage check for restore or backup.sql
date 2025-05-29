IF EXISTS (SELECT *
           FROM   sys.databases
           WHERE  name = 'rdsadmin')
  BEGIN
      EXEC msdb.dbo.Rds_task_status

      PRINT 'RDS INSTANCE'
  END
ELSE IF EXISTS (SELECT *
           FROM   sys.database_files
           WHERE  physical_name LIKE 'https%')
  BEGIN
      SELECT *
      FROM   master.sys.dm_operation_status
	  order by last_modify_time desc

      PRINT 'AZURE INSTANCE'
  END
ELSE
  BEGIN
      SELECT session_id,
             CONVERT(NVARCHAR(22), Db_name(database_id))  AS [database],
             CASE command
               WHEN 'BACKUP DATABASE' THEN 'DB BACKUP'
               WHEN 'RESTORE DATABASE' THEN 'DB RESTORE'
               WHEN 'RESTORE VERIFYON' THEN 'VERIFYING'
               WHEN 'RESTORE HEADERON' THEN 'VERIFYING HEADER'
               WHEN 'RESTORE HEADERONLY' THEN 'VERIFYING HEADER'
               WHEN 'BACKUP LOG' THEN 'LOG'
               ELSE 'DBCC '
             END                                                                                                                  AS [type],
             start_time                                                                                                           AS [started],
             Dateadd(mi, estimated_completion_time / 60000, Getdate())                                                            AS [finishing],
             Datediff(mi, start_time, ( Dateadd(mi, estimated_completion_time / 60000, Getdate()) )) - wait_time / 60000          AS [mins left],
             ( Datediff(mi, start_time, ( Dateadd(mi, estimated_completion_time / 60000, Getdate()) )) - wait_time / 60000 ) / 60 AS [hours left],
             Datediff(mi, start_time, ( Dateadd(mi, estimated_completion_time / 60000, Getdate()) ))                              AS [total wait in min(s) (estimate)],
             Datediff(HOUR, start_time, ( Dateadd(HH, estimated_completion_time / 60000 / 60, Getdate()) ))                       AS [total wait in HR(s) (estimate)],
             CONVERT(VARCHAR(5), Cast(( percent_complete ) AS DECIMAL (4, 1)))                                                    AS [% complete],
             Getdate()                                                                                                            AS [current time]
      FROM   sys.dm_exec_requests
      WHERE  command IN ( 'BACKUP DATABASE', 'BACKUP LOG', 'RESTORE DATABASE', 'RESTORE VERIFYON',
                          'RESTORE HEADERON', 'RESTORE HEADERONLY' )
						    Or command Like 'DBCC%'
      PRINT 'EC2 OR ON-PREM INSTANCE'
  END 

