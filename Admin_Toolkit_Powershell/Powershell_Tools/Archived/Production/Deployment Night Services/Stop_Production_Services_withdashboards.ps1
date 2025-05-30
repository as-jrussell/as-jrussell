﻿#Windows 2008

Get-Service	 -ComputerName	UNITRAC-APP01	 -Name	LIMCEmail	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCOCR	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCExportSoftfile	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCExport	| Stop-Service -Force -NoWait
#Windows 2012
Get-Service	 -ComputerName	UTPROD-ASR1	 -Name	UnitracBusinessServiceDist	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR2	 -Name	UnitracBusinessServiceProc1	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR3	 -Name	UnitracBusinessServiceProc2	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR4	 -Name	UnitracBusinessServiceProc4	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR5	 -Name	UnitracBusinessServiceProc5	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR6	 -Name	UnitracBusinessServiceProc6	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR7	 -Name	UnitracBusinessServiceProc7	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR8	 -Name	UnitracBusinessServiceProc8	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-ASR9	 -Name	UnitracBusinessServiceProc9	| Stop-Service -Force -NoWait
#Windows 2016
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService5	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService4	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService3	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService2	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHserviceUSD	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHServiceADHOC	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHService	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHHomeStreet	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH003	 -Name	MSGSRVREXTHUNT	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH003	 -Name	LDHServiceHUNT	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH004	 -Name	LDHServicePRCPA	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH005	 -Name	MSGSRVREXTWELLSFARGO	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH005	 -Name	LDHWellsFargo	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH006	 -Name	MSGSRVREXTSANT	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH006	 -Name	LDHServiceSANT	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH007	 -Name	DirectoryWatcherServerOut	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH007	 -Name	DirectoryWatcherServerIn	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTINFO	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTGATE	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREDIIDR	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRDEF	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRBSS	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRADHOC	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTUSD	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTPENF	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	LetterGen	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServiceFax	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServicePRT	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServiceCycle	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessService	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceRPT	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceMatchOut	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceFEE	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceBackfeed	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH011	 -Name	UBSCycleSANT2	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH011	 -Name	UBSCycleSANT	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCBatchEvaluationProcess	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCBatchSendProcess	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCCleanupProcess	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCImportProcess	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	ListenService	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	FaxAssistService	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH013	 -Name	UTLMatch2	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH013	 -Name	UTLMatch	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchRepoPlus	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchMidSizeLenders	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchDefault	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchAdhoc	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH015	 -Name	UTLRematchDefaultWellsFargo	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UNITRAC-WH016	 -Name	UTLRematchDefaultSantander	| Stop-Service -Force -NoWait
Get-Service	 -ComputerName	UTPROD-UTLAPP-1	 -Name	UTLBusinessService	| Stop-Service -Force -NoWait


Set-Service  -ComputerName	 UNITRAC-WH017	 -Name	DashboardService  -StartupType Disabled
Set-Service  -ComputerName	 UNITRAC-WH017	 -Name	OAILenderDashboard  -StartupType Disabled
Set-Service  -ComputerName	 UNITRAC-WH017	 -Name	OAIOperationalDashboard  -StartupType Disabled



Write-Host "Services are stopped and Dashboard Services"

