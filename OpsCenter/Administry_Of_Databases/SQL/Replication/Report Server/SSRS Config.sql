/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ConfigInfoID]
      ,[Name]
      ,[Value]
  FROM [ReportServer].[dbo].[ConfigurationInfo]