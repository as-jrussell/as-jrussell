DECLARE @Machine nvarchar(50) = 'utqa-sql-14' 


SELECT [MachineName]
	  ,[Path]
      ,[TotalGB]
      ,[FreeGB]
	   ,([TotalGB] -[FreeGB]) [UsedGB]
      ,[FreePct]
	  ,I.MAX_SIZE_SERVER_MEMORY_MB
      ,[Local_Net_Address]
      ,[IsClustered]
      ,[ServerEnvironment]
      ,[ServerStatus]
	  , D.HarvestDate
	  ,I.HarvestDate [Instance_HarvestDate]
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE  
   MachineName  like '%'+ @Machine +'%' 
  ORDER BY FreePct ASC, Path ASC 

