

select n.group_name,n.replica_server_name,n.node_name,rs.role_desc,
db_name(drs.database_id) as 'DBName',drs.synchronization_state_desc,drs.synchronization_health_desc, last_hardened_lsn, *
from sys.dm_hadr_availability_replica_cluster_nodes n
join sys.dm_hadr_availability_replica_cluster_states cs
on n.replica_server_name = cs.replica_server_name
join sys.dm_hadr_availability_replica_states rs 
on rs.replica_id = cs.replica_id
join sys.dm_hadr_database_replica_states drs
on rs.replica_id=drs.replica_id
--where 
--db_name(drs.database_id) IN ('Bond_Main', 'WinSvcLog')
--AND
--n.group_name = 'BOND-PROD-AG'
--order by role_desc ASC  



select n.group_name,n.replica_server_name,n.node_name,rs.role_desc, last_hardened_lsn,
db_name(drs.database_id) as 'DBName',last_commit_time

--select db_name(drs.database_id) as 'DBName',last_commit_time 
from sys.dm_hadr_availability_replica_cluster_nodes n
join sys.dm_hadr_availability_replica_cluster_states cs
on n.replica_server_name = cs.replica_server_name
join sys.dm_hadr_availability_replica_states rs 
on rs.replica_id = cs.replica_id
join sys.dm_hadr_database_replica_states drs
on rs.replica_id=drs.replica_id
where 
db_name(drs.database_id) IN ('Unitrac')
