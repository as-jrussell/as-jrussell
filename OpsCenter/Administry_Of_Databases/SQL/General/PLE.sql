Select count(*)*8/1024 AS 'Cached Size (MB)'

,case database_id

when 32767 then 'ResourceDB'

else db_name(database_id)

end as 'Database',
 ((count(*)*8/1024)/4*300) AS 'PLE'

from sys.dm_os_buffer_descriptors

group by db_name(database_id), database_id

order by 'Cached Size (MB)' desC