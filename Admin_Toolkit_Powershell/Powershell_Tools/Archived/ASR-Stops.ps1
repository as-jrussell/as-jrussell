Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceDist	| Stop-Service -Force


Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceProc1	| Stop-Service -Force
Get-Service	 -ComputerName	UTSTAGE-ASR2	  -Name	UnitracBusinessServiceProc2	| Stop-Service -Force
Get-Service	 -ComputerName	UTSTAGE-ASR3	  -Name	UnitracBusinessServiceProc3	| Stop-Service -Force