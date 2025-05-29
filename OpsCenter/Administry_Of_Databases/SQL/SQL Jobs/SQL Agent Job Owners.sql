/* DECLARE ALL variables at the top */
DECLARE @SQL VARCHAR(max)
DECLARE @JobName SYSNAME
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @Verbose INT = 0 --0 preview / 1 nothing  
-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempAgentJobs') IS NOT NULL
  DROP TABLE #TempAgentJobs
CREATE TABLE #TempAgentJobs
  (
     JobName SYSNAME,
     IsProcessed BIT
  )
-- Insert the databases to exclude into the temporary table
INSERT INTO #TempAgentJobs (JobName, IsProcessed)
SELECT s.name, 0 -- SELECT *
FROM msdb..sysjobs s
LEFT JOIN master.sys.syslogins l ON s.owner_sid = l.sid
--WHERE   ISNULL(l.name, s.owner_sid) <> 'sa'
ORDER  BY s.name
-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempAgentJobs WHERE IsProcessed = 0 )
  BEGIN

    -- Fetch 1 JobName where IsProcessed = 0
    SELECT Top 1 @JobName = JobName FROM #TempAgentJobs WHERE IsProcessed = 0 
    -- Prepare SQL Statement
    SELECT @SQL = ' EXEC msdb.dbo.sp_update_job 
  @job_name = N'''+@JobName+''',
  @owner_login_name = N''sa'';  '

    -- You know what we do here if it's 1 then it'll give us code and 0 executes it
    IF @DryRun = 0
        BEGIN
            PRINT ( @JobName )
            EXEC ( @SQL)
        END
    ELSE
        BEGIN
            PRINT ( @SQL )
        END
    -- Update table
    UPDATE  #TempAgentJobs 
    SET IsProcessed = 1
    WHERE JobName = @JobName
  END


  
  IF @Verbose = 0
  BEGIN

  SELECT L.loginname, S.*
  FROM msdb..sysjobs s
  JOIN #TempAgentJobs j ON j.JobName = S.name
LEFT JOIN master.sys.syslogins l ON s.owner_sid = l.sid
WHERE enabled = 1


  END 
  