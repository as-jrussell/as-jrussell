select * from sys.objects
where SCHEMA_NAME(schema_id) = 'Unitrac_Tools'



DECLARE @JobName VARCHAR(200) = 'UTRC-Generate_LFP_Stats'

SELECT 
 job_id
,name
,enabled
,date_created
,date_modified
FROM msdb.dbo.sysjobs
where name = @JobName
ORDER BY date_created desc