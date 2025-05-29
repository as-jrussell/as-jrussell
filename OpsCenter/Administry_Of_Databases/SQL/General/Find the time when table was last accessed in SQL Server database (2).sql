
  select [schema_name], 
       table_name, 
       max(last_access) as last_access 
from(
    select schema_name(schema_id) as schema_name,
           name as table_name,
           (select max(last_access) 
            from (values(last_user_seek),
                        (last_user_scan),
                        (last_user_lookup), 
                        (last_user_update)) as tmp(last_access))
                as last_access
from sys.dm_db_index_usage_stats sta
join sys.objects obj
     on obj.object_id = sta.object_id
     and obj.type = 'U'
     and sta.database_id = DB_ID()
) usage
group by schema_name, 
         table_name
order by last_access desc;