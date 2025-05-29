---Amount of storage you want to add
DECLARE @SIZE BIGINT = ''  --Add space
DECLARE @SIZE2 BIGINT = '' --Subtract space
DECLARE @Machine nvarchar(50) = ''  --Server
DECLARE @PATH nvarchar(25) = ''  --Path


SELECT [MachineName] 
	   ,[Path]
	  ,[TotalGB]+@size [NewStorageTotalGB]
	  ,[TotalGB]+@size -@SIZE2 [NewStorageTotalRemainingGB]
	  ,[FreeGB]-@size2+@size [NewRemainingCurrentFreeGB]
	  ,CONVERT(decimal,(([FreeGB]+@size-@size2)/([TotalGB]+@size+.00))*100) [NewCurrentUsedGB %] 
	  ,[TotalGB] [CurrentTotalGB]
      ,[FreeGB] [CurrentFreeGB]
      ,[FreePct] [CurrentFreePct]
	  ,@SIZE2 [How much being removed GB]
	   ,@SIZE [How much being added GB] 
	  ,[Local_Net_Address]
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE   MachineName like '%'+ @Machine +'%' 
  and Path like '%'+ @Path +'%' 
  ORDER BY MachineName,  Path ASC 




  /*
	--,([FreeGB]+@size-@size2)/([TotalGB]+@size+.00)*100

	if space is able to be recovered from a drive
	  ,CONVERT(INT,(([FreeGB]+@size2)/([TotalGB]+@size+.00))*100) [CurrentUsedGB %] 
  */


