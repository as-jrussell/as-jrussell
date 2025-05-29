Get-Service	 -ComputerName	UNITRAC-WH01	  -Name	LDHServicePRCPA	|  Stop-Service -NoWait -Force

Get-Service	 -ComputerName	UNITRAC-APP02	  -Name	LDHServiceUSD	|  Stop-Service -NoWait -Force