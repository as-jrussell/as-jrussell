


Set-Service  -ComputerName	 Unitrac-WH05	 -Name	UnitracBusinessServiceMatchInE  -StartupType Disabled


Set-Service  -ComputerName	 UNITRAC-WH14	 -Name	UnitracBusinessServiceMatchIn16  -StartupType Disabled


Get-Service  -ComputerName   UNITRAC-WH14	 -Name	UnitracBusinessServiceMatchIn16 | Stop-Service




Get-Service  -ComputerName   Unitrac-WH05	 -Name	UnitracBusinessServiceMatchInE | Stop-Service



Get-Service -ComputerName	 Unitrac-WH05	 -Name	UnitracBusinessServiceMatchInD