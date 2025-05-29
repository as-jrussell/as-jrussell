use msdb

--select * from sysjobs

select sj.name, sjs.* 
from msdb.dbo.sysjobsteps sjs
join msdb.dbo.sysjobs sj on sjs.job_id = sj.job_id
where command like '%Permissions%' 
and sj.enabled = 1 

select sj.name, sjs.* from sysjobsteps sjs
join sysjobs sj on sjs.job_id = sj.job_id
where sj.name = 'Import Call Data'

