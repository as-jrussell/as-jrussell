$RestartService = "E:\logs\RestartLDHUSD"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $RestartService


Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceCycle |  Restart-Service

Stop-Transcript