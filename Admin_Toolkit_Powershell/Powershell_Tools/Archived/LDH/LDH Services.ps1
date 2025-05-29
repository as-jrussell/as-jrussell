Get-Service	 -ComputerName	Unitrac-WH03	 -Name	LDHSERV	|Stop-Service -Force
Get-Service	 -ComputerName	Unitrac-WH01	 -Name	LDHServicePRCPA	|Stop-Service -Force
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	ldhserviceUSD	|Stop-Service -Force
Get-Service	 -ComputerName	Unitrac-WH07	 -Name	LDHServiceHUNT	|Stop-Service -Force
Get-Service	 -ComputerName	 Unitrac-WH19	 -Name	LDHServiceSANT	|Stop-Service -Force
Get-Service	 -ComputerName	 Unitrac-WH21	 -Name	LDHWellsFargo |Stop-Service -Force