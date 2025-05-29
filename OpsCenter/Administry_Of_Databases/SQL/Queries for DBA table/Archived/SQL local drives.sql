SELECT [MachineName]
	  ,[Path]
      ,[TotalGB]
      ,[FreeGB]
      ,[FreePct]
      ,[Local_Net_Address]
      ,[IsClustered]
      ,[ServerEnvironment]
      ,[ServerStatus], D.HarvestDate,  I.HarvestDate
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE  FreePct < '15' 
    and ServerEnvironment <> '_DCOM' 
  and Path like 'C%'
  ORDER BY FreePct ASC, Path ASC 