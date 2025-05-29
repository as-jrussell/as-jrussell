Use master

IF NOT EXISTS (select * from sys.syslogins where loginname ='ELDREDGE_A\cschwartz' )
CREATE LOGIN [ELDREDGE_A\cschwartz] FROM WINDOWS WITH DEFAULT_DATABASE=[PremAcc3]
ELSE 
PRINT 'Login Already Exists'


USE PremAcc3
IF NOT EXISTS (select * from sys.sysusers where name = 'ELDREDGE_A\cschwartz' )
CREATE USER [ELDREDGE_A\cschwartz] FOR LOGIN [ELDREDGE_A\cschwartz];
ELSE 
PRINT 'User Already Exists' 

/* Create App Role */
IF NOT EXISTS (select * from sys.database_principals where name = 'EMAIL_APP_ACCESS' )
CREATE ROLE [EMAIL_APP_ACCESS] AUTHORIZATION [dbo];
ELSE 
PRINT 'Role Already Exists' 



IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='EMAIL_APP_ACCESS' and OBJECT_NAME(major_id) = 'EMail_Requests' )
GRANT SELECT ON [PremAcc3].[dbo].[EMail_Requests] TO [EMAIL_APP_ACCESS];
ELSE 
PRINT 'Table access for EMail_Requests already exists' 


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'EMAIL_APP_ACCESS' )
ALTER ROLE [EMAIL_APP_ACCESS] ADD MEMBER [ELDREDGE_A\cschwartz];
ELSE 
PRINT 'User already to group' 

