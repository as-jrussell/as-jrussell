select user_access_desc, recovery_model_desc,*
from sys.databases d
join sys.master_files mf on d.database_id = mf.database_id
WHERE d.database_id > 5
AND d.name NOT LIKE '%HDTStorage%'



  SELECT 'ALTER DATABASE', d.name, 'SET RECOVERY FULL WITH NO_WAIT'
--select user_access_desc, recovery_model_desc,*
from sys.databases d
join sys.master_files mf on d.database_id = mf.database_id
WHERE d.database_id > 5
AND d.name NOT LIKE '%HDTStorage%'




SELECT 'ALTER DATABASE', d.name, 'SET RECOVERY BULK_LOGGED WITH NO_WAIT'
--select *
from sys.databases d
join sys.master_files mf on d.database_id = mf.database_id
WHERE d.database_id > 5
AND d.name NOT LIKE '%HDTStorage%''