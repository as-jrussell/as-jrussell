use [msdb]

IF EXISTS(SELECT 1
          FROM   msdb.dbo.sysjobs
          WHERE  name = 'UIPath-AuditLogCleanup')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name=N'UIPath-AuditLogCleanup',
        @enabled=1
  END

PRINT 'UIPath-AuditLogCleanup job has been enabled successfully!!!'

IF EXISTS(SELECT 1
          FROM   msdb.dbo.sysjobs
          WHERE  name = 'UIPath-DailyLogsPurging')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name=N'UIPath-DailyLogsPurging',
        @enabled=1
  END

PRINT 'UIPath-DailyLogsPurging job has been enabled successfully!!!'

IF EXISTS(SELECT 1
          FROM   msdb.dbo.sysjobs
          WHERE  name = 'UIPath-LedgerCleanup')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name=N'UIPath-LedgerCleanup',
        @enabled=1
  END

PRINT 'UIPath-LedgerCleanup job has been enabled successfully!!!'

IF EXISTS(SELECT 1
          FROM   msdb.dbo.sysjobs
          WHERE  name = 'UIPath-LoggedMessagesCleanup')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name=N'UIPath-LoggedMessagesCleanup',
        @enabled=1
  END

PRINT 'UIPath-LoggedMessagesCleanup job has been enabled successfully!!!'

IF EXISTS(SELECT 1
          FROM   msdb.dbo.sysjobs
          WHERE  name = 'UIPath-NotificationsCleanup')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name=N'UIPath-NotificationsCleanup',
        @enabled=1
  END

PRINT 'UIPath-NotificationsCleanup job has been enabled successfully!!!'

IF EXISTS(SELECT 1
          FROM   msdb.dbo.sysjobs
          WHERE  name = 'UIPath-TableHistoryCleanup')
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name=N'UIPath-TableHistoryCleanup',
        @enabled=1
  END

PRINT 'UIPath-TableHistoryCleanup job has been enabled successfully!!!' 
