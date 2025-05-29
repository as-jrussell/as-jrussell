SELECT DISTINCT  sa.name, sj.name, sj.description, *
 FROM msdb.dbo.sysjobs sj
JOIN msdb.dbo.sysjobschedules sjs ON sjs.job_id = sj.job_id
JOIN msdb.dbo.sysschedules sa ON sa.schedule_id = sjs.schedule_id
WHERE   sa.name LIKE '%Monday%'





--SELECT * FROM msdb.dbo.sysschedules



SELECT 
 job_id
,name
,enabled
,date_created
,date_modified
FROM msdb.dbo.sysjobs
ORDER BY date_created desc

USE msdb
   EXEC dbo.sp_help_job  
    @job_name = N'Temporary - One Main Work Item Cleanup - INC0549174',  
    @job_aspect = N'ALL' ;  
GO  
