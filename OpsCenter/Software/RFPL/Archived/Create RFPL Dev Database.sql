USE [master]

DECLARE @DBNAME nvarchar(50) = ''


IF NOT EXISTS (SELECT * FROM sys.databases WHERE name like ''+ @DBName+'%')
BEGIN
EXEC ('CREATE DATABASE ' + @DBNAME +'
 CONTAINMENT = NONE')
 PRINT 'Database Created Successfully! Stand by as we apply permissions.... '
END
ELSE
BEGIN 
	PRINT 'WARNING: Database already exist' 
END
IF EXISTS (SELECT * FROM sys.databases WHERE name like ''+ @DBName+'%')
BEGIN
 EXEC DBA.[rfpl].[CreateRFPLSQLUser] @DryRun = 0 --Refresh all permissions
		PRINT 'Permissions updated' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Check for Database' 
END






