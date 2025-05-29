
USE [master]
GO


IF EXISTS (SELECT 1 FROM sys.server_principals WHERE NAME = 'svc_ORCL_PRD01')

BEGIN
ALTER LOGIN [svc_ORCL_PRD01] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
   PRINT 'SUCCESS: Password Expiration removed!!!'

EXEC xp_cmdshell 'powershell.exe 
$server1	=  ''SQLSPRDAWEC10''
$server2	=  ''ON-SQLCLSTPRD-1''
$server3	= ''ON-SQLCLSTPRD-2''
$server4	=  ''SQLSPRDAWEC11''
$user       =  ''svc_ORCL_PRD01'' 


Sync-DbaLoginPermission -Source $server1  -Destination $server2  -Login $user 
Sync-DbaLoginPermission -Source $server1  -Destination $server3  -Login $user 
Sync-DbaLoginPermission -Source $server1  -Destination $server3  -Login $user'

SELECT name AS LoginName, 
   DATEADD(DAY, CAST(LOGINPROPERTY(name, 'DaysUntilExpiration') AS int), GETDATE()) AS ExpirationDate,
   create_date
   FROM sys.server_principals
   WHERE type = 'S'
   AND    DATEADD(DAY, CAST(LOGINPROPERTY(name, 'DaysUntilExpiration') AS int), GETDATE()) IS NOT NULL
   END
   ELSE
   BEGIN 
   PRINT 'Warning: Wrong Environment!!!'
   
   END 

