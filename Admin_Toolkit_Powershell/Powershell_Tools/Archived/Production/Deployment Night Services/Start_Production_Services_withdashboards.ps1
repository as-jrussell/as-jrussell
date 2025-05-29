#Windows 2008

Get-Service	 -ComputerName	UNITRAC-APP01	 -Name	LIMCEmail	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCOCR	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCExportSoftfile	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCExport	| Start-Service
#Windows 2012
Get-Service	 -ComputerName	UTPROD-ASR1	 -Name	UnitracBusinessServiceDist	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR2	 -Name	UnitracBusinessServiceProc1	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR3	 -Name	UnitracBusinessServiceProc2	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR4	 -Name	UnitracBusinessServiceProc4	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR5	 -Name	UnitracBusinessServiceProc5	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR6	 -Name	UnitracBusinessServiceProc6	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR7	 -Name	UnitracBusinessServiceProc7	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR8	 -Name	UnitracBusinessServiceProc8	| Start-Service
Get-Service	 -ComputerName	UTPROD-ASR9	 -Name	UnitracBusinessServiceProc9	| Start-Service
#Windows 2016
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService5	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService4	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService3	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService2	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHserviceUSD	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHServiceADHOC	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHService	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHHomeStreet	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH003	 -Name	MSGSRVREXTHUNT	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH003	 -Name	LDHServiceHUNT	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH004	 -Name	LDHServicePRCPA	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH005	 -Name	MSGSRVREXTWELLSFARGO	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH005	 -Name	LDHWellsFargo	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH006	 -Name	MSGSRVREXTSANT	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH006	 -Name	LDHServiceSANT	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH007	 -Name	DirectoryWatcherServerOut	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH007	 -Name	DirectoryWatcherServerIn	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTINFO	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTGATE	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREDIIDR	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRDEF	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRBSS	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRADHOC	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTUSD	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTPENF	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	LetterGen	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServiceFax	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServicePRT	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServiceCycle	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessService	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceRPT	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceMatchOut	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceFEE	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceBackfeed	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH011	 -Name	UBSCycleSANT2	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH011	 -Name	UBSCycleSANT	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCBatchEvaluationProcess	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCBatchSendProcess	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCCleanupProcess	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCImportProcess	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	ListenService	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	FaxAssistService	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH013	 -Name	UTLMatch2	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH013	 -Name	UTLMatch	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchRepoPlus	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchMidSizeLenders	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchDefault	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchAdhoc	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH015	 -Name	UTLRematchDefaultWellsFargo	| Start-Service
Get-Service	 -ComputerName	UNITRAC-WH016	 -Name	UTLRematchDefaultSantander	| Start-Service
Get-Service	 -ComputerName	UTPROD-UTLAPP-1	 -Name	UTLBusinessService	| Start-Service





Set-Service  -ComputerName	 UNITRAC-WH017	 -Name	DashboardService  -StartupType Automatic
Set-Service  -ComputerName	 UNITRAC-WH017	 -Name	OAILenderDashboard  -StartupType Automatic
Set-Service  -ComputerName	 UNITRAC-WH017	 -Name	OAIOperationalDashboard  -StartupType Automatic


Write-Host "Services are started back up and the Dashboards are re-enabled to start up tonight" 