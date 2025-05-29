/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UserID]
      ,[Sid]
      ,[UserType]
      ,[AuthType]
      ,[UserName]
  FROM [ReportServer].[dbo].[Users]