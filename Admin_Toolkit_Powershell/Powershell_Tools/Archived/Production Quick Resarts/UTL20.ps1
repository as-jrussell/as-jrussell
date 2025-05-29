
Get-Service  -ComputerName  Unitrac-WH09  -Name	UTLRematchDefault | Restart-Service
Get-Service  -ComputerName  Unitrac-WH14     -Name	UTLRematchMidSizeLenders | Restart-Service
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch | Restart-Service
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch2 | Restart-Service
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLRematchRepoPlus | Restart-Service
Get-Service  -ComputerName  Unitrac-WH09  -Name	UTLRematchWF | Restart-Service

Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService | Restart-Service




Get-Service  -ComputerName  Unitrac-WH09  -Name	UTLRematchDefault 
Get-Service  -ComputerName  Unitrac-WH09  -Name	UTLRematchWF
Get-Service  -ComputerName  Unitrac-WH14     -Name	UTLRematchMidSizeLenders
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch2
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLRematchRepoPlus

