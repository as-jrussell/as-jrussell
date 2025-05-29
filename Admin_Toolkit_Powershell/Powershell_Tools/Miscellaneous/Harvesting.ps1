<# 

cd ..
Set-Location "C:\GitHub\DBA-PowerShell\DBA-Tools\DBA_Tools"

Get-DbaAgentJob -SqlInstance ivos-sql-02   -Job DBA-HarvestDaily

Get-DbaAgentJob -SqlInstance ON-SQLCLSTPRD-1  -Job DBA-HarvestDaily
Get-DbaAgentJob -SqlInstance DB-SQLCLST-01-1 -Job DBA-HarvestDaily
Get-DbaAgentJob -SqlInstance utl-sql-01 -Job DBA-HarvestDaily

Get-DbaAgentJob -SqlInstance UT-SQLDEV-01 -Job DBA-HarvestDaily
Get-DbaAgentJob -SqlInstance OCR-SQLPRD-05 -Job DBA-HarvestDaily
Get-DbaAgentJob -SqlInstance OCR-SQLPRD-06 -Job DBA-HarvestDaily

#>

Set-Location "C:\GitHub\DBA-PowerShell\DBA-Tools\DBA_Tools"
.\Harvest-Inventory.ps1 -TargetHost UTQA-UTL1 -TargetInvServer "DBA-SQLPRD-01\I01" -TargetInvDB "InventoryDWH" -DryRun 0


Get-DBASpn  -computername PROPHIX-DB-01


Test-DBASpn  -computername PROPHIX-DB-01


#Set-DBASpn -SPN MSSQLSvc/Prophix-DB-01.colo.as.local -ServiceAccount ELDREDGE_A\PROPHIX-Daemon-PROD
#Set-DBASpn -SPN MSSQLSvc/Prophix-DB-01.colo.as.local:1433 -ServiceAccount ELDREDGE_A\PROPHIX-Daemon-PROD

.\Harvest-Inventory.ps1 -TargetHost IQQ-RPTSTG -TargetInvServer "DBA-SQLPRD-01\I01" -TargetInvDB "InventoryDWH" -DryRun 0

nslookup 172.20.25.116


get-SQLServiceStatus OCR-SQLTMP-01 'Instance' -eq "Running"


Get-DbaAgentJob -SqlInstance prophix-db-01  -Job DBA-HarvestDaily

Start-DbaAgentJob -SqlInstance UT-SQLDEV-01  -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance UT-SQLSTG-01   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance ALLIED-UT-DEV2   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance SQLSDEVAWEC01   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance UTQA-SQL-14   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance OCR-SQLPRD-06   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance OCR-SQLTST-07  -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance OCR-SQLTST-08   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance OCR-SQLTST-09   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance OCR-SQLTST-10   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance OCR-SQLTST-11   -Job DBA-HarvestDaily
Start-DbaAgentJob -SqlInstance OCR-SQLTST-12   -Job DBA-HarvestDaily


nslookup SW-ORION-01.colo.as.local



nslookup   10.9.17.53


Invoke-Sqlcmd -ServerInstance PingFed-DV-01 -Database Pingfederate -








ddbmexptool.exe -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=DBK-DD9300-01" -a "CLIENT=OCR-SQLTMP-01.rd.as.local" -a MSSQL -e "5/19/2022"
ddbmexptool.exe -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=DBK-DD9300-01" -a "CLIENT=OCR-SQLTMP-02.rd.as.local" -a MSSQL -e "5/19/2022"
ddbmexptool.exe -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=DBK-DD9300-01" -a "CLIENT=OCR-SQLTMP-03.rd.as.local" -a MSSQL -e "5/19/2022"
ddbmexptool.exe -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=DBK-DD9300-01" -a "CLIENT=OCR-SQLTMP-04.rd.as.local" -a MSSQL -e "5/19/2022"
ddbmexptool.exe -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=DBK-DD9300-01" -a "CLIENT=OCR-SQLTMP-05.rd.as.local" -a MSSQL -e "5/19/2022"
ddbmexptool.exe -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=DBK-DD9300-01" -a "CLIENT=OCR-SQLTMP-06.rd.as.local" -a MSSQL -e "5/19/2022"