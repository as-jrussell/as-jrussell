


SELECT name, is_distributor, is_publisher, is_subscriber
FROM sys.servers


EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1
GO




EXEC master.dbo.sp_removedbReplication 'repl_distributor'