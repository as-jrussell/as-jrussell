use msdb

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Clear - Internal Dashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Clear - Internal Dashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchivePropertyChange_WeekendOnly_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchivePropertyChange_WeekendOnly_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchivePropertyChange_WeekendOnly_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchivePropertyChange_WeekendOnly_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Purge process'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Purge process',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Purge process'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Purge process',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Purge process'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Purge process',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: UTL 2.0 Sync'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: UTL 2.0 Sync',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: ASR Monitor'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: ASR Monitor',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Process Definition DT reset - OperationalDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Process Definition DT reset - OperationalDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Unitrac Errors (Production)'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Unitrac Errors (Production)',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Unitrac Errors (Production)'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Unitrac Errors (Production)',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: PaMarine Vehicle Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: PaMarine Vehicle Report',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UnitracBatchDetailsSameDay'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UnitracBatchDetailsSameDay',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: UTL 2.0 Matches'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: UTL 2.0 Matches',
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
           WHERE  NAME = 'Daily Condo Association Update Script'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Condo Association Update Script',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-Escrow Amount Type Cleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-Escrow Amount Type Cleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Save Open Certs and Required Coverage Status'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Save Open Certs and Required Coverage Status',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Unitrac Process Counts - Weekend'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Unitrac Process Counts - Weekend',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'TEMP: DailyUnpostingScriptToApplyTerms'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='TEMP: DailyUnpostingScriptToApplyTerms',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Trading_Partner_Log Cleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Trading_Partner_Log Cleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: PaMarine Mortgage Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: PaMarine Mortgage Report',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchivePropertyChange_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchivePropertyChange_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-AlliedPremiumCalculation_Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-AlliedPremiumCalculation_Report',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Maintenance:  Reorganize Full-Text Index'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Maintenance:  Reorganize Full-Text Index',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Maintenance:  Reorganize Full-Text Index'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Maintenance:  Reorganize Full-Text Index',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Email Blank Tempest ID'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Email Blank Tempest ID',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: OCR Status Count'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: OCR Status Count',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Data Warehouse: OutstandingQueue'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Data Warehouse: OutstandingQueue',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Data Warehouse: OutstandingQueue'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Data Warehouse: OutstandingQueue',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchiveChangeHistory_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchiveChangeHistory_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'PerfMon: Gather OS Scheduler Stats'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='PerfMon: Gather OS Scheduler Stats',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Work Item Reprocessing'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Work Item Reprocessing',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Morning Reports'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Morning Reports',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: FindMulti'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: FindMulti',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: Task 48068'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: Task 48068',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Work Items coming up zero - Unitrac- Santander Process'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Work Items coming up zero - Unitrac- Santander Process',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily: Run LFP Config Changes'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily: Run LFP Config Changes',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'syspolicy_purge_history'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='syspolicy_purge_history',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'PerfMon: Gather PerfStats'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='PerfMon: Gather PerfStats',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Lender Cont Cov Types'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Lender Cont Cov Types',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Bill Process Verification'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Bill Process Verification',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Refresh DT reset - OspreyDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Refresh DT reset - OspreyDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Refresh DT reset - OperationalDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Refresh DT reset - OperationalDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Restart Stuck LDHUSD Service'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Restart Stuck LDHUSD Service',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Process Definition DT reset - OspreyDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Process Definition DT reset - OspreyDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UniTrac-LetterLibrary'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UniTrac-LetterLibrary',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Outbound Messages'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Outbound Messages',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Purge VUT Temporary Extract Tables'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Purge VUT Temporary Extract Tables',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'LIMC-Multi-Policy Record Alert'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='LIMC-Multi-Policy Record Alert',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: Move loans unmatched to Delete or Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: Move loans unmatched to Delete or Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Task: Work Item Clean Up'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Task: Work Item Clean Up',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Task: Work Item Clean Up'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Task: Work Item Clean Up',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Task: Work Item Clean Up'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Task: Work Item Clean Up',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Task: Work Item Clean Up'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Task: Work Item Clean Up',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Reset UTL Errors'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Reset UTL Errors',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UniTrac Escrow Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UniTrac Escrow Report',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-Impaired_Expired_Cleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-Impaired_Expired_Cleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: GLS Fax Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: GLS Fax Counts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-Alert: Informatica Message Server Error'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-Alert: Informatica Message Server Error',
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
           WHERE  NAME = 'Report: OCR Batch Details - Same Day'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Batch Details - Same Day',
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
           WHERE  NAME = 'UniTrac-Purge AI OneMain'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UniTrac-Purge AI OneMain',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OLA-IndexOptimize'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OLA-IndexOptimize',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'PerfMon: Long Running Transaction Monitor'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='PerfMon: Long Running Transaction Monitor',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UnitracBatchDetails'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UnitracBatchDetails',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Inbound Messages'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Inbound Messages',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'LIMC Listener Service Error Monitor'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='LIMC Listener Service Error Monitor',
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
           WHERE  NAME = 'Purge CHANGE_TXN records'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Purge CHANGE_TXN records',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Process Definitions In Error'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Process Definitions In Error',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Long Running LFP WorkItems'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Long Running LFP WorkItems',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Long Running LFP WorkItems'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Long Running LFP WorkItems',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Long Running LFP WorkItems'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Long Running LFP WorkItems',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'BSSV2 Copy'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='BSSV2 Copy',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Failed Messages MsgSrvrEXTHUNT 6p EST check'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Failed Messages MsgSrvrEXTHUNT 6p EST check',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Failed Messages'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Failed Messages',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Statistics Update'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Statistics Update',
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
           WHERE  NAME = 'PerfMon: Statistics Change Info'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='PerfMon: Statistics Change Info',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Update address from file for contract-only lenders'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Update address from file for contract-only lenders',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Temporary: TFS Bug 43262 Homestreet'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Temporary: TFS Bug 43262 Homestreet',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Perfmon: Gather Table Fragmentation Info'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Perfmon: Gather Table Fragmentation Info',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: UTL 2.0 Validation'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: UTL 2.0 Validation',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: UTL 2.0 Validation'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: UTL 2.0 Validation',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Email Loan Extract Count Lakeland'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Email Loan Extract Count Lakeland',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Escrow Processes coming up zero'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Escrow Processes coming up zero',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OLA-CommandLogCleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OLA-CommandLogCleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Purge VUT Old Temporary Extract Tables'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Purge VUT Old Temporary Extract Tables',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: Task 50145'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: Task 50145',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: HOV Batch Alerts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: HOV Batch Alerts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'SMTP Mailer cleanup job'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='SMTP Mailer cleanup job',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Update Process Log DatabaseCalls'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Update Process Log DatabaseCalls',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchiveInteractionHistory_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchiveInteractionHistory_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UniTrac-GetEscrowIHs'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UniTrac-GetEscrowIHs',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily: Deletes unmatched SCUSA, CAC, Reliable loans > 24wks'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily: Deletes unmatched SCUSA, CAC, Reliable loans > 24wks',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: EDI Errors'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: EDI Errors',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Unitrac Process Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Unitrac Process Counts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: OceanBankZeroOut'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: OceanBankZeroOut',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Check for HNB Duplicate Loans'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Check for HNB Duplicate Loans',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Late Billing Missing'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Late Billing Missing',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Reset error batches'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Reset error batches',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UTL 2.0 Verification Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UTL 2.0 Verification Report',
        @enabled=0
  END

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
           WHERE  NAME = 'Script: Move loans with zero balance to Delete or Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: Move loans with zero balance to Delete or Archive',
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
           WHERE  NAME = 'Report: OCR Match Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Match Counts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Get Cycle Info (Cycles running at 9am EST)'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Get Cycle Info (Cycles running at 9am EST)',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'LIMC-Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='LIMC-Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UTL 2.0 - Daily UMR Reset Script'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UTL 2.0 - Daily UMR Reset Script',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Escrow Project'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Escrow Project',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-GPGLBackfeed'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-GPGLBackfeed',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Duplex Notice Config Alert'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Duplex Notice Config Alert',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Benchmarking Results'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Benchmarking Results',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OLA-IntegrityCheck'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OLA-IntegrityCheck',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OperationalDashboard - Update Dates'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OperationalDashboard - Update Dates',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Check Full-Text Crawler'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Check Full-Text Crawler',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Work Items (Cycles) coming up zero - Unitrac'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Work Items (Cycles) coming up zero - Unitrac',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UT Property Associations'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UT Property Associations',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Refresh DT reset - InternalDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Refresh DT reset - InternalDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  job_id = 'B746D08E-B8D2-491D-8673-31149971F368'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_id='B746D08E-B8D2-491D-8673-31149971F368',
        @enabled=0
  END 

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: ASR Monitor'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: ASR Monitor',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Bill Process Verification'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Bill Process Verification',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Check Full-Text Crawler'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Check Full-Text Crawler',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Current FTP Batch'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Current FTP Batch',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Escrow Processes coming up zero'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Escrow Processes coming up zero',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Failed Messages'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Failed Messages',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Failed Messages MsgSrvrEXTHUNT 6p EST check'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Failed Messages MsgSrvrEXTHUNT 6p EST check',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Get Cycle Info (Cycles running at 9am EST)'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Get Cycle Info (Cycles running at 9am EST)',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: HOV Batch Alerts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: HOV Batch Alerts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Long Running LFP WorkItems'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Long Running LFP WorkItems',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: OCR Status Count'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: OCR Status Count',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Process Definitions In Error'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Process Definitions In Error',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: UTL 2.0 Matches'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: UTL 2.0 Matches',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: UTL 2.0 Sync'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: UTL 2.0 Sync',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: UTL 2.0 Validation'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: UTL 2.0 Validation',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Work Items (Cycles) coming up zero - Unitrac'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Work Items (Cycles) coming up zero - Unitrac',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Alert: Work Items coming up zero - Unitrac- Santander Process'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Alert: Work Items coming up zero - Unitrac- Santander Process',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'BSSV2 Copy'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='BSSV2 Copy',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Check for HNB Duplicate Loans'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Check for HNB Duplicate Loans',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Condo Association Update Script'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Condo Association Update Script',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Purge process'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Purge process',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Unitrac Process Counts - Weekend'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Unitrac Process Counts - Weekend',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily Unitrac Process Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily Unitrac Process Counts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily: Deletes unmatched SCUSA, CAC, Reliable loans > 24wks'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily: Deletes unmatched SCUSA, CAC, Reliable loans > 24wks',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Daily: Set No ReAudit (CSH3078)'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Daily: Set No ReAudit (CSH3078)',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Clear - Internal Dashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Clear - Internal Dashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Refresh DT reset - InternalDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Refresh DT reset - InternalDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Refresh DT reset - OperationalDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Refresh DT reset - OperationalDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Cache Refresh DT reset - OspreyDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Cache Refresh DT reset - OspreyDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Process Definition DT reset - OperationalDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Process Definition DT reset - OperationalDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Dashboard Process Definition DT reset - OspreyDashboard'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Dashboard Process Definition DT reset - OspreyDashboard',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Data Warehouse: OutstandingQueue'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Data Warehouse: OutstandingQueue',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Duplex Notice Config Alert'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Duplex Notice Config Alert',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Email Blank Tempest ID'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Email Blank Tempest ID',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Email Loan Extract Count Lakeland'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Email Loan Extract Count Lakeland',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'LIMC Listener Service Error Monitor'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='LIMC Listener Service Error Monitor',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'LIMC-Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='LIMC-Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'LIMC-Multi-Policy Record Alert'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='LIMC-Multi-Policy Record Alert',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Maintenance:  Reorganize Full-Text Index'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Maintenance:  Reorganize Full-Text Index',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OLA-CommandLogCleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OLA-CommandLogCleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OLA-IndexOptimize'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OLA-IndexOptimize',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OLA-IntegrityCheck'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OLA-IntegrityCheck',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'One Main Daily Updates'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='One Main Daily Updates',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'OperationalDashboard - Update Dates'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='OperationalDashboard - Update Dates',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Purge CHANGE_TXN records'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Purge CHANGE_TXN records',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Purge UniTrac Purge Logs'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Purge UniTrac Purge Logs',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Purge VUT Old Temporary Extract Tables'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Purge VUT Old Temporary Extract Tables',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Benchmarking Results'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Benchmarking Results',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: EDI Errors'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: EDI Errors',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Escrow Project'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Escrow Project',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: FindMulti'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: FindMulti',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: GLS Fax Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: GLS Fax Counts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Inbound Messages'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Inbound Messages',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Lender Cont Cov Types'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Lender Cont Cov Types',
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
           WHERE  NAME = 'Report: OCR Match Counts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: OCR Match Counts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Outbound Messages'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Outbound Messages',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: PaMarine Mortgage Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: PaMarine Mortgage Report',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: PaMarine Vehicle Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: PaMarine Vehicle Report',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: RogueBatches'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: RogueBatches',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: Unitrac Errors (Production)'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: Unitrac Errors (Production)',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UnitracBatchDetails'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UnitracBatchDetails',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UnitracBatchDetailsSameDay'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UnitracBatchDetailsSameDay',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UT Property Associations'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UT Property Associations',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Report: UTL 2.0 Verification Report'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Report: UTL 2.0 Verification Report',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Reset error batches'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Reset error batches',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Reset UTL Errors'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Reset UTL Errors',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Restart Stuck LDHUSD Service'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Restart Stuck LDHUSD Service',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Save Open Certs and Required Coverage Status'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Save Open Certs and Required Coverage Status',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: ACC Correct Cancel Amounts'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: ACC Correct Cancel Amounts',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: OceanBankZeroOut'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: OceanBankZeroOut',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: Task 48068'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: Task 48068',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Script: Task 50145'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Script: Task 50145',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'SMTP Mailer cleanup job'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='SMTP Mailer cleanup job',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Sync Centers & Lenders from Unitrac to Scan DB'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Sync Centers & Lenders from Unitrac to Scan DB',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'syspolicy_purge_history'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='syspolicy_purge_history',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Task: Work Item Clean Up'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Task: Work Item Clean Up',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'TEMP: DailyUnpostingScriptToApplyTerms'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='TEMP: DailyUnpostingScriptToApplyTerms',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Temporary: TFS Bug 37520 Reliable Credit Branch Update'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Temporary: TFS Bug 37520 Reliable Credit Branch Update',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Temporary: TFS Bug 43262 Homestreet'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Temporary: TFS Bug 43262 Homestreet',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Trading_Partner_Log Cleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Trading_Partner_Log Cleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac_ACV_DT_UPDATE7404'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac_ACV_DT_UPDATE7404',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac_InteractionHistory_CleanUp7404'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac_InteractionHistory_CleanUp7404',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-Alert: Informatica Message Server Error'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-Alert: Informatica Message Server Error',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchiveChangeHistory_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchiveChangeHistory_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchiveInteractionHistory_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchiveInteractionHistory_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchivePropertyChange_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchivePropertyChange_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-ArchivePropertyChange_WeekendOnly_Archive'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-ArchivePropertyChange_WeekendOnly_Archive',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-Escrow Amount Type Cleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-Escrow Amount Type Cleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UniTrac-GetEscrowIHs'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UniTrac-GetEscrowIHs',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-GPGLBackfeed'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-GPGLBackfeed',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-Impaired Expired Cleanup'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-Impaired Expired Cleanup',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UniTrac-LetterLibrary'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UniTrac-LetterLibrary',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-PegaEscrowWorkitemStatus'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-PegaEscrowWorkitemStatus',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UniTrac-Purge AI OneMain'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UniTrac-Purge AI OneMain',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-QCPreEscrowCleanUp'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-QCPreEscrowCleanUp',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Unitrac-Revert from Impairment Pending'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Unitrac-Revert from Impairment Pending',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Update address from file for contract-only lenders'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Update address from file for contract-only lenders',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Update Process Log DatabaseCalls'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Update Process Log DatabaseCalls',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UT EOM CLEANUP SCRIPTS'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UT EOM CLEANUP SCRIPTS',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'UTL 2.0 - Daily UMR Reset Script'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='UTL 2.0 - Daily UMR Reset Script',
        @enabled=0
  END

IF EXISTS (SELECT 1
           FROM   msdb.dbo.sysjobs
           WHERE  NAME = 'Work Item Reprocessing'
                  AND enabled = 1)
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name='Work Item Reprocessing',
        @enabled=0
  END 




USE msdb; -- Switch to the msdb database

SELECT
    j.name AS JobName,
    s.name AS ScheduleName,
    CASE
        WHEN s.enabled = 1 THEN 'Enabled'
        ELSE 'Disabled'
    END AS ScheduleStatus,

	    CASE
        WHEN j.enabled = 1 THEN 'Enabled'
        ELSE 'Disabled'
    END AS JobStatus
FROM msdb.dbo.sysjobschedules js
INNER JOIN msdb.dbo.sysschedules s
    ON js.schedule_id = s.schedule_id
INNER JOIN msdb.dbo.sysjobs j
    ON js.job_id = j.job_id
	where J.enabled = 1
	and s.enabled = 1
	order by JobName asc