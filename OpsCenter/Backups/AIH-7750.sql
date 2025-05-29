

IF NOT EXISTS (select * from sys.database_principals where name = 'DataStore_APP_ACCESS')
BEGIN
use [QCModule]
		CREATE ROLE [DataStore_APP_ACCESS] AUTHORIZATION [dbo];
		PRINT 'SUCCESS: ROLE was created'
END
	ELSE 
BEGIN
		PRINT 'WARNING: ROLE ALREADY EXISTS'
END


IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) = 'PROCESS_LOG' and USER_NAME(grantee_principal_id) = 'DataStore_APP_ACCESS')
BEGIN
use [QCModule]
		GRANT SELECT ON [QCModule].[dbo].[PROCESS_LOG] TO [DataStore_APP_ACCESS] 
		GRANT INSERT ON  [QCModule].[dbo].[PROCESS_LOG] TO [DataStore_APP_ACCESS]
		GRANT UPDATE ON  [QCModule].[dbo].[PROCESS_LOG] TO [DataStore_APP_ACCESS]
		PRINT 'SUCCESS: DataStore_APP_ACCESS applied to PROCESS_LOG table'
END
	ELSE 
BEGIN
		PRINT 'WARNING: Please check your setting for DataStore_APP_ACCESS access'
END


IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) = 'QC_BATCH' and USER_NAME(grantee_principal_id) = 'DataStore_APP_ACCESS')
BEGIN
use [QCModule]
		GRANT SELECT ON [QCModule].[dbo].[QC_BATCH] TO [DataStore_APP_ACCESS] 
		GRANT INSERT ON  [QCModule].[dbo].[QC_BATCH] TO [DataStore_APP_ACCESS]
		GRANT UPDATE ON  [QCModule].[dbo].[QC_BATCH] TO [DataStore_APP_ACCESS]
		PRINT 'SUCCESS: DataStore_APP_ACCESS applied to QC_BATCH table'
END
	ELSE 
BEGIN
		PRINT 'WARNING: Please check your setting for DataStore_APP_ACCESS access'
END



IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) = 'QC_BATCH_ITEM' and USER_NAME(grantee_principal_id) = 'DataStore_APP_ACCESS')
BEGIN
use [QCModule]
		GRANT SELECT ON [QCModule].[dbo].[QC_BATCH_ITEM] TO [DataStore_APP_ACCESS] 
		GRANT INSERT ON  [QCModule].[dbo].[QC_BATCH_ITEM] TO [DataStore_APP_ACCESS]
		GRANT UPDATE ON  [QCModule].[dbo].[QC_BATCH_ITEM] TO [DataStore_APP_ACCESS]
		PRINT 'SUCCESS: DataStore_APP_ACCESS applied to QC_BATCH_ITEM table'
END
	ELSE 
BEGIN
		PRINT 'WARNING: Please check your setting for DataStore_APP_ACCESS access'
END



IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) = 'QC_BATCH_DEFINITION' and USER_NAME(grantee_principal_id) = 'DataStore_APP_ACCESS')
BEGIN
use [QCModule]
		GRANT SELECT ON [QCModule].[dbo].[QC_BATCH_DEFINITION] TO [DataStore_APP_ACCESS] 
		GRANT INSERT ON  [QCModule].[dbo].[QC_BATCH_DEFINITION] TO [DataStore_APP_ACCESS]
		GRANT UPDATE ON  [QCModule].[dbo].[QC_BATCH_DEFINITION] TO [DataStore_APP_ACCESS]
		PRINT 'SUCCESS: DataStore_APP_ACCESS applied to QC_BATCH_DEFINITION table'
END
	ELSE 
BEGIN
		PRINT 'WARNING: Please check your setting for DataStore_APP_ACCESS access'
END


IF NOT EXISTS (SELECT * FROM sys.database_principals where name = 'PIMSAppService')
BEGIN
use [master]
		CREATE LOGIN [PIMSAppService] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
use [QCModule]
		CREATE USER [PIMSAppService] FOR LOGIN [PIMSAppService];
		PRINT 'SUCCESS: LOGIN & USER CREATED'
END
	ELSE 
BEGIN
use [QCModule]
		CREATE USER [PIMSAppService] FOR LOGIN [PIMSAppService];
		PRINT 'SUCCESS: USER CREATED'
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where rp.name = 'DataStore_APP_ACCESS')
BEGIN
use [QCModule]
		ALTER ROLE [DataStore_APP_ACCESS] ADD MEMBER [PIMSAppService];
		PRINT 'SUCCESS: PERMISSION APPLIED'
END
	ELSE 
BEGIN
		PRINT 'WARNING: PERMISSION ALREADY EXISTS'
END