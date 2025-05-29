Use master

IF NOT EXISTS (select * from sys.syslogins where loginname ='ELDREDGE_A\UiPath Robots' )
CREATE LOGIN [ELDREDGE_A\UiPath Robots] FROM WINDOWS WITH DEFAULT_DATABASE=[RPA]
ELSE 
PRINT 'Login Already Exists'


USE [RPA]

IF NOT EXISTS (select * from sys.sysusers where name = 'ELDREDGE_A\UiPath Robots' )
CREATE USER [ELDREDGE_A\UiPath Robots] FOR LOGIN [ELDREDGE_A\UiPath Robots];
ELSE 
PRINT 'User Already Exists' 


USE [UiPath]

IF NOT EXISTS (select * from sys.sysusers where name = 'ELDREDGE_A\UiPath Robots' )
CREATE USER [ELDREDGE_A\UiPath Robots] FOR LOGIN [ELDREDGE_A\UiPath Robots];
ELSE 
PRINT 'User Already Exists' 
 
use RPA
/* Create App Role */
IF NOT EXISTS (select * from sys.database_principals where name = 'QUEUEHEALTH_APP_ACCESS' )
CREATE ROLE [QUEUEHEALTH_APP_ACCESS] AUTHORIZATION [dbo];
ELSE 
PRINT 'Role Already Exists' 

use UiPath
/* Create App Role */
IF NOT EXISTS (select * from sys.database_principals where name = 'QUEUEHEALTH_APP_ACCESS' )
CREATE ROLE [QUEUEHEALTH_APP_ACCESS] AUTHORIZATION [dbo];
ELSE 
PRINT 'Role Already Exists' 



use RPA
IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='REPO_APP_ACCESS' and OBJECT_NAME(major_id) = 'Rpa_Uipath_QueueInfo' )
GRANT SELECT ON [RPA].[dbo].[Rpa_Uipath_QueueInfo] TO [QUEUEHEALTH_APP_ACCESS];
ELSE 
PRINT 'Table access for Rpa_Uipath_QueueInfo already exists' 

use UiPath
IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='REPO_APP_ACCESS' and OBJECT_NAME(major_id) = 'QueueItems' )
GRANT SELECT ON [UiPath].[dbo].[QueueItems]  TO [QUEUEHEALTH_APP_ACCESS];
ELSE 
PRINT 'Table access for QueueItems already exists' 


IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='REPO_APP_ACCESS' and OBJECT_NAME(major_id) = 'QueueDefinitions' )
GRANT SELECT ON  [UiPath].[dbo].[QueueDefinitions] TO [QUEUEHEALTH_APP_ACCESS];
ELSE 
PRINT 'Table access for QueueDefinitions already exists' 

use RPA

IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'QUEUEHEALTH_APP_ACCESS' )
ALTER ROLE [QUEUEHEALTH_APP_ACCESS] ADD MEMBER [ELDREDGE_A\UiPath Robots];
ELSE 
PRINT 'User already to group' 


use UiPath

IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'QUEUEHEALTH_APP_ACCESS' )
ALTER ROLE [QUEUEHEALTH_APP_ACCESS] ADD MEMBER [ELDREDGE_A\UiPath Robots];
ELSE 
PRINT 'User already to group' 

 