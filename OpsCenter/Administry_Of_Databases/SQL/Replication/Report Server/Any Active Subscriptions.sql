/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ActiveID]
      ,[SubscriptionID]
      ,[TotalNotifications]
      ,[TotalSuccesses]
      ,[TotalFailures]
  FROM [ReportServer].[dbo].[ActiveSubscriptions]