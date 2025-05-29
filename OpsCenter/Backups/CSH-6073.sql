USE [master]

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name like 'PRL_BLUEFCU_1894_PROD_%')
BEGIN

CREATE DATABASE [PRL_BLUEFCU_1894_PROD]
 CONTAINMENT = NONE
 PRINT 'Database Created Successfully!'
 
 EXEC DBA.[rfpl].[CreateRFPLSQLUser] @DryRun = 0 --Refresh all permissions
		PRINT 'Permissions updated' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Database already exist' 
END