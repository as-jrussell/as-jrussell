Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceCycle | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServicePRT | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceMatchIn | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceMatchOut | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceRPT | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	UnitracBusinessServiceBackfeed | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	UnitracBusinessServiceMatchIn2 | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	UnitracBusinessServiceCycle2 | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceDist | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-ASR1	  -Name	UnitracBusinessServiceProc1 | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-ASR2	  -Name	UnitracBusinessServiceProc2 | Stop-Service
Get-Service	 -ComputerName	UTSTAGE-ASR3	  -Name	UnitracBusinessServiceProc3 | Stop-Service



Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle" -Recurse -ErrorAction SilentlyContinue | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServicePRT" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchIn" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchOut" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceRPT" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP1\c$\Program Files\Allied Solutions\UnitracBusinessServiceBackfeed" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP4\c$\Program Files\Allied Solutions\UnitracBusinessServiceMatchIn2" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-APP4\c$\Program Files\Allied Solutions\UnitracBusinessServiceCycle2" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceDist" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR1\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc1" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR2\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc2" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "\\UTSTAGE-ASR3\c$\Program Files\Allied Solutions\UnitracBusinessServiceProc3" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
