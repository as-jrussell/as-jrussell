
DECLARE @JobName VARCHAR(200) = 'LIMC-MultipolicyProcessedDate'

SELECT 
 job_id
,name
,enabled
,date_created
,date_modified
FROM msdb.dbo.sysjobs
where name = @JobName
ORDER BY date_created desc