
DECLARE @utc_offset INT;
  SELECT
    @utc_offset = -1 * DATEDIFF(HOUR, GETUTCDATE(), GETDATE());



SELECT
DISTINCT
    [sJOB].name AS job_name,
    CASE
      WHEN sysschedules.freq_type = 1 THEN 'One-Time'
      WHEN sysschedules.freq_type = 4 THEN 'Daily'
      WHEN sysschedules.freq_type = 8 THEN 'Weekly'
      WHEN sysschedules.freq_type = 16 THEN 'Monthly'
      WHEN sysschedules.freq_type = 32 THEN 'Monthly-Relative'
      WHEN sysschedules.freq_type = 64 THEN 'Agent Startup'
      WHEN sysschedules.freq_type = 128 THEN 'Computer Idle'
    END AS job_frequency,
    sysschedules.freq_interval AS job_frequency_interval,
    CASE
      WHEN sysschedules.freq_subday_type = 0 THEN 'UNUSED'
      WHEN sysschedules.freq_subday_type = 1 THEN 'AT_TIME'
      WHEN sysschedules.freq_subday_type = 2 THEN 'SECONDS'
      WHEN sysschedules.freq_subday_type = 4 THEN 'MINUTES'
      WHEN sysschedules.freq_subday_type = 8 THEN 'HOURS'
    END AS job_frequency_subday_type,
    sysschedules.freq_subday_interval AS job_frequency_subday_interval,
    CASE
      WHEN sysschedules.freq_relative_interval = 0 THEN 'UNUSED'
      WHEN sysschedules.freq_relative_interval = 1 THEN 'first'
      WHEN sysschedules.freq_relative_interval = 2 THEN 'second'
      WHEN sysschedules.freq_relative_interval = 4 THEN 'third'
      WHEN sysschedules.freq_relative_interval = 8 THEN 'fourth'
      WHEN sysschedules.freq_relative_interval = 16 THEN 'last'
    END AS job_frequency_relative_interval,
    CASE
      WHEN sysschedules.freq_type = 1 THEN 1
      WHEN sysschedules.freq_type = 4 THEN 1
      WHEN sysschedules.freq_type = 8 THEN 1
      WHEN sysschedules.freq_type = 16 THEN 1
      WHEN sysschedules.freq_type = 32 THEN 1
      WHEN sysschedules.freq_type = 64 THEN 0
      WHEN sysschedules.freq_type = 128 THEN 0
    END AS job_count, 
	CASE [sJOB].[delete_level]
        WHEN 0 THEN 'Never'
        WHEN 1 THEN 'On Success'
        WHEN 2 THEN 'On Failure'
        WHEN 3 THEN 'On Completion'
      END AS [JobDeletionCriterion],
  CASE
      WHEN sysschedules.freq_subday_type = 0 THEN 'UNUSED'
      WHEN sysschedules.freq_subday_type = 1 THEN RIGHT('0' + RTRIM(run_time / 10000), 2) + ':' + RIGHT('0' + RTRIM(run_time / 100 % 100), 2)

      WHEN sysschedules.freq_subday_type = 2 THEN 'S- UNUSED'
      WHEN sysschedules.freq_subday_type = 4 THEN '15 min'
      WHEN sysschedules.freq_subday_type = 8 THEN 'Hourly'
    END

 AS 'Time',
                            
	     avg( ( run_duration / 10000 * 3600 + ( run_duration / 100 )%100 * 60 + run_duration%100 + 31 ) / 60 ) AS 'RunDurationMinutes'
---select DISTINCT count(*) from msdb.dbo.sysjobs [sJOB]
  FROM msdb.dbo.sysjobschedules
  INNER JOIN msdb.dbo.sysjobs [sJOB]
  ON [sJOB].job_id = sysjobschedules.job_id
  INNER JOIN msdb.dbo.sysschedules
  ON sysschedules.schedule_id = sysjobschedules.schedule_id
  INNER JOIN msdb.dbo.syscategories
  ON syscategories.category_id = [sJOB].category_id
  	INNER JOIN msdb.dbo.sysjobhistory h
               ON [sJOB].job_id = h.job_id
  WHERE sysschedules.enabled = 1
  AND [sJOB].enabled = 1
  GROUP BY  [sJOB].name, sysschedules.freq_type, sysschedules.freq_interval, sysschedules.freq_relative_interval, sysschedules.freq_subday_type,  sysschedules.freq_subday_interval, [sJOB].[delete_level],run_date, run_time



