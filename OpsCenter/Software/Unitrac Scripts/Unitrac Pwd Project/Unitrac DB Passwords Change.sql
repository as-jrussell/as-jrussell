USE [master]
GO


SELECT CONCAT('ALTER LOGIN [',p.name, '] WITH PASSWORD=N''',D.[New Pwd:],'''')
--select p.name
FROM sys.server_principals p
JOIN HDTStorage..[UTDB Updates P3] D on P.name = D.[Login Name:]


SELECT *
      FROM sys.Servers ss 
 LEFT JOIN sys.linked_logins sl 
        ON ss.server_id = sl.server_id 
 LEFT JOIN sys.server_principals ssp 
        ON ssp.principal_id = sl.local_principal_id
		WHERE sl.remote_name  in (select p.name
FROM sys.server_principals p
JOIN HDTStorage..[UTDB Updates P3] D on P.name = D.[Login Name:])

SELECT  CONVERT(DATE,[TimeStampUTC])
      ,[UserName]
      ,[NTUserName]
      ,[ServerPrincipalName]
      ,[IsSystem]
      ,[ClientHostName]
      ,[ClientAppName]
      ,[DatabaseName]
  FROM [DBA].[info].[AuditLogin]
  WHERE UserName  in (select p.name FROM sys.server_principals p JOIN HDTStorage..[UTDB Updates P3] D on P.name = D.UserName)
   AND  CONVERT(DATE,[TimeStampUTC]) >= '2021-01-01'
   ORDER BY  CONVERT(DATE,[TimeStampUTC]) DESC 

--DROP TABLE HDTStorage..[UTDB Updates P2]

