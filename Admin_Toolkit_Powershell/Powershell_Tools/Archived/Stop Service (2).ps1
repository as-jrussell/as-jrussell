Get-Service	 -ComputerName	Unitrac-APP01	 -Name	UnitracBusinessService | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-APP01	 -Name	FAXAssistService | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	ldhserviceUSD | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	UnitracBusinessServiceCycle | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	UnitracBusinessServicePRT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	UnitracBusinessServiceFax | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH01	 -Name	LDHServicePRCPA | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH03	 -Name	LDHSERV | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH04	 -Name	WorkflowService | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH04	 -Name	LDHServiceADHOC | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH05	 -Name	UnitracBusinessServiceMatchOut | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH06	 -Name	UnitracBusinessServiceRPT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH07	 -Name	LDHServiceHUNT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	Unitrac-WH07	 -Name	UnitracBusinessServiceFEE | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVRBSS | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREDIIDR | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVRDEF | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTUSD | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTPENF | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVRADHOC | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTINFO | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTHUNT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTGATE | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchDefault | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchRepoPlus | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH22     -Name	UTLRematchMidSizeLenders | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchAdhoc | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH10	 -Name	WorkflowService2 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH11	 -Name	WorkflowService3 | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name LIMCExportSoftfile | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name LIMCOCR | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name LIMCExport | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchEvaluationProcess | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchSendProcess | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCCleanupProcess | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCImportProcess | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH13	 -Name	WorkflowService4 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH13	 -Name	UnitracBusinessServiceBackfeed | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH14	 -Name	DirectoryWatcherServerIn | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH14	 -Name	DirectoryWatcherServerOut | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH23  -Name	UTLRematchDefaultWellsFargo | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH23  -Name	UTLRematchDefaultSantander | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch | Stop-Service -Force -NoWait
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch2 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH18	 -Name	LetterGen | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH19	 -Name	MSGSRVREXTSANT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH19	 -Name	LDHServiceSANT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH20	 -Name	WorkflowService5 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH20	 -Name	UnitracBusinessServiceCycleSANT | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH20	 -Name	UnitracBusinessServiceCycleSANT2 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH21	 -Name	MSGSRVREXTWellsFargo | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	 Unitrac-WH21	 -Name	LDHWellsFargo | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr1.colo.as.local	 -Name	UnitracBusinessServiceDist | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr2.colo.as.local  -Name	UnitracBusinessServiceProc1 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr3.colo.as.local -Name	UnitracBusinessServiceProc2 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr4.colo.as.local	 -Name	UnitracBusinessServiceProc4 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr5.colo.as.local	 -Name	UnitracBusinessServiceProc5 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr6.colo.as.local -Name	UnitracBusinessServiceProc6 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr7.colo.as.local -Name	UnitracBusinessServiceProc7 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr8.colo.as.local -Name	UnitracBusinessServiceProc8 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr9.colo.as.local -Name	UnitracBusinessServiceProc9| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	utprod-asr10.colo.as.local -Name	UnitracBusinessServiceProc10 | Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService  | Stop-Service -Force -NoWait
Set-Service  -ComputerName	 Unitrac-WH18	 -Name	OAIOperationalDashboard   -StartupType Disabled
Set-Service  -ComputerName	 Unitrac-WH18	 -Name	OAILenderDashboard   -StartupType Disabled
Set-Service  -ComputerName	 Unitrac-WH18	 -Name	Dashboard   -StartupType Disabled


