DECLARE @SQLServername VARCHAR(100) ='' --SQL Instance Name

IF @@SERVERNAME = 'DBA-SQLPRD-01\I01'
BEGIN 
IF @SQLServername IS NOT NULL
BEGIN 
select CONCAT('Start-DbaAgentJob -SqlInstance ',SQLServerName,' -Job DBA-HarvestDaily'),CONCAT('C:\GitHub\DBA-PowerShell\DBA-Tools\DBA_Tools\Harvest-Inventory.ps1 -TargetHost ',SQLServerName,' -targetInvServer "DBA-SQLPRD-01.colo.as.local\I01" -targetInvDB "InventoryDWH" -Force 1 -dryRun 0')

	FROM   [InventoryDWH].[inv].[Instance] I 
	WHERE SQLServerName = 
                        @SQLServername 

END
ELSE 
BEGIN 
select CONCAT('Start-DbaAgentJob -SqlInstance ',SQLServerName,' -Job DBA-HarvestDaily'),CONCAT('C:\GitHub\DBA-PowerShell\DBA-Tools\DBA_Tools\Harvest-Inventory.ps1 -TargetHost ',SQLServerName,' -targetInvServer "DBA-SQLPRD-01.colo.as.local\I01" -targetInvDB "InventoryDWH" -Force 1 -dryRun 0')

						FROM   [InventoryDWH].[inv].[Instance] I
WHERE  Cast(HarvestDate AS DATE) != Cast(Getdate() AS DATE)
       AND ServerEnvironment <> '_DCOM'
       AND ( ServerLocation IN ( 'ON-PREM', 'AWS-EC2', '' )
              OR ServerLocation IS NULL )
END 
END 
BEGIN 
select CONCAT('Start-DbaAgentJob -SqlInstance ',SQLServerName,' -Job DBA-HarvestDaily'),CONCAT('C:\GitHub\DBA-PowerShell\DBA-Tools\DBA_Tools\Harvest-Inventory.ps1 -TargetHost ',SQLServerName,' -targetInvServer "DBA-SQLPRD-01.colo.as.local\I01" -targetInvDB "InventoryDWH" -Force 1 -dryRun 0')

						FROM   [DBA].[info].[Instance] I
END