use UniTrac

/* Create App Role */   
IF NOT EXISTS (select * from sys.database_principals where name = 'TGT_APP_ACCESS' )
CREATE ROLE [TGT_APP_ACCESS] AUTHORIZATION [dbo];
ELSE 
PRINT 'Role Already Exists' 

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='TGT_APP_ACCESS' and OBJECT_NAME(major_id) = 'tgt_CETD_Error' )
BEGIN
	GRANT SELECT ON [Unitrac].[dbo].[tgt_CETD_Error] TO [TGT_APP_ACCESS]
	GRANT UPDATE ON [Unitrac].[dbo].[tgt_CETD_Error] TO [TGT_APP_ACCESS]
	GRANT DELETE ON [Unitrac].[dbo].[tgt_CETD_Error] TO [TGT_APP_ACCESS]
	GRANT INSERT  ON [Unitrac].[dbo].[tgt_CETD_Error] TO [TGT_APP_ACCESS]
END
ELSE 
BEGIN 
	PRINT 'WARNING: Table access for TGT_APP_ACCESS for tgt_CETD_Error already exists' 
END

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='TGT_APP_ACCESS' and OBJECT_NAME(major_id) = 'tgt_LETD_Error' )
BEGIN
	GRANT SELECT ON [Unitrac].[dbo].[tgt_LETD_Error] TO [TGT_APP_ACCESS]
	GRANT UPDATE ON [Unitrac].[dbo].[tgt_LETD_Error] TO [TGT_APP_ACCESS]
	GRANT DELETE ON [Unitrac].[dbo].[tgt_LETD_Error] TO [TGT_APP_ACCESS]
	GRANT INSERT  ON [Unitrac].[dbo].[tgt_LETD_Error] TO [TGT_APP_ACCESS]
END
ELSE 
BEGIN 
	PRINT 'WARNING: Table access for TGT_APP_ACCESS for tgt_LETD_Error already exists' 
END

IF NOT EXISTS (	SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='TGT_APP_ACCESS' and OBJECT_NAME(major_id) = 'tgt_OETD_Error' )
BEGIN
	GRANT SELECT ON [Unitrac].[dbo].[tgt_OETD_Error] TO [TGT_APP_ACCESS]
	GRANT UPDATE ON [Unitrac].[dbo].[tgt_OETD_Error] TO [TGT_APP_ACCESS]
	GRANT DELETE ON [Unitrac].[dbo].[tgt_OETD_Error] TO [TGT_APP_ACCESS]
	GRANT INSERT  ON [Unitrac].[dbo].[tgt_OETD_Error] TO [TGT_APP_ACCESS]
END
ELSE 
BEGIN 
	PRINT 'WARNING: Table access for TGT_APP_ACCESS for tgt_OETD_Error already exists' 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'TGT_APP_ACCESS' )
ALTER ROLE [TGT_APP_ACCESS] ADD MEMBER [UTdbInfraClientProd];
ELSE 
PRINT 'User already to group' 

