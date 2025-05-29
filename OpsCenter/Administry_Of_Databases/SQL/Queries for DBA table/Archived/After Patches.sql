----After NonProd patch script to run 

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
  AND ServerEnvironment NOT IN ('_DCOM' , 'ADMIN', 'PROD')
  AND MachineName not in ('UNITRAC-PROD1')
  AND Path like '%C:\%'
  ORDER BY FreePct ASC, Path ASC 


  ----After Prod patch script to run 

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
  AND ServerEnvironment IN ( 'ADMIN', 'PROD')
  AND MachineName not in ('UNITRAC-PROD1')
  AND Path like '%C:\%'
  ORDER BY FreePct ASC, Path ASC 

