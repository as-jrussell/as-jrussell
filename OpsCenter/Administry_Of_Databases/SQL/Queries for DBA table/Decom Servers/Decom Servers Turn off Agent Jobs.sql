/* DECLARE ALL variables at the top */
DECLARE @SQL VARCHAR(max)
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @JobName varchar(200)


-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases

CREATE TABLE #TempDatabases
  (
     JobName varchar(200),
     IsProcessed  BIT
  )

  INSERT INTO #TempDatabases
            (JobName,
             IsProcessed)
select name, 0 
from msdb.dbo.sysjobs 
where name not in  ('syspolicy_purge_history','DBA-FULL-Final_Backup','DBA-DeleteBackupHistory','DBA-BackupMaintenance')


-- Loop through the remaining databases
WHILE EXISTS(SELECT *
             FROM   #TempDatabases
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @JobName = JobName
      FROM   #TempDatabases
      WHERE  IsProcessed = 0

      -- Prepare SQL Statement
      SELECT @SQL = '
IF EXISTS(select 1 from msdb.dbo.sysjobs where name ='''+@JobName+''' AND enabled=1) 
BEGIN
EXEC msdb.dbo.sp_update_job @job_name=N'''+@JobName+''', 
		@enabled=0

		PRINT ''SUCCESS:'+@JobName+' has been disabled!''

END
ELSE 
BEGIN 
PRINT ''WARNING: '
                    + @JobName + ' was not modified with this script. The system shows agent job: '
                    + @JobName + ' already disabled!!! ''
END
'


	  
      -- You know what we do here if it's 1 then it'll give us code and 0 executes it
      IF @DryRun = 0
        BEGIN
            EXEC ( @SQL)
        END
      ELSE
        BEGIN
            PRINT ( @SQL )
        END

      -- Update table
      UPDATE #TempDatabases
      SET    IsProcessed = 1
      WHERE  JobName = @JobName 
  END 
