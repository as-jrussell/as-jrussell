Use master

IF NOT EXISTS (select * from sys.syslogins where loginname ='ELDREDGE_A\OCR-Transform-Prod' )
CREATE LOGIN [ELDREDGE_A\OCR-Transform-Prod] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]

ELSE 
PRINT 'Login Already Exists'


USE UniTrac

IF NOT EXISTS (select * from sys.sysusers where name = 'ELDREDGE_A\OCR-Transform-Prod' )
CREATE USER [ELDREDGE_A\OCR-Transform-Prod] FOR LOGIN [ELDREDGE_A\OCR-Transform-Prod];
ELSE 
PRINT 'User Already Exists' 

/* Create App Role */
IF NOT EXISTS (select * from sys.database_principals where name = 'OCR_APP_ACCESS' )
CREATE ROLE  [OCR_APP_ACCESS] AUTHORIZATION [dbo]
ELSE 
PRINT 'Role Already Exists' 



IF NOT EXISTS (select * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='OCR_APP_ACCESS' )
GRANT EXECUTE ON [OCR].[GetEscrowFromPropertyId] TO [OCR_APP_ACCESS] AS [dbo]
ELSE 
PRINT 'Grant to stored proc already exists' 


GO  

IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'OCR_APP_ACCESS' )
ALTER ROLE [OCR_APP_ACCESS] ADD MEMBER [ELDREDGE_A\OCR-Transform-Prod];
ELSE 
PRINT 'User already to group' 

