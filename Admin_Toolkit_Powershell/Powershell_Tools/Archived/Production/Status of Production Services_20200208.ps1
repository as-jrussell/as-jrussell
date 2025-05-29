 # record the deployment session
$deployLogDestination = "E:\logs\Services\ProductionServiceStatus"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $deployLogDestination

#Windows 2008

Get-Service	 -ComputerName	UNITRAC-APP01	 -Name	LIMCEmail	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCOCR	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCExportSoftfile	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH12	 -Name	LIMCExport	|  select machinename, name, status| fl
#Windows 2012
Get-Service	 -ComputerName	UTPROD-ASR1	 -Name	UnitracBusinessServiceDist	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR2	 -Name	UnitracBusinessServiceProc1	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR3	 -Name	UnitracBusinessServiceProc2	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR4	 -Name	UnitracBusinessServiceProc4	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR5	 -Name	UnitracBusinessServiceProc5	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR6	 -Name	UnitracBusinessServiceProc6	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR7	 -Name	UnitracBusinessServiceProc7	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR8	 -Name	UnitracBusinessServiceProc8	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-ASR9	 -Name	UnitracBusinessServiceProc9	|  select machinename, name, status| fl
#Windows 2016
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService5	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService4	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService3	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH001	 -Name	OspreyWorkflowService2	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHserviceUSD	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHServiceADHOC	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHService	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH002	 -Name	LDHHomeStreet	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH003	 -Name	MSGSRVREXTHUNT	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH003	 -Name	LDHServiceHUNT	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH004	 -Name	LDHServicePRCPA	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH005	 -Name	MSGSRVREXTWELLSFARGO	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH005	 -Name	LDHWellsFargo	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH006	 -Name	MSGSRVREXTSANT	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH006	 -Name	LDHServiceSANT	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH007	 -Name	DirectoryWatcherServerOut	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH007	 -Name	DirectoryWatcherServerIn	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTINFO	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTGATE	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREDIIDR	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRDEF	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRBSS	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVRADHOC	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTUSD	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH008	 -Name	MSGSRVREXTPENF	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	LetterGen	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServiceFax	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServicePRT	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessServiceCycle	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH009	 -Name	UnitracBusinessService	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceRPT	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceMatchOut	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceFEE	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH010	 -Name	UnitracBusinessServiceBackfeed	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH011	 -Name	UBSCycleSANT2	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH011	 -Name	UBSCycleSANT	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCBatchEvaluationProcess	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCBatchSendProcess	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCCleanupProcess	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	QCImportProcess	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	ListenService	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH012	 -Name	FaxAssistService	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH013	 -Name	UTLMatch2	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH013	 -Name	UTLMatch	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchRepoPlus	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchMidSizeLenders	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchDefault	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH014	 -Name	UTLRematchAdhoc	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH015	 -Name	UTLRematchDefaultWellsFargo	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UNITRAC-WH016	 -Name	UTLRematchDefaultSantander	|  select machinename, name, status| fl
Get-Service	 -ComputerName	UTPROD-UTLAPP-1	 -Name	UTLBusinessService	|  select machinename, name, status| fl






Stop-Transcript

Invoke-item $deployLogDestination