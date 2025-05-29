DECLARE @Machine nvarchar(50) ='utqa-sql-14'


SELECT '[Failed Linked Servers]' , [MachineName],[Data_source],[Provider_string],[Remote_name],LNK.[Status]
  FROM [InventoryDWH].[inv].[LinkedServer] LNK
 join [InventoryDWH].[inv].[instance] as INST ON (LNK.InstanceID = INST.ID)
  WHERE  MachineName  like '%'+ @Machine +'%'
    AND LNK.[Status] <> 'Valid'

select '[Count of owners no SA]' ,  INST.SQLSERVERNAME, [Owner], INST.* 
 FROM [InventoryDWH].[inv].[Database] as DB
LEFT join [InventoryDWH].[inv].[instance] as INST ON (db.InstanceID = INST.ID)
  WHERE  MachineName  like '%'+ @Machine +'%' 
 AND [Owner] <> 'SA' 
 AND  Inst.ServerEnvironment not in ('prod','Admin') 
AND inst.SQLServerName NOT IN ('GP-SQLTST-01\I01', 'GP-SQLTST-01\I02', 'DBA-SQLQA-01\I01')

select '[Count of database not in SIMPLE recovery]' ,  INST.SQLSERVERNAME, RecoveryModel, DB.*
FROM [InventoryDWH].[inv].[Database] as DB
LEFT join [InventoryDWH].[inv].[instance] as INST ON (db.InstanceID = INST.ID)
  WHERE  MachineName  like '%'+ @Machine +'%'
AND RecoveryModel != 'Simple'
AND Inst.SQLServerName not like ('OCR-SQL%')
AND Inst.SQLServerName not like ('cp-SQL%')
AND Inst.ServerStatus != 'DOWN'
AND Inst.ServerEnvironment not in ('prod','Admin')

select '[Local Drive under 15%]', I.SQLSERVERNAME, D.*
 FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
   WHERE  MachineName  like '%'+ @Machine +'%'
      AND  FreePct < '3' 
    and ServerEnvironment <> '_DCOM' 
  and Path like 'C%'


select '[TempDB under 15%]', I.SQLSERVERNAME, D.*
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
  WHERE  MachineName  like '%'+ @Machine +'%'
  AND Path like '%TEMPDB%' and
  FreePct < '15'
  and ServerEnvironment <> '_DCOM' 

  
SELECT '[Logs under 15%]', I.SQLSERVERNAME, D.*
 FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
   WHERE  MachineName  like '%'+ @Machine +'%'
   AND Path like '%Logs' and FreePct < '15'
  and ServerEnvironment <> '_DCOM' 

SELECT '[Other Drives under 15%]', I.SQLSERVERNAME, D.*
  FROM [InventoryDWH].[inv].[Instance] I
  join [InventoryDWH].[inv].[DriveUsage] D on I.ID = D.InstanceID
   WHERE  MachineName  like '%'+ @Machine +'%'
   AND Path not like 'C%'
	AND Path not like '%TEMPDB%' 
	AND Path not like '%Logs%'
	AND ServerEnvironment <> '_DCOM' 
	AND FreePct < CASE WHEN  Path  like '%:\SQL\Data05\Data05%' then '8'
	 WHEN  MachineName IN ('UNITRAC-PROD1','UIPA-TST-DB1') then '3'
	ELSE  '15'
	END