Invoke-SQLcmd -Server 'ON-SQLCLSTPRD-1' -Database msdb 'USE msdb ;  
GO  


EXEC dbo.sp_update_job  
    @job_name = N''Daily Purge process'',    
    @enabled = 1 ;  
GO  '


Invoke-SQLcmd -Server 'ON-SQLCLSTPRD-2' -Database msdb 'USE msdb ;  
GO  


EXEC dbo.sp_update_job  
    @job_name = N''Daily Purge process'',    
    @enabled = 1 ;  
GO  '