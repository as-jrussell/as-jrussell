/* DECLARE ALL variables at the top */
DECLARE @SQL VARCHAR(max)
DECLARE @JobName NVARCHAR(255)
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @Verbose INT = 0 

-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#AgentJobs') IS NOT NULL
  DROP TABLE #AgentJobs

CREATE TABLE #AgentJobs
  (
     JobName      NVARCHAR(255),
     OperatorName NVARCHAR(255),
     IsProcessed  BIT
  )

/* 
-- In a world the DBA maintenance tables doesn't exist this can be used. 
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
ORDER  BY database_id
*/
INSERT INTO #AgentJobs
-- Get SQL Agent Job Notifications
SELECT j.name AS JobName,
       o.name AS OperatorName,
       0
FROM   msdb.dbo.sysjobs j
       LEFT JOIN msdb.dbo.sysoperators o
              ON j.notify_email_operator_id = o.id
WHERE  J.name LIKE 'Unitrac%'
AND j.enabled = 1
UNION
-- Get SQL Agent Job Notifications
SELECT j.name AS JobName,
       o.name AS OperatorName,
       0
FROM   msdb.dbo.sysjobs j
       LEFT JOIN msdb.dbo.sysoperators o
              ON j.notify_email_operator_id = o.id
WHERE  J.name LIKE 'UTRC%'
AND j.enabled = 1
ORDER  BY j.name;

--WHERE --PLACE SOMETHING HERE THAT MAKES SENSE!!!!
-- Loop through the remaining databases
WHILE EXISTS(SELECT *
             FROM   #AgentJobs
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @JobName = JobName
      FROM   #AgentJobs
      WHERE  IsProcessed = 0

      -- Prepare SQL Statement
      SELECT @SQL = '
	 EXEC msdb.dbo.sp_update_job @job_name=N'''
                    + @JobName + ''', 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@notify_email_operator_name=N''UniTracAdmins''
	

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
      UPDATE #AgentJobs
      SET    IsProcessed = 1
      WHERE  JobName = @JobName
  END

IF @Verbose = 1
  BEGIN
      SELECT JobName, OperatorName, email_address
      FROM   #AgentJobs J
	LEFT JOIN msdb.dbo.sysoperators O on J.OperatorName = O.name 
  END 



