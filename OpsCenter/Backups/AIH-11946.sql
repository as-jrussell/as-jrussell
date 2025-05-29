

IF EXISTS (select 1 from  sys.dm_hadr_availability_replica_cluster_nodes WHERE group_name = 'BOND-PROD-AG' and node_name = 'CP-SQLPRD-01')
BEGIN
USE [master]

	ALTER AVAILABILITY GROUP [BOND-PROD-AG]
	MODIFY REPLICA ON N'CP-SQLPRD-01' WITH (FAILOVER_MODE = AUTOMATIC)
END 

IF EXISTS (select 1 from  sys.dm_hadr_availability_replica_cluster_nodes WHERE group_name = 'BOND-PROD-AG' and node_name = 'CP-SQLPRD-02')
BEGIN
USE [master]

	ALTER AVAILABILITY GROUP [BOND-PROD-AG]
	MODIFY REPLICA ON N'CP-SQLPRD-02' WITH (FAILOVER_MODE = AUTOMATIC)
END 

IF EXISTS (select 1 from  sys.dm_hadr_availability_replica_cluster_nodes WHERE group_name = 'BOND-PROD-AG' and node_name = 'CP-SQLPRD-03')
BEGIN
USE [master]

	ALTER AVAILABILITY GROUP [BOND-PROD-AG]
	MODIFY REPLICA ON N'CP-SQLPRD-03' WITH (FAILOVER_MODE = AUTOMATIC)
END 