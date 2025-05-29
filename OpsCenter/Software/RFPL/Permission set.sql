IF NOT EXISTS (select  OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name]
 FROM sys.database_permissions
where USER_NAME(grantee_principal_id) ='DEPLOY_ACCESS' AND OBJECT_NAME(major_id) ='SetDatabaseRename')
BEGIN 

use [DBA]

GRANT EXECUTE ON [deploy].[SetDatabaseRename] TO [DEPLOY_ACCESS]

END

IF NOT EXISTS (select  OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name]
 FROM sys.database_permissions
where USER_NAME(grantee_principal_id) ='DEPLOY_ACCESS' AND OBJECT_NAME(major_id) ='SetRFPLDatabasePermission')
BEGIN 

use [DBA]

GRANT EXECUTE ON [deploy].[SetRFPLDatabasePermission] TO [DEPLOY_ACCESS]

END 

IF NOT EXISTS (select  OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name]
 FROM sys.database_permissions
where USER_NAME(grantee_principal_id) ='DEPLOY_ACCESS' AND OBJECT_NAME(major_id) ='SetDatabaseDrop')
BEGIN 

use [DBA]

GRANT EXECUTE ON [deploy].[SetDatabaseDrop] TO [DEPLOY_ACCESS]
END 


