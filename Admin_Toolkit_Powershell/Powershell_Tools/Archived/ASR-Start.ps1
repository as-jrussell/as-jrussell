Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceDist	| Start-Service

Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceProc1	| Start-Service
Get-Service	 -ComputerName	UTSTAGE-ASR2	  -Name	UnitracBusinessServiceProc2	| Start-Service
Get-Service	 -ComputerName	UTSTAGE-ASR3	  -Name	UnitracBusinessServiceProc3	| Start-Service