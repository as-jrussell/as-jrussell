
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchDefault | Stop-Service
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchMidSizeLenders | Stop-Service
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchRepoPlus | Stop-Service
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchAdhoc | Stop-Service
Get-Service  -ComputerName  Unitrac-WH015  -Name	UTLRematchDefaultWellsFargo | Stop-Service
Get-Service  -ComputerName  Unitrac-WH016 -Name	UTLRematchDefaultSantander | Stop-Service


Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService | Stop-Service 

Get-Service  -ComputerName  Unitrac-WH013  -Name	UTLMatch | Stop-Service
Get-Service  -ComputerName  Unitrac-WH013  -Name	UTLMatch2 | Stop-Service






