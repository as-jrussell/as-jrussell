

Invoke-Command -ComputerName PROPHIX-DB01 -ScriptBlock {Set-DBASpn -SPN MSSQLSvc/Prophix-DB-01.colo.as.local -ServiceAccount ELDREDGE_A\ProphixUser}
Invoke-Command -ComputerName PROPHIX-DB01 -ScriptBlock {Set-DBASpn -SPN MSSQLSvc/Prophix-DB-01.colo.as.local:1433 -ServiceAccount ELDREDGE_A\ProphixUser}



Invoke-Command -ComputerName PROPHIX-DB01 -ScriptBlock {Get-DBASpn }



Test-DBASpn -computername PROPHIX-DB-01





test-Connection -ComputerName IQQ-RPTSTG -Count 2 -Quiet