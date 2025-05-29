/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [TimeStampUTC]
      ,[UserName]
      ,[NTUserName]
      ,[ServerPrincipalName]
      ,[IsSystem]
      ,[ClientHostName]
      ,[ClientAppName]
      ,[DatabaseName]
  FROM [DBA].[info].[AuditLogin]
  where UserName like '%sql2000%'