/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Path]
      ,[Hostname]
      ,[TotalGB]
      ,[FreeGB]
      ,[FreePct]
     -- ,[SpacetobeAdded]
   --   ,[DaysToEmpty]
      ,[HarvestDate]
  FROM [PerfStats].[dbo].[DriveUsage]



--C:\	DBA-SQLQA-01	59.46	26.02	44.10	2023-05-24 07:04:01.820
--C:\	DBA-SQLQA-01	59.46	26.14	44.31	2023-05-24 08:49:01.433
--C:\	DBA-SQLQA-01	59.46	26.36	44.68	2023-05-24 09:11:01.383