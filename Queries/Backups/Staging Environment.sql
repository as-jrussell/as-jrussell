SELECT [MachineName]
	  ,[Path]
      ,[TotalGB]
      ,[FreeGB]
      ,[FreePct]
      ,[Local_Net_Address]
      ,[IsClustered]
      ,[ServerEnvironment]
      ,[ServerStatus], D.HarvestDate
	 -- select DISTINCT SQLServerName, I.HarvestDate
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE CAST(I.HarvestDate AS DATE) = CAST(GETDATE() AS DATE)
	--AND MachineName IN ('ON-SQLCLSTPRD-1','ON-SQLCLSTPRD-2','DB-SQLCLST-01-1') and Path like '%E:\%'
	AND ServerEnvironment <> '_DCOM' 
  --ORDER BY MachineName ASC, Path ASC 



  --SELECT top 1 * FROM [InventoryDWH].[inv].[Application]   order by ApplicationID desc