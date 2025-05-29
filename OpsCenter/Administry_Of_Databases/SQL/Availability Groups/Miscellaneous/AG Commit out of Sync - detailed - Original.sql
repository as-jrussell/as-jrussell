DECLARE @retVal int, @Time time ='00:15:00.0000000'
IF OBJECT_ID(N'tempdb..#AGCheck') IS NOT NULL
DROP TABLE #AGCheck


 CREATE TABLE #AGCheck
        (
           [seconds behind]   TIME,
		   [ServerName]    VARCHAR(250),
		   [Node]    VARCHAR(250),
           [Database_Name] VARCHAR(250),
           [group_name]    VARCHAR(100),
           [role_desc]      NVARCHAR(1000),
        );

;WITH testA AS (select n.group_name,n.replica_server_name,n.node_name,rs.role_desc, last_hardened_lsn,
db_name(drs.database_id) as 'DBName',last_commit_time


from sys.dm_hadr_availability_replica_cluster_nodes n
join sys.dm_hadr_availability_replica_cluster_states cs
on n.replica_server_name = cs.replica_server_name
join sys.dm_hadr_availability_replica_states rs 
on rs.replica_id = cs.replica_id
join sys.dm_hadr_database_replica_states drs
on rs.replica_id=drs.replica_id
),  

testB AS
 (select n.group_name,n.replica_server_name,n.node_name,rs.role_desc, last_hardened_lsn,
db_name(drs.database_id) as 'DBName',last_commit_time


from sys.dm_hadr_availability_replica_cluster_nodes n
join sys.dm_hadr_availability_replica_cluster_states cs
on n.replica_server_name = cs.replica_server_name
join sys.dm_hadr_availability_replica_states rs 
on rs.replica_id = cs.replica_id
join sys.dm_hadr_database_replica_states drs
on rs.replica_id=drs.replica_id
) 






INSERT INTO #AGCheck
select DISTINCT CAST((b.last_commit_time - a.last_commit_time)as TIME)[Seconds Behind], @@Servername,a.node_name, a.DBName, a.group_name, a.role_desc 
from TestA A
join TESTB B on A.DBName = B.DBName 
where a.role_desc <> 'PRIMARY'
AND b.role_desc <> 'SECONDARY'
and
CAST((b.last_commit_time - a.last_commit_time)as TIME) >= @Time





select * from #AGCheck
