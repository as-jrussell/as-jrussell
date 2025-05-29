USE MASTER

DECLARE @username varchar(100) ='ELDREDGE_A\SVC_DDOG_PRD01',
@count varchar(1) = 4,
@DryRun Bit = 0, 
@Validation Bit = 0

BEGIN TRAN
IF EXISTS(SELECT 1 from sys.server_principals where name = @username)

BEGIN
IF NOT EXISTS(SELECT 1 FROM sys.server_permissions what INNER JOIN sys.server_principals who ON who.principal_id = what.grantee_principal_id WHERE who.name = @username and what.permission_name = 'CONNECT SQL')
BEGIN 

EXEC ('use [master] GRANT CONNECT ANY DATABASE to ['+ @username + '] AS [sa]')

END 
ELSE 
BEGIN 
PRINT 'WARNING: '+ @username + ' HAS NOT BEEN GIVEN CONNECT ANY DATABASE. PLEASE RESEARCH.'
END 


IF NOT EXISTS(SELECT 1 FROM sys.server_permissions what INNER JOIN sys.server_principals who ON who.principal_id = what.grantee_principal_id WHERE who.name = @username and what.permission_name = 'VIEW ANY DEFINITION')
BEGIN 

EXEC ('use [master] GRANT VIEW ANY DEFINITION to ['+ @username + '] AS [sa]')
END 
ELSE 
BEGIN 

PRINT 'WARNING: '+ @username + ' HAS NOT BEEN GRANT VIEW ANY DEFINITION. PLEASE RESEARCH.'
END 



IF NOT EXISTS(SELECT 1 FROM sys.server_permissions what INNER JOIN sys.server_principals who ON who.principal_id = what.grantee_principal_id WHERE who.name = @username and what.permission_name = 'CREATE ANY DATABASE')
BEGIN 

EXEC ('use [master] GRANT CREATE ANY DATABASE to ['+ @username + '] AS [sa]')

END 
ELSE 
BEGIN 

PRINT 'WARNING: '+ @username + ' HAS NOT BEEN CREATE ANY DATABASE. PLEASE RESEARCH.'
END 



IF NOT EXISTS(SELECT 1 FROM sys.server_permissions what INNER JOIN sys.server_principals who ON who.principal_id = what.grantee_principal_id WHERE who.name = @username and what.permission_name = 'VIEW SERVER STATE')
BEGIN 

EXEC ('use [master] GRANT VIEW SERVER STATE to ['+ @username + '] AS [sa]')

END 
ELSE 
BEGIN 

PRINT 'WARNING: '+ @username + ' HAS NOT BEEN GRANT VIEW SERVER STATE. PLEASE RESEARCH.'
END 


END


IF @DryRun = 0
BEGIN

IF (select count(*)  FROM sys.server_permissions what INNER JOIN sys.server_principals who ON who.principal_id = what.grantee_principal_id WHERE who.name =  @username) = @count 
BEGIN
COMMIT
PRINT 'SUCCESS: Committing Transaction '
PRINT 'SUCCESS: '+ @username + ' HAS BEEN GIVEN CONNECT ANY DATABASE'
PRINT 'SUCCESS: '+ @username + ' HAS BEEN GIVEN GRANT VIEW ANY DEFINITION'
PRINT 'SUCCESS: '+ @username + ' HAS BEEN GIVEN CREATE ANY DATABASE'
PRINT 'SUCCESS: '+ @username + ' HAS BEEN GIVEN GRANT VIEW SERVER STATE'
END 
ELSE
BEGIN 
ROLLBACK
PRINT 'WARNING: Mismatch Rolling back Transaction'
END
END 
ELSE
BEGIN 
ROLLBACK
PRINT 'DryRun set not set to 0 Rolling back transaction below are what the transactions would be: '
PRINT ('use [master] GRANT CONNECT ANY DATABASE to ['+ @username + '] AS [sa]')
PRINT ('use [master] GRANT VIEW ANY DEFINITION to ['+ @username + '] AS [sa]')
PRINT ('use [master] CREATE ANY DATABASE to ['+ @username + '] AS [sa]')
PRINT ('use [master] GRANT VIEW SERVER STATE to ['+ @username + '] AS [sa]')

END 



IF @Validation = 0
BEGIN

SELECT
who.name AS [Principal Name],
who.type_desc AS [Principal Type],
who.is_disabled AS [Principal Is Disabled],
what.state_desc AS [Permission State],
what.permission_name AS [Permission Name]
FROM
sys.server_permissions what
INNER JOIN sys.server_principals who
ON who.principal_id = what.grantee_principal_id
WHERE
who.name = @username
ORDER BY
who.name
END 

