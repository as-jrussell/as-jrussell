
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchDefault |Start-Service
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchMidSizeLenders |Start-Service
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchRepoPlus |Start-Service
Get-Service  -ComputerName  Unitrac-WH014  -Name	UTLRematchAdhoc |Start-Service
Get-Service  -ComputerName  Unitrac-WH015  -Name	UTLRematchDefaultWellsFargo |Start-Service
Get-Service  -ComputerName  Unitrac-WH016 -Name	UTLRematchDefaultSantander |Start-Service


Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService |Start-Service 

Get-Service  -ComputerName  Unitrac-WH013  -Name	UTLMatch |Start-Service
Get-Service  -ComputerName  Unitrac-WH013  -Name	UTLMatch2 |Start-Service
