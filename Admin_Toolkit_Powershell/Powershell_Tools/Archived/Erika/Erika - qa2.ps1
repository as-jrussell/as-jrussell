Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerIn| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerOut| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTDEF |  Restart-Service