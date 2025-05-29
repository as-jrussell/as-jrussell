USE [msdb]
GO



IF EXISTS (SELECT *
               from msdb.dbo.sysoperators WHERE name =N'DBA' )
BEGIN 
---Moving AlliedDBA job to DBA
USE [msdb]

EXEC msdb.dbo.sp_update_job @job_id=N'8cbf820b-b065-4bbd-982e-816a67c33627', 
		@notify_level_page=2, 
		@notify_email_operator_name=N'DBA'

EXEC msdb.dbo.sp_attach_schedule @job_id=N'8cbf820b-b065-4bbd-982e-816a67c33627',@schedule_id=147

--Rename Job from DBA to UnitracAdmins

EXEC msdb.dbo.sp_update_operator @name=N'DBA', 
		@enabled=1, 
		@pager_days=0, 
		@email_address=N'services-alerts-UniTrac@alliedsolutions.net', 
		@pager_address=N''

EXEC msdb.dbo.sp_update_operator @name=N'DBA', @new_name=N'UniTracAdmins'
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Operator name DBA'
END 

--Removing Operators that are no longer needed 

IF EXISTS (SELECT *
               from msdb.dbo.sysoperators WHERE name =N'AlliedDBA' )
BEGIN 
EXEC msdb.dbo.sp_delete_operator @name=N'AlliedDBA'

END 
ELSE 
BEGIN 
PRINT 'WARNING: No Operator name AlliedDBA'
END 

IF EXISTS (SELECT *
               from msdb.dbo.sysoperators WHERE name =N'JC' )
BEGIN 
EXEC msdb.dbo.sp_delete_operator @name=N'JC'

END 
ELSE 
BEGIN 
PRINT 'WARNING: No Operator name JC'
END 

IF EXISTS (SELECT *
               from msdb.dbo.sysoperators WHERE name =N'LDH' )
BEGIN 
EXEC msdb.dbo.sp_delete_operator @name=N'LDH'
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Operator name LDH'
END 

IF EXISTS (SELECT *
               from msdb.dbo.sysoperators WHERE name =N'LFP' )
BEGIN 
EXEC msdb.dbo.sp_delete_operator @name=N'LFP'
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Operator name LFP'
END 

IF EXISTS (SELECT *
               from msdb.dbo.sysoperators WHERE name =N'Ray' )
BEGIN 
EXEC msdb.dbo.sp_delete_operator @name=N'Ray'
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Operator name Ray'
END 



--Rename Archiving Jobs and Enabling Jobs
IF EXISTS (SELECT *
               from msdb.dbo.sysjobs  WHERE name ='ArchiveChangeHistory')
BEGIN 
EXEC msdb.dbo.sp_update_job @job_id=N'EC899463-F918-4E43-A797-22FDFABD0469', @new_name=N'Unitrac-ArchiveChangeHistory_Archive',  @enabled=1
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Job named ArchiveChangeHistory'
END 

IF EXISTS (SELECT *
               from msdb.dbo.sysjobs  WHERE name ='ArchiveInteractionHistory')
BEGIN 
EXEC msdb.dbo.sp_update_job @job_id=N'74B94023-CA40-4C48-B54B-6DF99337BF4B', @new_name=N'Unitrac-ArchiveInteractionHistory_Archive',  @enabled=1
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Job named ArchiveInteractionHistory'
END 

IF EXISTS (SELECT *
               from msdb.dbo.sysjobs WHERE name ='ArchivePropertyChange' )
BEGIN 
EXEC msdb.dbo.sp_update_job @job_id=N'1AF4AD48-BD4E-44AE-9537-9BE4670CE0D4', @new_name=N'Unitrac-ArchivePropertyChange_Archive',  @enabled=1
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Job named ArchivePropertyChange'
END 

IF EXISTS (SELECT *
               from msdb.dbo.sysjobs WHERE name ='ArchivePropertyChange Stop' )
BEGIN 
EXEC msdb.dbo.sp_update_job @job_id=N'C59EB114-9E44-4F68-A624-5F40D1086BBD', @new_name=N'Unitrac-ArchivePropertyChange Stop_Archive',  @enabled=1
END 
ELSE 
BEGIN 
PRINT 'WARNING: No Job named ArchivePropertyChange Stop'
END 
