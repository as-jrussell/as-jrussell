SELECT [MachineName]
	  ,[Path]
      ,[TotalGB]
      ,[FreeGB]
      ,[FreePct]
      ,[Local_Net_Address]
      ,[IsClustered]
      ,[ServerEnvironment]
      ,[ServerStatus], D.HarvestDate
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE Path like '%Logs' and FreePct < '20'
  and ServerEnvironment <> '_DCOM' 
  ORDER BY FreePct ASC, Path ASC 