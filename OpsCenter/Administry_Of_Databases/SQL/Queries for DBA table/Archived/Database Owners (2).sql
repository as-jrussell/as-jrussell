
SELECT inst.SQLServerName, Inst.ServerStatus, db.*
--SELECT DISTINCT CONCAT('''', inst.SQLServerName,''',')
FROM [InventoryDWH].[inv].[Database] as DB
LEFT join [InventoryDWH].[inv].[instance] as INST ON (db.InstanceID = INST.ID)
WHERE Inst.ServerEnvironment not in ('prod','Admin')
AND [Owner] <> 'SA'
AND CAST(DB.HarvestDate AS DATE) >= CAST(GETDATE() AS DATE)
AND inst.SQLServerName NOT IN ('GP-SQLTST-01\I01', 'GP-SQLTST-01\I02', 'DBA-SQLQA-01\I01')
order by Inst.SQLServerName, DB.DatabaseName

