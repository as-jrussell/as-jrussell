
select d.name as databaseName,
mf.name As logicalfileName,
mf.physical_name AS physaicalFileName, 
sp.page_id,
case sp.event_type
when 1 then N'823 or 824 error'
when 2 then N'Bad Checksum'
when 3 then N'Torn Page'
when 4 then N'Restored'
when 5 then N'Repaired'
when 7 then N'Deallocated'
END AS EventType, 
sp.error_count,sp.last_update_date,
*
from msdb.dbo.suspect_pages as sp
join sys.databases d on sp.database_id = d.database_id 
join sys.master_files as mf on sp.[file_id] = mf.[file_id] and d.database_id = mf.database_id


