IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: IDR Errors'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: IDR Errors',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Lender_Count_OCR'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Lender_Count_OCR',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: NO_OCR_Match'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: NO_OCR_Match',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Batch Details - Prev Day'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Batch Details - Prev Day',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Batch Details - Same Day'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Batch Details - Same Day',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Errors'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Errors',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Match Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Match Counts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Lender_Count_OCR'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Lender_Count_OCR',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: NO_OCR_Match'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: NO_OCR_Match',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Batch Details - Prev Day'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Batch Details - Prev Day',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Batch Details - Same Day'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Batch Details - Same Day',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Errors'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Errors',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: OCR Match Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Match Counts',
        @enabled=0
  END 
