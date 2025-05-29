$RestartService = "C:\logs\RestartLDHUSD"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $RestartService

Get-Service	 -ComputerName	Unitrac-APP02	 -Name	ldhserviceUSD |Restart-Service


Stop-Transcript