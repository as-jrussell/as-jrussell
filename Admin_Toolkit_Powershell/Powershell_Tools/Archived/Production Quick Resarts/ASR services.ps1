Get-Service	 -ComputerName	utprod-asr1.colo.as.local	 -Name	UnitracBusinessServiceDist |Restart-Service
Get-Service	 -ComputerName	utprod-asr2.colo.as.local  -Name	UnitracBusinessServiceProc1 |Restart-Service
Get-Service	 -ComputerName	utprod-asr3.colo.as.local -Name	UnitracBusinessServiceProc2 |Restart-Service

Get-Service	 -ComputerName	utprod-asr4.colo.as.local	 -Name	UnitracBusinessServiceProc4 |Restart-Service
Get-Service	 -ComputerName	utprod-asr5.colo.as.local	 -Name	UnitracBusinessServiceProc5 |Restart-Service
Get-Service	 -ComputerName	utprod-asr6.colo.as.local -Name	UnitracBusinessServiceProc6 |Restart-Service
Get-Service	 -ComputerName	utprod-asr7.colo.as.local -Name	UnitracBusinessServiceProc7 |Restart-Service