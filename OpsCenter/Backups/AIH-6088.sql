USE [UNITRAC_MORTGAGE];



IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Test_OneMainCPIIssueRefund' AND permission_name ='SELECT' )
GRANT SELECT ON [dbo].[Test_OneMainCPIIssueRefund] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table select access already exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Test_Integration_File' AND permission_name ='SELECT' )
GRANT SELECT ON [dbo].[Test_Integration_File] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table select access already exists' 


IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'OneMainCPIIssueRefund' AND permission_name ='UPDATE' )
GRANT UPDATE ON [dbo].[OneMainCPIIssueRefund] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table update access already exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Integration_File' AND permission_name ='UPDATE' )
GRANT UPDATE ON [dbo].[Integration_File] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table update access already exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Test_Integration_File' AND permission_name ='UPDATE' )
GRANT UPDATE ON [dbo].[Test_Integration_File] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table update access already exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Test_OneMainCPIIssueRefund' AND permission_name ='UPDATE' )
GRANT UPDATE ON [dbo].[Test_OneMainCPIIssueRefund] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table update access already exists' 



IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'OneMainCPIIssueRefund' AND permission_name ='INSERT' )
GRANT INSERT ON [dbo].[OneMainCPIIssueRefund] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table Insert access already exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Integration_File' AND permission_name ='INSERT' )
GRANT INSERT ON [dbo].[Integration_File] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table Insert access already exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Test_Integration_File' AND permission_name ='INSERT' )
GRANT INSERT ON [dbo].[Test_Integration_File] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table Insert access already exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS' and OBJECT_NAME(major_id) = 'Test_OneMainCPIIssueRefund' AND permission_name ='INSERT' )
GRANT INSERT ON [dbo].[Test_OneMainCPIIssueRefund] TO [PIMS_APP_ACCESS];
ELSE 
PRINT 'Table Insert access already exists' 



/*
select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'PIMS_APP_ACCESS' 

		SELECT OBJECT_NAME(major_id),* FROM sys.database_permissions 
		where USER_NAME(grantee_principal_id) ='PIMS_APP_ACCESS'

		*/