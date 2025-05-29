Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerIn| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerOut| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHSERV | Stop-Service -Force -Nowait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceUSD| Stop-Service -Force -Nowait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHONEMAIN|  Stop-Service -Force -Nowait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceHUNT| Stop-Service -Force -Nowait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceSANT| Stop-Service -Force -Nowait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServicePRCPA | Stop-Service -Force -Nowait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService2	|Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP2    -Name	WorkflowService3	|Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService4	|Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService5	|Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchEvaluationProcess| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchSendProcess| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCCleanupProcess| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCImportProcess| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServicePRT |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceRPT |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceBackfeed |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceCycle |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessService|  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLMatch |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLRematch |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceMatchOut |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	LetterGen |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLBusinessService |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVRBSS |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREDIIDR |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTDEF |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTINFO |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTUSD |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTHUNT |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTSANT |  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTPENF|  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVRONENMAIN|  Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local	  -Name	UnitracBusinessServiceDist| Stop-Service -Force -NoWait 
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local   -Name	UnitracBusinessServiceProc1| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-ASR2.rd.as.local	  -Name	UnitracBusinessServiceProc2| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTQA2-ASR3.rd.as.local	  -Name	UnitracBusinessServiceProc3| Stop-Service -Force -NoWait






