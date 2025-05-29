USE [master]

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name like 'PRL_SELCO_572_PROD%')
BEGIN
CREATE DATABASE [PRL_SELCO_572_PROD]
 CONTAINMENT = NONE
 PRINT 'Database Created Successfully! Stand by as we apply permissions.... '
 
END
ELSE
BEGIN 
	PRINT 'WARNING: Database already exist' 
END
IF EXISTS (SELECT * FROM sys.databases WHERE name like '%')
BEGIN
 EXEC DBA.[rfpl].[CreateRFPLSQLUser] @DryRun = 0 --Refresh all permissions
		PRINT 'Permissions updated' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Check for Database' 
END