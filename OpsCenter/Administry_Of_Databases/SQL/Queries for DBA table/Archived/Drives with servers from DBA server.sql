SELECT [MachineName]
	  ,[Path]
      ,[TotalGB]
      ,[FreeGB]
      ,[FreePct]
      ,[Local_Net_Address]
      ,[IsClustered]
      ,[ServerEnvironment]
      ,[ServerStatus]
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  ORDER BY MachineName ASC, Path ASC 