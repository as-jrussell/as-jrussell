Use master

IF NOT EXISTS (select * from sys.syslogins where loginname ='ELDREDGE_A\SvcClmIsoImportTest' )
CREATE LOGIN [ELDREDGE_A\SvcClmIsoImportTest] FROM WINDOWS WITH DEFAULT_DATABASE=[RepoPlusAnalytics]
ELSE 
PRINT 'Login Already Exists'


USE RepoPlusAnalytics

IF NOT EXISTS (select * from sys.sysusers where name = 'ELDREDGE_A\SvcClmIsoImportTest' )
CREATE USER [ELDREDGE_A\SvcClmIsoImportTest] FOR LOGIN [ELDREDGE_A\SvcClmIsoImportTest];
ELSE 
PRINT 'User Already Exists' 

/* Create App Role */
IF NOT EXISTS (select * from sys.database_principals where name = 'REPO_APP_ACCESS' )
CREATE ROLE [REPO_APP_ACCESS] AUTHORIZATION [dbo];
ELSE 
PRINT 'Role Already Exists' 



IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='REPO_APP_ACCESS' and OBJECT_NAME(major_id) = 'IsoInsuranceData' )
GRANT SELECT ON [RepoPlusAnalytics].[dbo].[IsoInsuranceData] TO [REPO_APP_ACCESS];
ELSE 
PRINT 'Table access for IsoInsuranceData already exists' 


IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='REPO_APP_ACCESS' and OBJECT_NAME(major_id) = 'IsoInsuranceData' )
GRANT UPDATE ON [RepoPlusAnalytics].[dbo].[IsoClaimData] TO [REPO_APP_ACCESS];
ELSE 
PRINT 'Table access for IsoClaimData already exists' 


GO  

IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'REPO_APP_ACCESS' )
ALTER ROLE [REPO_APP_ACCESS] ADD MEMBER [ELDREDGE_A\SvcClmIsoImportTest];
ELSE 
PRINT 'User already to group' 

