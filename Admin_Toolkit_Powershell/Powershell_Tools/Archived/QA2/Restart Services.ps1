Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerIn| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerOut| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHSERV | Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceUSD| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceHUNT| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceSANT| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServicePRCPA | Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService|  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService2	| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2    -Name	WorkflowService3	| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService4	| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService5	| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchEvaluationProcess| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchSendProcess| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCCleanupProcess| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCImportProcess| Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServicePRT |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceRPT |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceBackfeed |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceCycle |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessService|  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLMatch |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLRematch |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceMatchOut |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	LetterGen |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLBusinessService |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVRBSS |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREDIIDR |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTDEF |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTINFO |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTUSD |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTHUNT |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTSANT |  Restart-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTPENF|  Restart-Service
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local	  -Name	UnitracBusinessServiceDist| Restart-Service 
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local   -Name	UnitracBusinessServiceProc1| Restart-Service
Get-Service	 -ComputerName	UTQA2-ASR2.rd.as.local	  -Name	UnitracBusinessServiceProc2| Restart-Service
Get-Service	 -ComputerName	UTQA2-ASR3.rd.as.local	  -Name	UnitracBusinessServiceProc3| Restart-Service
