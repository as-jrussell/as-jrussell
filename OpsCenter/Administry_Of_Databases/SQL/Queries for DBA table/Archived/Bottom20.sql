SELECT [MachineName]
	  ,[Path]
      ,[TotalGB]
      ,[FreeGB]
	  ,([TotalGB] - [FreeGB]) [UsedGB]
      ,[FreePct]
      ,[Local_Net_Address]
      ,[IsClustered]
      ,[ServerEnvironment]
      ,[ServerStatus], D.HarvestDate,  I.HarvestDate
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE FreePct < '15'   
  AND CAST(D.HarvestDate AS DATE) = CAST(GETDATE() AS DATE)
  AND ServerEnvironment <> '_DCOM' 
  AND MachineName not in ('UNITRAC-PROD1')
	ORDER BY FreePct ASC, Path ASC 


--	select (5503 / 6385. -  1 ) * -100