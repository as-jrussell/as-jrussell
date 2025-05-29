Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerIn| Start-Service
Get-Service	 -ComputerName	UTQA2-APP4     -Name	DirectoryWatcherServerOut| Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHSERV | Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHONEMAIN| Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceUSD| Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceHUNT| Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceSANT| Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServicePRCPA | Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService| Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService2	|Start-Service
Get-Service	 -ComputerName	UTQA2-APP2    -Name	WorkflowService3	|Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService4	|Start-Service
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService5	|Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchEvaluationProcess| Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchSendProcess| Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCCleanupProcess| Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCImportProcess| Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServicePRT |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceRPT |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceBackfeed |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceCycle |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessService|  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLMatch | Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLRematch |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceMatchOut |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	LetterGen |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLBusinessService |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVRBSS |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREDIIDR |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTDEF |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTINFO |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTUSD |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTHUNT |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTSANT |  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTPENF|  Start-Service
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVRONEMAIN|  Start-Service
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local	  -Name	UnitracBusinessServiceDist| Start-Service 
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local   -Name	UnitracBusinessServiceProc1| Start-Service
Get-Service	 -ComputerName	UTQA2-ASR2.rd.as.local	  -Name	UnitracBusinessServiceProc2| Start-Service
Get-Service	 -ComputerName	UTQA2-ASR3.rd.as.local	  -Name	UnitracBusinessServiceProc3| Start-Service