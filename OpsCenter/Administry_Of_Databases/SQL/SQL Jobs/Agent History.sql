USE msdb;
GO


DECLARE @job_name nvarchar(255) = 'HDTStorage-PurgeTableMaintenance'
DECLARE @Date NVARCHAR(10)  = ''

IF (@Date = '' OR @Date IS NULL)
BEGIN
SELECT @Date = FORMAT(GETDATE(), 'yyyyMMdd')
END 


IF EXISTS (select * from sys.databases where name = 'rdsadmin') 
BEGIN 
EXEC msdb.dbo.sp_help_job @job_name = @job_name

END 
ELSE
BEGIN 
SELECT 
  j.name AS Job_Name,
  jh.run_date AS Run_Date,
  jh.run_time AS Run_Time,
  jh.step_name AS Step_Name,
  jh.message AS Message,
  CASE jh.step_id 
    WHEN -1 THEN 'Job Level'  -- Job level message
    ELSE 'Step Level' 
  END AS Message_Level,
  CASE jh.run_status
    WHEN 0 THEN 'Failed'
    WHEN 1 THEN 'Succeeded'
    WHEN 2 THEN 'Retry - step only'
    WHEN 3 THEN 'Cancelled'
    WHEN 4 THEN 'In Progress'
    ELSE 'Unknown'
  END AS Run_Status
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.sysjobhistory jh ON j.job_id = jh.job_id
where j.name = @job_name
AND Run_Date >= @Date 
ORDER BY j.name, jh.run_date DESC;
END 
