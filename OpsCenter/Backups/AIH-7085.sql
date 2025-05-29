use master

IF NOT EXISTS (select * from sys.syslogins where loginname ='ELDREDGE_A\SQL_OCR_AlliedLoanServicing' )
BEGIN
CREATE LOGIN [ELDREDGE_A\SQL_OCR_AlliedLoanServicing] FROM WINDOWS WITH DEFAULT_DATABASE=[tempDb]
	PRINT 'Login Created' 
END 
ELSE 
BEGIN
	PRINT 'Login Already Exists'
END

USE Unitrac 
IF NOT EXISTS (select * from sys.sysusers where name ='ELDREDGE_A\SQL_OCR_AlliedLoanServicing' )
BEGIN
CREATE USER [ELDREDGE_A\SQL_OCR_AlliedLoanServicing] FOR LOGIN [ELDREDGE_A\SQL_OCR_AlliedLoanServicing]
	PRINT 'Login Created' 
END 
ELSE 
BEGIN
	PRINT 'Login Already Exists'
END

use UniTrac
IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name = 'OCR_APP_ACCESS' and mp.name ='ELDREDGE_A\SQL_OCR_AlliedLoanServicing'  )
BEGIN 
	ALTER ROLE [OCR_APP_ACCESS ] ADD MEMBER [ELDREDGE_A\SQL_OCR_AlliedLoanServicing]
	PRINT 'SUCCESS: Users added to OCR_APP_ACCESS Role'
END 
ELSE 
BEGIN 
	PRINT 'WARNING: User already to group' 
END