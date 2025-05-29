IF Object_id(N'tempdb..#AG') IS NOT NULL
  DROP TABLE #AG

CREATE TABLE #AG
  (
     [group_name]                       VARCHAR(100),
     [ServerName]                       VARCHAR(250),
     [role]                       VARCHAR(250),
     [DatabaseName] VARCHAR(250),	 
     [ServerEnvironment]                       VARCHAR(250),	 
     [ServerLocation]                       VARCHAR(250)
  );


  INSERT INTO #AG
select n.group_name,n.node_name,rs.role_desc,
db_name(drs.database_id),  I.ServerEnvironment, I.ServerLocation
from sys.dm_hadr_availability_replica_cluster_nodes n
join sys.dm_hadr_availability_replica_cluster_states cs
on n.replica_server_name = cs.replica_server_name
join sys.dm_hadr_availability_replica_states rs 
on rs.replica_id = cs.replica_id
join sys.dm_hadr_database_replica_states drs
on rs.replica_id=drs.replica_id
left join [DBA].[info].[Instance] I on I.SQLServerName=n.node_name


select * from #AG
where role = 'PRIMARY'