USE [master]




IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ELDREDGE_A\Sys Admins')
BEGIN 

	USE [master]
	DROP LOGIN [ELDREDGE_A\SQL Administrators]
	DROP LOGIN [ELDREDGE_A\iVOS Sys Admins]

	USE [DBA]
	CREATE USER [ELDREDGE_A\Sys Admins] FOR LOGIN [ELDREDGE_A\Sys Admins]
	ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Sys Admins]

	USE [IVOS]
	CREATE USER [ELDREDGE_A\Sys Admins] FOR LOGIN [ELDREDGE_A\Sys Admins]
	ALTER ROLE [db_owner] ADD MEMBER [ELDREDGE_A\Sys Admins]

	USE [IVOSHDStorage]
	CREATE USER [ELDREDGE_A\Sys Admins] FOR LOGIN [ELDREDGE_A\Sys Admins]
	ALTER ROLE [db_owner] ADD MEMBER [ELDREDGE_A\Sys Admins]

	USE [jasperserver]
	CREATE USER [ELDREDGE_A\Sys Admins] FOR LOGIN [ELDREDGE_A\Sys Admins]
	ALTER ROLE [db_owner] ADD MEMBER [ELDREDGE_A\Sys Admins]
	PRINT 'SUCCESS: [ELDREDGE_A\SQL Administrators] and [ELDREDGE_A\iVOS Sys Admins] Dropped' 
	PRINT 'SUCCESS: [ELDREDGE_A\Sys Admins] has been made owner of the following databases: IVOS, IVOSHDStorage, jasperserver' 
	PRINT 'SUCCESS: [ELDREDGE_A\Sys Admins] has been made owner of the following databases: IVOS, IVOSHDStorage, jasperserver' 

END
ELSE 
BEGIN 
	PRINT 'WARNING: [ELDREDGE_A\Sys Admins] does not exist' 
END 




