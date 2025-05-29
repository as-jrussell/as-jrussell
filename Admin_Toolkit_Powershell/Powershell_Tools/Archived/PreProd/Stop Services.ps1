Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	LDHSERV | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	LDHServiceUSD | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVRBSS | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVRDEF | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREDIIDR | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREXTHUNT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREXTINFO | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	MSGSRVREXTUSD | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessService | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceCycle | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceMatchIn | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceMatchOut | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServicePRT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	UnitracBusinessServiceRPT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	Workflow | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPREPROD-APP01.colo.as.local	  -Name	LetterGen  | Stop-Service -Force -NoWait


Get-Service	 -ComputerName	Unitrac-APP01	 -Name	UnitracBusinessService | Stop-Service