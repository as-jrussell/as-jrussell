
SELECT inst.SQLServerName, Inst.ServerStatus, db.*
--SELECT DISTINCT CONCAT('''', inst.SQLServerName,''',')
FROM [InventoryDWH].[inv].[Database] as DB
LEFT join [InventoryDWH].[inv].[instance] as INST ON (db.InstanceID = INST.ID)
WHERE Inst.ServerEnvironment not in ('prod','Admin')
AND RecoveryModel != 'Simple'
AND Inst.SQLServerName not like ('OCR-SQL%')
AND Inst.SQLServerName not like ('cp-SQL%')
AND Inst.SQLServerName  not like ('UTStage-SQL-0%')
AND Inst.ServerStatus != 'DOWN'
AND CAST(DB.HarvestDate AS DATE) >= CAST(GETDATE()-1 AS DATE)
order by Inst.SQLServerName, DB.DatabaseName

