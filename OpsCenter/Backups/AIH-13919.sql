DECLARE @TargetDB nvarchar(100) = 'PRL_FIRSTCITIZENS_2110_PROD' 
DECLARE @sqlcmd nvarchar(MAX) 
DECLARE @sqlcmd2 nvarchar(MAX) 
DECLARE @DryRun INT = 0

 SELECT @sqlcmd ='
USE [master]

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name like '''+ @TargetDB +''')
BEGIN
		EXEC (''CREATE DATABASE ' + @TargetDB +'
	 CONTAINMENT = NONE'')
	 PRINT ''Database '+ @TargetDB + ' Created Successfully! Stand by as we apply permissions.... ''
	END
	ELSE
BEGIN 
	PRINT ''WARNING: Database '+ @TargetDB + ' already exist''
END;'



 SELECT @sqlcmd2 ='

 IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @TargetDB +''')
BEGIN

/* REFRESH ALL SQL ACCOUNT PERMISSIONS IN INSTANCE - Old Stuff*/
	EXEC [DBA].[rfpl].[CreateRFPLSQLUser] @DryRun = 0 --Refresh all permissions 
	/* add AD groups to new database - new stuff */
	USE '+ @TargetDB + ' -- New Database
	CREATE USER [SQL_RFPL_Development_Team] FOR LOGIN [SQL_RFPL_Development_Team];
	CREATE USER [SQL_RFPL_ReadOnly] FOR LOGIN [SQL_RFPL_ReadOnly];
	CREATE USER [SQL_RFPL_SSAS] FOR LOGIN [SQL_RFPL_SSAS];
	CREATE USER [IT Sys Admins] FOR LOGIN [IT Sys Admins];

	/* set Default SCHEMA- new stuff */
	ALTER USER 	[IT Sys Admins] WITH DEFAULT_SCHEMA=[dbo];
	ALTER USER [SQL_RFPL_Development_Team] WITH DEFAULT_SCHEMA=[dbo];
	ALTER USER [SQL_RFPL_ReadOnly] WITH DEFAULT_SCHEMA=[dbo];
	ALTER USER [SQL_RFPL_SSAS] WITH DEFAULT_SCHEMA=[dbo];
	ALTER ROLE [db_owner] ADD MEMBER [IT Sys Admins];

/* Refresh all AD ACCOUNT PERMISSIONS IN INSTANCE- new stuff */
EXEC [DBA].[deploy].[SetDatabaseMembership] @DryRun = 0
EXEC [DBA].[deploy].[SetDatabasePermission] @DryRun = 0


		PRINT ''Permissions updated'' 
END
ELSE
BEGIN 
	PRINT ''WARNING: Check for Database'' 
END'

IF @DryRun = 0
	BEGIN 
		EXEC (@SQLCMD)
		EXEC (@SQLCMD2)

	END
ELSE
	BEGIN
		PRINT (@SQLCMD)
		PRINT (@SQLCMD2)
	END

