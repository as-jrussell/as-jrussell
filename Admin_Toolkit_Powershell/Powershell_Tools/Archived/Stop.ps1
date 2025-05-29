
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	ldhserviceUSD | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH03	 -Name	LDHSERV | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH04	 -Name	LDHServiceADHOC | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH07	 -Name	LDHServiceHUNT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTHUNT | Stop-Service -Force -NoWait