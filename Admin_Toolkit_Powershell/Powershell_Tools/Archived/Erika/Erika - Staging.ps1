
Get-Service	 -ComputerName	UTSTAGE-APP4	  -Name	MSGSRVREXTDEF	|  Restart-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	DirectoryWatcherServerIn	|  Restart-Service
Get-Service	 -ComputerName	UTSTAGE-APP1	  -Name	DirectoryWatcherServerOut	|  Restart-Service



