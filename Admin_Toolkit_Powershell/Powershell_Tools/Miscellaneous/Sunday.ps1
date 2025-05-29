
Set-Service	 -ComputerName	UTPROD-ASR1	 -Name	UnitracBusinessServiceDist	 -StartupType Automatic
Set-Service	 -ComputerName	UTPROD-ASR2	 -Name	UnitracBusinessServiceProc1	-StartupType Automatic 
Set-Service	 -ComputerName	UTPROD-ASR3	 -Name	UnitracBusinessServiceProc2	-StartupType Automatic 
Set-Service	 -ComputerName	UTPROD-ASR4	 -Name	UnitracBusinessServiceProc4	-StartupType Automatic 
Set-Service	 -ComputerName	UTPROD-ASR5	 -Name	UnitracBusinessServiceProc5	-StartupType Automatic 
Set-Service	 -ComputerName	UTPROD-ASR6	 -Name	UnitracBusinessServiceProc6	-StartupType Automatic 
Set-Service	 -ComputerName	UTPROD-ASR7	 -Name	UnitracBusinessServiceProc7	-StartupType Automatic 
Set-Service	 -ComputerName	UTPROD-ASR8	 -Name	UnitracBusinessServiceProc8	-StartupType Automatic 
Set-Service	 -ComputerName	UTPROD-ASR9	 -Name	UnitracBusinessServiceProc9	-StartupType Automatic 

Get-Service	 -ComputerName	UTPROD-ASR1	 -Name	UnitracBusinessServiceDist	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR2	 -Name	UnitracBusinessServiceProc1	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR3	 -Name	UnitracBusinessServiceProc2	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR4	 -Name	UnitracBusinessServiceProc4	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR5	 -Name	UnitracBusinessServiceProc5	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR6	 -Name	UnitracBusinessServiceProc6	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR7	 -Name	UnitracBusinessServiceProc7	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR8	 -Name	UnitracBusinessServiceProc8	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR9	 -Name	UnitracBusinessServiceProc9	| Start-Service




Invoke-Command -ComputerName  UTPROD-ASR1 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR2 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR3 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR4 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR5 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR6 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR7 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR8 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
Invoke-Command -ComputerName  UTPROD-ASR9 -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}}
