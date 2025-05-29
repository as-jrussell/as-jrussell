--Find out what SQL Logins
SELECT * FROM sys.server_principals
WHERE type LIKE 'S'
ORDER BY name ASC

--Find out logins 
SELECT * FROM sys.server_principals
ORDER BY name ASC

----- To set "Grant View Server to Login
GRANT VIEW SERVER STATE TO UTEmaReq


--EXEC sys.sp_who2 --@loginame = NULL -- sysname
--- Check VIEW SERVER STATE Priviledges _______
SELECT
l.name as grantee_name, p.state_desc, p.permission_name FROM
sys.server_permissions AS p JOIN sys.server_principals AS l ON
p.grantee_principal_id = l.principal_id WHERE
permission_name = 'VIEW Server State' 
ORDER BY grantee_name ASC;

 