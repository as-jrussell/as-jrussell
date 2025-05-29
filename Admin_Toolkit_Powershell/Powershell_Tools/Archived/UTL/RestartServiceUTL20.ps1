
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchDefault | Restart-Service
Get-Service  -ComputerName  Unitrac-WH014     -Name	UTLRematchMidSizeLenders | Restart-Service
Get-Service  -ComputerName  Unitrac-WH014 -Name	UTLRematchRepoPlus | Restart-Service
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchAdhoc | Restart-Service
Get-Service  -ComputerName  Unitrac-WH015  -Name	UTLRematchDefaultWellsFargo | Restart-Service
Get-Service  -ComputerName  Unitrac-WH016 -Name	UTLRematchDefaultSantander | Restart-Service



Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService | Restart-Service 

Get-Service  -ComputerName  Unitrac-WH013  -Name	UTLMatch | Restart-Service
Get-Service  -ComputerName  Unitrac-WH013  -Name	UTLMatch2 | Restart-Service


