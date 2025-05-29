USE [master]


IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ELDREDGE_A\UniTrac Allied Development Team')
BEGIN 
	DROP LOGIN [ELDREDGE_A\UniTrac Allied Development Team]
	PRINT 'SUCCESS: [ELDREDGE_A\UniTrac Allied Development Team] Dropped' 
END
ELSE 
BEGIN 
	PRINT 'WARNING: [ELDREDGE_A\UniTrac Allied Development Team] Does not exist' 
END 



USE [master]

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ELDREDGE_A\SQL_IVOS_Development')
BEGIN 
	PRINT 'WARNING: [ELDREDGE_A\SQL_IVOS_Development] Does Already Exist' 
END
ELSE 
BEGIN 
	USE [master]
	CREATE LOGIN [ELDREDGE_A\SQL_IVOS_Development] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
	
	USE [DBA]
	CREATE USER [ELDREDGE_A\SQL_IVOS_Development] FOR LOGIN [ELDREDGE_A\SQL_IVOS_Development]
	ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\SQL_IVOS_Development]

	USE [IVOS]
	CREATE USER [ELDREDGE_A\SQL_IVOS_Development] FOR LOGIN [ELDREDGE_A\SQL_IVOS_Development]
	ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\SQL_IVOS_Development]

	USE [IVOSHDStorage]
	CREATE USER [ELDREDGE_A\SQL_IVOS_Development] FOR LOGIN [ELDREDGE_A\SQL_IVOS_Development]
	ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\SQL_IVOS_Development]

	USE [jasperserver]
	CREATE USER [ELDREDGE_A\SQL_IVOS_Development] FOR LOGIN [ELDREDGE_A\SQL_IVOS_Development]
	ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\SQL_IVOS_Development]

	USE [tempdb]
	CREATE USER [ELDREDGE_A\SQL_IVOS_Development] FOR LOGIN [ELDREDGE_A\SQL_IVOS_Development]
	ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\SQL_IVOS_Development]
	PRINT 'SUCCESS: [ELDREDGE_A\SQL_IVOS_Development] Added' 
END 


