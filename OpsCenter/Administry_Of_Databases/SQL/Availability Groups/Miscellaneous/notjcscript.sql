;WITH 
        AG_Stats AS 
                (
                SELECT  AR.replica_server_name, AG.name as AGName, HARS.role_desc, Db_name(DRS.database_id) [DBName], DRS.last_commit_time
                FROM   sys.dm_hadr_database_replica_states DRS 
                INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
                INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
                INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
                ),
        Pri_CommitTime AS 
                (
                SELECT  replica_server_name, AGNAME, DBName, last_commit_time
                FROM    AG_Stats
                WHERE   role_desc = 'PRIMARY'
                ),
        Sec_CommitTime AS 
                (
                SELECT  replica_server_name, AGNAME, DBName, last_commit_time
                FROM    AG_Stats
                WHERE   role_desc = 'SECONDARY'
                )
				
				
    SELECT  p.replica_server_name [primary_replica], p.AGNAME, p.[DBName] +' - '+ s.replica_server_name AS [DatabaseName - secondary_replica],
	DATEDIFF(ss,s.last_commit_time,p.last_commit_time) AS [Sync_Latency_Secs]
    FROM Pri_CommitTime p
    LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName] and  s.AGNAME = p.AGNAME
	WHERE DATEDIFF(ss,s.last_commit_time,p.last_commit_time) >= '0'