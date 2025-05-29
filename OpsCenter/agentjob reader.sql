USE [DBA]


SELECT [JobName]
      ,[JobDescription]
      ,[JobCategory]
      ,[JobEnabled]
      ,[JobStatus]
      ,[StatusDesc]
      ,[JobDurationSec]
      ,[RunDateTime]
      ,[EndDateTime]
      ,[CreateDate]
      ,[ModifiedDate]
      ,[HarvestDate]
  FROM [DBA].[info].[AgentJob]
  
  WHERE JobEnabled = 1 
  AND CAST(HarvestDate AS DATE) = CAST(GETDATE() AS DATE)
  AND StatusDesc ='Failed'
  AND (JobName like 'DBA-%'
  OR JobName like 'Perf%')
  AND JobName not like 'Perfmon%'
  AND JobName not in ( 'DBA-PurgeTableMaintenance','DBA-BackupDatabases-FULL',-- 'DBA-SendTestEmail', 'DBA-ShrinkLogfile', 'DBA-BackupDatabases-Alert',
 -- 'PerfStats-CaptureDBFileSize', 'PerfStats-CaptureDBFileUsage', 'PerfStats-CaptureDriveUsage',   'PerfStats-DriveUsage',
--  'PerfStats-CaptureModelStats', 'PerfStats-CaptureTempDBLogUsage', 'Perfstats-TempDataFilesCheck',
   'Performance Test Data Load')

  /*
  
  'PerfStats-CaptureFileSize', 

  */

