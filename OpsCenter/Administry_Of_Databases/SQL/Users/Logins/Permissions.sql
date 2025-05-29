USE [master]

DECLARE @DBNAME nvarchar(50) = 'HDTStorage'



IF EXISTS (SELECT * FROM sys.databases WHERE name like ''+ @DBName+'%')
BEGIN



IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
from HDTStorage.sys.database_role_members dm
join HDTStorage.sys.database_principals rp on rp.principal_id = dm.role_principal_id
join HDTStorage.sys.database_principals mp on mp.principal_id = dm.member_principal_id
WHERE mp.name = 'ELDREDGE_A\Sys Admins')



BEGIN
USE [HDTStorage]
ALTER AUTHORIZATION ON DATABASE::HDTStorage TO [SA]
CREATE USER [ELDREDGE_A\Sys Admins] FOR LOGIN [ELDREDGE_A\Sys Admins]
EXEC sp_addrolemember N'db_owner', N'ELDREDGE_A\Sys Admins'
PRINT 'System Admins permissions updated to Owner Role on HDTStorage Database
and made the OWNER of the Database SA'
END
DECLARE @permissionadd VARCHAR(300);
DECLARE @accountcount VARCHAR(10);



SET @accountcount = (SELECT COUNT(*)
FROM sys.server_principals
WHERE name like 'ELDREDGE_A\SQL_%_Development_Team'
AND name not in (SELECT mp.name from HDTStorage.sys.database_role_members dm
join HDTStorage.sys.database_principals rp on rp.principal_id = dm.role_principal_id
join HDTStorage.sys.database_principals mp on mp.principal_id = dm.member_principal_id
WHERE mp.name like 'ELDREDGE_A\SQL_%_Development_Team'))



IF @accountcount <> 0



WHILE ( (SELECT count(*)
FROM sys.server_principals
WHERE name like 'ELDREDGE_A\SQL_%_Development_Team'
AND name not in (SELECT mp.name from HDTStorage.sys.database_role_members dm
join HDTStorage.sys.database_principals rp on rp.principal_id = dm.role_principal_id
join HDTStorage.sys.database_principals mp on mp.principal_id = dm.member_principal_id
WHERE mp.name like 'ELDREDGE_A\SQL_%_Development_Team')) <> 0)

BEGIN
SELECT @permissionadd = 'USE [HDTStorage] CREATE USER ['+ name+ '] FOR LOGIN ['+ name+ '];
EXEC sp_addrolemember N''db_datareader'', N'''+name+ ''''
--SELECT *
FROM sys.server_principals
WHERE name like 'ELDREDGE_A\SQL_%_Development_Team'
AND name not in (SELECT mp.name from HDTStorage.sys.database_role_members dm
join HDTStorage.sys.database_principals rp on rp.principal_id = dm.role_principal_id
join HDTStorage.sys.database_principals mp on mp.principal_id = dm.member_principal_id
WHERE mp.name like 'ELDREDGE_A\SQL_%_Development_Team')

EXEC (@permissionadd);
PRINT '
The following permission applied to give Development account DataReader Access on HDTStorage Database
: ' + (@permissionadd);
END
ELSE
BEGIN



PRINT 'Account is Perfect'



END;




END
ELSE
BEGIN
PRINT 'WARNING: Check for Database'
END





