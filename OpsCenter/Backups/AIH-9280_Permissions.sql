USE [master]

DECLARE @DBNAME nvarchar(50) = 'PRL_APLUS_661_PROD'

IF EXISTS (SELECT * FROM sys.databases WHERE name like ''+ @DBName+'%')
BEGIN
/* REFRESH ALL SQL ACCOUNT PERMISSIONS IN INSTANCE - Old Stuff*/
	EXEC [DBA].[rfpl].[CreateRFPLSQLUser] @DryRun = 0 --Refresh all permissions


	/* add AD groups to new database - new stuff */
	USE [PRL_APLUS_661_PROD]; -- New Database
	CREATE USER [SQL_RFPL_Development_Team] FOR LOGIN [SQL_RFPL_Development_Team];
	CREATE USER [SQL_RFPL_ReadOnly] FOR LOGIN [SQL_RFPL_ReadOnly];
	CREATE USER [SQL_RFPL_SSAS] FOR LOGIN [SQL_RFPL_SSAS];
	CREATE USER [IT Sys Admins] FOR LOGIN [IT Sys Admins];

	/* set Default SCHEMA- new stuff */
	ALTER USER 	[IT Sys Admins] WITH DEFAULT_SCHEMA=[dbo];
	ALTER USER [SQL_RFPL_Development_Team] WITH DEFAULT_SCHEMA=[dbo];
	ALTER USER [SQL_RFPL_ReadOnly] WITH DEFAULT_SCHEMA=[dbo];
	ALTER USER [SQL_RFPL_SSAS] WITH DEFAULT_SCHEMA=[dbo];
	ALTER ROLE [db_owner] ADD MEMBER [IT Sys Admins]


/* Refresh all AD ACCOUNT PERMISSIONS IN INSTANCE- new stuff */
EXEC [DBA].[deploy].[SetDatabasePermissions] @DryRun = 0

		PRINT 'Permissions updated' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Check for Database' 
END




