Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	LDHSERV | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	LDHServiceUSD | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVRBSS | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVRDEF | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREDIIDR | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREXTHUNT | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREXTINFO | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREXTUSD | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessService | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceCycle | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceMatchIn | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceMatchOut | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServicePRT | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceRPT | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	Workflow | Restart-Service
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	LetterGen  | Restart-Service

#invoke-command -computername Unitrac-PreProd -scriptblock {iisreset /RESTART}