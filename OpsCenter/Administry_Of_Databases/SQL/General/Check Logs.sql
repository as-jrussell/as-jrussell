
SELECT *
FROM sys.master_files f
WHERE f.type_desc = 'log'




SELECT *
FROM sys.master_files f
WHERE f.type_desc = 'rows'





select d.name [database_name], mf.* 
from sys.databases d 
join sys.master_files mf on d.database_id = mf.database_id
WHERE f.type_desc = 'rows'



select d.name [database_name], mf.* 
from sys.databases d 
join sys.master_files mf on d.database_id = mf.database_id
WHERE mf.type_desc = 'log'
and mf.database_id >= 6




SELECT * 
FROM sys.servers
where name = 'SLOGIX-SQL.COLO.AS.LOCAL'



