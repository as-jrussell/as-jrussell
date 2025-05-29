USE [master]

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name like 'PRL_AIRACADEMY_1555_%')
BEGIN

CREATE DATABASE [PRL_AIRACADEMY_1555_PROD]
 CONTAINMENT = NONE
 PRINT 'Database Created Successfully!'
 
 EXEC DBA.[rfpl].[CreateRFPLSQLUser] @DryRun = 0 --Refresh all permissions
		PRINT 'Permissions updated' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Database already exist' 
END