USE msdb; -- Switch to the msdb database


SELECT DISTINCT
 --CONCAT('IF EXISTS (select 1 from msdb.dbo.sysjobs WHERE NAME = ''',j.name,''' AND enabled = 1) BEGIN EXEC msdb.dbo.sp_update_job @job_name=''',j.name,''', @enabled=0 END')
 J.name
FROM msdb.dbo.sysjobschedules js
INNER JOIN msdb.dbo.sysschedules s
    ON js.schedule_id = s.schedule_id
INNER JOIN msdb.dbo.sysjobs j
    ON js.job_id = j.job_id
	where J.enabled = 1
	and s.enabled = 1
	AND J.name LIKE 'Report:%'
	AND  j.name   like '%IDR%'
	OR (j.name   like '%OCR%')


