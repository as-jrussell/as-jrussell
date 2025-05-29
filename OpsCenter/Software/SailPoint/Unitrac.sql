
use [Unitrac]
IF NOT EXISTS (select * from sys.database_principals where name = 'IdentityNow_APP_ACCESS')
BEGIN
		CREATE ROLE [IdentityNow_APP_ACCESS] AUTHORIZATION [dbo];
		PRINT 'SUCCESS: ROLE was created'
END
	ELSE 
BEGIN
		PRINT 'WARNING: ROLE ALREADY EXISTS'
END

use [Unitrac]
IF NOT EXISTS (SELECT OBJECT_NAME(major_id),  USER_NAME(grantee_principal_id),* FROM sys.database_permissions where OBJECT_NAME(major_id) = 'Support_GetUsersForMaintenance' and USER_NAME(grantee_principal_id) = 'IdentityNow_APP_ACCESS')
BEGIN
		GRANT EXECUTE ON [dbo].[Support_GetUsersForMaintenance] TO [IdentityNow_APP_ACCESS] 
		PRINT 'SUCCESS: GRANT was issued'
END
	ELSE 
BEGIN
		PRINT 'WARNING: GRANTS ALREADY EXISTS'
END


use [Unitrac]
IF NOT EXISTS (SELECT OBJECT_NAME(major_id),  USER_NAME(grantee_principal_id),* FROM sys.database_permissions where OBJECT_NAME(major_id) = 'Support_SaveUserForMaintenance' and USER_NAME(grantee_principal_id) = 'IdentityNow_APP_ACCESS')
BEGIN
		GRANT EXECUTE ON [dbo].[Support_SaveUserForMaintenance] TO [IdentityNow_APP_ACCESS] 
		PRINT 'SUCCESS: GRANT was issued'
END
	ELSE 
BEGIN
		PRINT 'WARNING: GRANTS ALREADY EXISTS'
END



USE [UniTrac]
IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where  rp.name ='IdentityNow_APP_ACCESS' AND  mp.name ='IDUTUser')
BEGIN
		
		ALTER ROLE [IdentityNow_APP_ACCESS] ADD MEMBER [IDUTUser];
		PRINT 'SUCCESS: PERMISSION APPLIED'
END
	ELSE 
BEGIN
		PRINT 'WARNING: PERMISSION ALREADY EXISTS'
END



		


/* Add members to new role */