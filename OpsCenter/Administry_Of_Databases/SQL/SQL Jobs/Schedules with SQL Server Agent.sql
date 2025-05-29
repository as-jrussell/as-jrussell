
  DECLARE @utc_offset INT;
  SELECT
    @utc_offset = -1 * DATEDIFF(HOUR, GETUTCDATE(), GETDATE());
SELECT
    sysjobs.job_id,
    sysschedules.schedule_uid,
    sysjobs.name AS job_name,
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
    sysschedules.freq_recurrence_factor AS job_frequency_recurrence_factor,
    CAST(DATEADD(HOUR, @utc_offset, msdb.dbo.agent_datetime(sysschedules.active_start_date, sysschedules.active_start_time)) AS DATE) AS job_start_date_utc,
    CAST(DATEADD(HOUR, @utc_offset, msdb.dbo.agent_datetime(sysschedules.active_start_date, sysschedules.active_start_time)) AS TIME(0)) AS job_start_time_utc,
    CAST(DATEADD(HOUR, @utc_offset, msdb.dbo.agent_datetime(sysschedules.active_start_date, sysschedules.active_start_time)) AS DATETIME) AS job_start_datetime_utc,
    sysjobs.date_created AS job_date_created,
    sysschedules.date_created AS schedule_date_created,
    '' AS job_schedule_description, -- To be populated later
    CASE
      WHEN sysschedules.freq_type = 1 THEN 1
      WHEN sysschedules.freq_type = 4 THEN 1
      WHEN sysschedules.freq_type = 8 THEN 1
      WHEN sysschedules.freq_type = 16 THEN 1
      WHEN sysschedules.freq_type = 32 THEN 1
      WHEN sysschedules.freq_type = 64 THEN 0
      WHEN sysschedules.freq_type = 128 THEN 0
    END AS job_count
  FROM msdb.dbo.sysjobschedules
  INNER JOIN msdb.dbo.sysjobs
  ON sysjobs.job_id = sysjobschedules.job_id
  INNER JOIN msdb.dbo.sysschedules
  ON sysschedules.schedule_id = sysjobschedules.schedule_id
  INNER JOIN msdb.dbo.syscategories
  ON syscategories.category_id = sysjobs.category_id

  WHERE sysschedules.enabled = 1
  AND sysjobs.enabled = 1;