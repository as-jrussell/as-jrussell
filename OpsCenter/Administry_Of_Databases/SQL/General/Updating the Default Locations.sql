SELECT
SERVERPROPERTY('InstanceDefaultDataPath') AS InstanceDefaultDataPath,
SERVERPROPERTY('InstanceDefaultLogPath') AS InstanceDefaultLogPath

--https://docs.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql?view=sql-server-ver15

/*
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultData', REG_SZ, N'C:\Downloads\SQLDATA\'
PRINT 'Please restart SQL Agent Services for ' + @@Servername + ' to take affect'

GO

EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultLog', REG_SZ, N'C:\Downloads\SQLLOGS\'
PRINT 'Please restart SQL Agent Services for ' + @@Servername + ' to take affect'

GO


EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', REG_SZ, N'C:\Downloads\Backup\'
PRINT 'Please restart SQL Agent Services for ' + @@Servername + ' to take affect'

GO
*/