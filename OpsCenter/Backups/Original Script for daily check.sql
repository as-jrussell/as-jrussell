Run this script and act accordingly to it the work that needs to go with it. 

SELECT count(*) [TempDB under 15%]
--select I.SQLSERVERNAME, D.*
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE Path like '%TEMPDB%' and
  FreePct < '15'
  and ServerEnvironment <> '_DCOM' 


  
SELECT count(*) [Logs under 15%]
--select I.SQLSERVERNAME, D.*
FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE Path like '%Logs' and FreePct < '15'
  and ServerEnvironment <> '_DCOM' 


  
SELECT count(*) [Local Drive under 15%]
--select I.SQLSERVERNAME, D.*
FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE  FreePct < '15' 
    and ServerEnvironment <> '_DCOM' 
  and Path like 'C%'

SELECT count(*) [Count of owners no SA]
--select I.SQLSERVERNAME, D.* 
 FROM [InventoryDWH].[inv].[Database] as DB
LEFT join [InventoryDWH].[inv].[instance] as INST ON (db.InstanceID = INST.ID)
WHERE Inst.ServerEnvironment not in ('prod','Admin')
AND [Owner] <> 'SA'
AND CAST(DB.HarvestDate AS DATE) >= CAST(GETDATE() AS DATE)
AND inst.SQLServerName NOT IN ('GP-SQLTST-01\I01', 'GP-SQLTST-01\I02', 'DBA-SQLQA-01\I01')

SELECT count(*) [Count of database not in SIMPLE recovery]
--select I.SQLSERVERNAME, D.*
FROM [InventoryDWH].[inv].[Database] as DB
LEFT join [InventoryDWH].[inv].[instance] as INST ON (db.InstanceID = INST.ID)
WHERE Inst.ServerEnvironment not in ('prod','Admin')
AND RecoveryModel != 'Simple'
AND Inst.SQLServerName not like ('OCR-SQL%')
AND Inst.SQLServerName not like ('cp-SQL%')
AND Inst.ServerStatus != 'DOWN'
AND CAST(DB.HarvestDate AS DATE) >= CAST(GETDATE() AS DATE)



SELECT count(*) [Other Drives under 15%]
--select I.SQLSERVERNAME, D.*
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE  FreePct < '15' 
    and Path not like 'C%'
	and Path not like '%TEMPDB%' 
	and Path not like '%Logs%'
	and ServerEnvironment <> '_DCOM' 
	and MachineName !=('UNITRAC-PROD1')



	
  select DISTINCT CONCAT('.\Harvest-Inventory.ps1 -TargetHost', ' ',  I.[SQLServerName],' ','-TargetInvServer "DBA-SQLPRD-01\I01" -TargetInvDB "InventoryDWH" -DryRun 0'), HF.*
--select hf.*
FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  Left  join [InventoryDWH].[Info].[HarvestFailures] HF on HF.SQLServerName = I.SQLServerName
    WHERE  CAST(HF.Daterun AS DATE) = CAST(GETDATE() AS DATE) and 
    ServerEnvironment <> '_DCOM' and ProductName <> 'Microsoft SQL Azure'
	order by Daterun asc
