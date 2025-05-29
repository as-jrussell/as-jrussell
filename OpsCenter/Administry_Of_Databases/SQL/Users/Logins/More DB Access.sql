--Shows all users on DB whether they have access or not
SELECT
l.name as grantee_name, p.state_desc, p.permission_name FROM
sys.server_permissions AS p JOIN sys.server_principals AS l ON
p.grantee_principal_id = l.principal_id
ORDER BY permission_name ASC;


--Users that has "View Server State" permissions
SELECT
l.name as grantee_name, p.state_desc, p.permission_name FROM
sys.server_permissions AS p JOIN sys.server_principals AS l ON
p.grantee_principal_id = l.principal_id WHERE
permission_name = 'VIEW Server State' ;

----- To set "Grant" View Server to Login
GRANT VIEW SERVER STATE TO [Test1]

----- To set "Grant" View Server to AD Account or Group
GRANT VIEW SERVER STATE TO "ELDREDGE_A\UniTrac Allied Development Team" 

----- To set "Deny" View Server to Login
DENY VIEW SERVER STATE TO [Test1]

----- To set "Revoke" View Server to Login
REVOKE VIEW SERVER STATE TO [Test1]



IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'username')
DROP USER [test1]


SELECT * FROM sys.database_principals