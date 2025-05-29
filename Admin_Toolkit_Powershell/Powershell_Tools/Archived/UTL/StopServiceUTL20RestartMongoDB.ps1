
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchDefault | Stop-Service
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchMidSizeLenders | Stop-Service
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchRepoPlus | Stop-Service
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchAdhoc | Stop-Service
Get-Service  -ComputerName  Unitrac-WH23  -Name	UTLRematchDefaultWellsFargo | Stop-Service
Get-Service  -ComputerName  Unitrac-WH23 -Name	UTLRematchDefaultSantander | Stop-Service


Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService | Stop-Service 

Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch | Stop-Service
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch2 | Stop-Service



Get-Service -ComputerName MongoDB-PROD-01 -Name MongoDB | Restart-Service



Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchDefault | Start-Service
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchMidSizeLenders | Start-Service
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchRepoPlus | Start-Service
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchAdhoc | Start-Service
Get-Service  -ComputerName  Unitrac-WH23  -Name	UTLRematchDefaultWellsFargo | Start-Service
Get-Service  -ComputerName  Unitrac-WH23 -Name	UTLRematchDefaultSantander | Start-Service


Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService | Start-Service 

Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch | Start-Service
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch2 | Start-Service





Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchDefault 
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchMidSizeLenders 
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchRepoPlus 
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchAdhoc 
Get-Service  -ComputerName  Unitrac-WH23  -Name	UTLRematchDefaultWellsFargo 
Get-Service  -ComputerName  Unitrac-WH23 -Name	UTLRematchDefaultSantander 


Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService  

Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch 
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch2 