﻿Get-Service	 -ComputerName	Unitrac-APP01	 -Name	UnitracBusinessService |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-APP01	 -Name	FAXAssistService |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	ldhserviceUSD |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	UnitracBusinessServiceCycle |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	UnitracBusinessServicePRT |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-APP02	 -Name	UnitracBusinessServiceFax |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH01	 -Name	LDHServicePRCPA |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH03	 -Name	LDHSERV |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH04	 -Name	WorkflowService |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH04	 -Name	LDHServiceADHOC |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH05	 -Name	UnitracBusinessServiceMatchOut |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH06	 -Name	UnitracBusinessServiceRPT |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH07	 -Name	LDHServiceHUNT |  select machinename, name, status
Get-Service	 -ComputerName	Unitrac-WH07	 -Name	UnitracBusinessServiceFEE |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVRBSS |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREDIIDR |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVRDEF |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTUSD |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTPENF |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVRADHOC |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTINFO |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTHUNT |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH08	 -Name	MSGSRVREXTGATE |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchDefault |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchRepoPlus |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH22     -Name	UTLRematchMidSizeLenders |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH22  -Name	UTLRematchAdhoc |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH10	 -Name	WorkflowService2 |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH11	 -Name	WorkflowService3 |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH12  -Name LIMCExportSoftfile | select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH12  -Name LIMCOCR | select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH12  -Name LIMCExport | select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchEvaluationProcess |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCBatchSendProcess |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCCleanupProcess |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH12  -Name	QCImportProcess |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH13	 -Name	WorkflowService4 |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH13	 -Name	UnitracBusinessServiceBackfeed |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH14	 -Name	DirectoryWatcherServerIn |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH14	 -Name	DirectoryWatcherServerOut |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH23  -Name	UTLRematchDefaultWellsFargo |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH23  -Name	UTLRematchDefaultSantander |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch |  select machinename, name, status
Get-Service  -ComputerName  Unitrac-WH16  -Name	UTLMatch2 |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH18	 -Name	LetterGen |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH19	 -Name	MSGSRVREXTSANT |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH19	 -Name	LDHServiceSANT |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH20	 -Name	WorkflowService5 |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH20	 -Name	UnitracBusinessServiceCycleSANT |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH20	 -Name	UnitracBusinessServiceCycleSANT2 |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH21	 -Name	MSGSRVREXTWellsFargo |  select machinename, name, status
Get-Service	 -ComputerName	 Unitrac-WH21	 -Name	LDHWellsFargo |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr1.colo.as.local	 -Name	UnitracBusinessServiceDist |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr2.colo.as.local  -Name	UnitracBusinessServiceProc1 |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr3.colo.as.local -Name	UnitracBusinessServiceProc2 |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr4.colo.as.local	 -Name	UnitracBusinessServiceProc4 |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr5.colo.as.local	 -Name	UnitracBusinessServiceProc5 |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr6.colo.as.local -Name	UnitracBusinessServiceProc6 |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr7.colo.as.local -Name	UnitracBusinessServiceProc7 |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr8.colo.as.local -Name	UnitracBusinessServiceProc8 |  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr9.colo.as.local -Name	UnitracBusinessServiceProc9|  select machinename, name, status
Get-Service	 -ComputerName	utprod-asr10.colo.as.local -Name	UnitracBusinessServiceProc10 |  select machinename, name, status
Get-Service	 -ComputerName	UTPROD-UTLAPP-1.colo.as.local -Name	UTLBusinessService  |  select machinename, name, status 





Get-Service	 -ComputerName	Unitrac-EDI-01 -Name "*Trade*"


Get-Service	 -ComputerName	Unitrac-EDI-0A -Name "*Trade*"


Get-Service	 -ComputerName	ut-editest-01 -Name "*Trade*"

Get-Service	 -ComputerName	ut-editest-0A -Name "*Trade*"



