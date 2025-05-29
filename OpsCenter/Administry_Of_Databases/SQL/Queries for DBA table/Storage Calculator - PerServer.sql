---Amount of storage you want to add
DECLARE @SIZE BIGINT = ''  --Add space
DECLARE @SIZE2 BIGINT = '' --Subtract space
DECLARE @PATH nvarchar(25) =''  --Path




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
  FROM [DBA].[info].[Instance] I
 cross join  [DBA].[info].[DriveUsage] D
  WHERE  Path like '%'+ @Path +'%' 
  ORDER BY MachineName,  Path ASC 

