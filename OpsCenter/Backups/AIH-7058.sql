use OCR 

IF NOT EXISTS (select * from sys.syslogins where loginname ='ELDREDGE_A\SQL_OCR_AlliedLoanServicing' )
BEGIN
CREATE LOGIN [ELDREDGE_A\SQL_OCR_AlliedLoanServicing] FROM WINDOWS WITH DEFAULT_DATABASE=[OCR]
	PRINT 'Login Created' 
END 
ELSE 
BEGIN
	PRINT 'Login Already Exists'
END


IF NOT EXISTS (select * from sys.syslogins where loginname ='ELDREDGE_A\SQL_OCR_CoAkcess_AlliedLoanServicing' )
BEGIN 
	CREATE LOGIN [ELDREDGE_A\SQL_OCR_CoAkcess_AlliedLoanServicing] FROM WINDOWS WITH DEFAULT_DATABASE=[OCR]
	PRINT 'Login Created' 
END 
ELSE 
BEGIN
	PRINT 'Login Already Exists'
END


IF NOT EXISTS (select * from sys.database_principals where name = 'CoAkcess_AlliedLoanServicing' )
BEGIN
CREATE ROLE [CoAkcess_AlliedLoanServicing] AUTHORIZATION [dbo];
	PRINT 'SUCCESS: Role Created'

END
		ELSE
BEGIN 		
		PRINT 'WARNING: Role Already Exists'
END

/* Create App Role */   
IF NOT EXISTS (select * from sys.database_principals where name = 'CoAkcess_AlliedLoanServicing_ReadOnly' )
BEGIN 
CREATE ROLE [CoAkcess_AlliedLoanServicing_ReadOnly] AUTHORIZATION [dbo];
	PRINT 'SUCCESS: Role Created'

END
		ELSE
BEGIN 		
		PRINT 'WARNING: Role Already Exists'
END

IF NOT EXISTS (SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='CoAkcess_AlliedLoanServicing' AND  OBJECT_NAME(major_id) = 'PostvalidatedDataInsert')
BEGIN
    GRANT EXECUTE ON [report].[PostvalidatedDataInsert] TO [CoAkcess_AlliedLoanServicing ] AS [dbo]
	PRINT 'SUCCESSFUL: Access has been given to tables'
END
ELSE 
BEGIN 
	PRINT 'WARNING: Table access already exists' 
END

IF NOT EXISTS (	SELECT  * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='CoAkcess_AlliedLoanServicing' AND  OBJECT_NAME(major_id) = 'AlliedLoanServicingLogInsert' )
BEGIN
	GRANT EXECUTE ON [report].[AlliedLoanServicingLogInsert] TO [CoAkcess_AlliedLoanServicing ] AS [dbo]
	PRINT 'SUCCESSFUL: Access has been given to tables'
END
ELSE 
BEGIN 
	PRINT 'WARNING: Table access already exists' 
END

IF NOT EXISTS (SELECT * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='CoAkcess_AlliedLoanServicing_ReadOnly' AND  OBJECT_NAME(major_id) = 'PostvalidatedDataInsert')
BEGIN
    GRANT SELECT ON [report].[PostvalidatedData] TO [CoAkcess_AlliedLoanServicing_ReadOnly] AS [dbo]
	PRINT 'SUCCESSFUL: Access has been given to tables'
END
ELSE 
BEGIN 
	PRINT 'WARNING: Table access already exists' 
END

IF NOT EXISTS (	SELECT  * FROM sys.database_permissions where USER_NAME(grantee_principal_id) ='CoAkcess_AlliedLoanServicing_ReadOnly' AND  OBJECT_NAME(major_id) = 'PrevalidatedData' )
BEGIN
	GRANT SELECT ON [report].[PrevalidatedData] TO [CoAkcess_AlliedLoanServicing_ReadOnly] AS [dbo]
	PRINT 'SUCCESSFUL: Access has been given to tables'
END
ELSE 
BEGIN 
	PRINT 'WARNING: Table access already exists' 
END




IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'CoAkcess_AlliedLoanServicing' )
BEGIN 
	ALTER ROLE [CoAkcess_AlliedLoanServicing ] ADD MEMBER [ELDREDGE_A\SQL_OCR_AlliedLoanServicing]
	ALTER ROLE [CoAkcess_AlliedLoanServicing ] ADD MEMBER [ELDREDGE_A\SQL_OCR_CoAkcess_AlliedLoanServicing]
	PRINT 'SUCCESS: Users added to CoAkcess_AlliedLoanServicing Role'
END 
ELSE 
BEGIN 
	PRINT 'WARNING: User already to group' 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc--, mp.name [Login Name], mp.type, mp.default_schema_name 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'CoAkcess_AlliedLoanServicing_ReadOnly' )
BEGIN 

	ALTER ROLE [CoAkcess_AlliedLoanServicing_ReadOnly] ADD MEMBER [ELDREDGE_A\SQL_OCR_CoAkcess_AlliedLoanServicing_ReadOnly]
	PRINT 'SUCCESS: Users added to CoAkcess_AlliedLoanServicing_ReadOnly Role'
END 
ELSE 
BEGIN 
	PRINT 'WARNING: User already to group' 
END
