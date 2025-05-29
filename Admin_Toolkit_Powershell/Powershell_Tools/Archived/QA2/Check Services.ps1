Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerIn| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	DirectoryWatcherServerOut| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHSERV | select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceUSD| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceHUNT| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServiceSANT| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	LDHServicePRCPA | select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService2	|select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2    -Name	WorkflowService3	|select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService4	|select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP2	  -Name	WorkflowService5	|select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchEvaluationProcess| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCBatchSendProcess| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCCleanupProcess| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	QCImportProcess| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServicePRT |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceRPT |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceBackfeed |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceCycle |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessService|  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLMatch |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLRematch |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UnitracBusinessServiceMatchOut |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	LetterGen |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP3	  -Name	UTLBusinessService |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVRBSS |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREDIIDR |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTDEF |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTINFO |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTUSD |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTHUNT |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTSANT |  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-APP4	  -Name	MSGSRVREXTPENF|  select machinename, name, status
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local	  -Name	UnitracBusinessServiceDist| select machinename, name, status 
Get-Service	 -ComputerName	UTQA2-ASR1.rd.as.local   -Name	UnitracBusinessServiceProc1| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-ASR2.rd.as.local	  -Name	UnitracBusinessServiceProc2| select machinename, name, status
Get-Service	 -ComputerName	UTQA2-ASR3.rd.as.local	  -Name	UnitracBusinessServiceProc3| select machinename, name, status