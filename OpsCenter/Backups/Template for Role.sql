
use [IND_AlliedSolutions_157GIC109]

		DECLARE @USER nvarchar(20) = 'CP_APP_ACCESS'
		DECLARE @TABLE nvarchar(20) = 'IR_RecordingMedia'

IF NOT EXISTS (select * from sys.database_principals where name = @USER)
BEGIN
		CREATE ROLE [CP_APP_ACCESS] AUTHORIZATION [dbo];
		PRINT 'SUCCESS: ROLE was created'
END
	ELSE 
BEGIN
		PRINT 'WARNING: ROLE ALREADY EXISTS'
END

use [IND_AlliedSolutions_157GIC109]
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) = @TABLE  AND TYPE = 'SL' AND USER_NAME(grantee_principal_id) = @USER)
BEGIN
		GRANT SELECT ON [dbo].[IR_RecordingMedia] TO [CP_APP_ACCESS] 
		PRINT 'SUCCESS: GRANT SELECT  was issued to ' + @USER + ' on ' + @TABLE
END
	ELSE 
BEGIN
		PRINT 'WARNING: GRANTS ALREADY EXISTS'
END


use [IND_AlliedSolutions_157GIC109]
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) = @TABLE  AND TYPE = 'UP' AND USER_NAME(grantee_principal_id) = @USER)
BEGIN
		GRANT UPDATE ON [dbo].[IR_RecordingMedia] TO [CP_APP_ACCESS] 
		PRINT 'SUCCESS: GRANT UPDATE  was issued to ' + @USER + ' on ' + @TABLE
END	
	ELSE 
BEGIN
		PRINT 'WARNING: GRANTS ALREADY EXISTS'
END




use [IND_AlliedSolutions_157GIC109]
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) = @TABLE  AND TYPE = 'IN' AND USER_NAME(grantee_principal_id) = @USER)
BEGIN
		GRANT INSERT ON [dbo].[IR_RecordingMedia] TO [CP_APP_ACCESS] 
		PRINT 'SUCCESS: GRANT INSERT  was issued to ' + @USER + ' on ' + @TABLE
END
	ELSE 
BEGIN
		PRINT 'WARNING: GRANTS ALREADY EXISTS'
END

	USE [master]
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = 'SvcProsightExport')
BEGIN
		CREATE LOGIN [ELDREDGE_A\user] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
	USE [IND_AlliedSolutions_157GIC109]
		CREATE USER [ELDREDGE_A\user] FOR LOGIN [ELDREDGE_A\user];
		PRINT 'SUCCESS: USER CREATED'
END
	ELSE 
BEGIN
		PRINT 'WARNING: USER ALREADY EXISTS'
END

USE [master]
IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where rp.name = @USER)
BEGIN
		
		ALTER ROLE [CP_APP_ACCESS] ADD MEMBER [ELDREDGE_A\user];
		PRINT 'SUCCESS: PERMISSION APPLIED'
END
	ELSE 
BEGIN
		PRINT 'WARNING: PERMISSION ALREADY EXISTS'
END



		


/* Add members to new role */