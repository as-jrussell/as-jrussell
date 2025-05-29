Invoke-Command -ComputerName 'Unitrac-APP01'  -ScriptBlock {sc.exe failure	UnitracBusinessService 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-APP01'  -ScriptBlock {sc.exe failure	FAXAssistService 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-APP02'  -ScriptBlock {sc.exe failure	ldhserviceUSD 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-APP02'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceCycle 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-APP02'  -ScriptBlock {sc.exe failure	UnitracBusinessServicePRT 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-APP02'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceFax 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH01'  -ScriptBlock {sc.exe failure	LDHServicePRCPA 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH03'  -ScriptBlock {sc.exe failure	LDHSERV 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH04'  -ScriptBlock {sc.exe failure	WorkflowService 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH04'  -ScriptBlock {sc.exe failure	LDHServiceADHOC 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH05'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceMatchOut 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH06'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceRPT 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH07'  -ScriptBlock {sc.exe failure	LDHServiceHUNT 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH07'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceBILL 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'Unitrac-WH07'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceFEE 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVRBSS 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVREDIIDR 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVRDEF 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVREXTUSD 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVREXTPENF 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVRADHOC 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVREXTINFO 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MSGSRVREXTHUNT 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH08'  -ScriptBlock {sc.exe failure	MclsSGSRVREXTGATE 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH10'  -ScriptBlock {sc.exe failure	WorkflowService2 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH11'  -ScriptBlock {sc.exe failure	WorkflowService3 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH12  '  -ScriptBlock {sc.exe failure	LIMCExportSoftfile	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH12  '  -ScriptBlock {sc.exe failure	LIMCOCR	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH12 '  -ScriptBlock {sc.exe failure	LIMCExport	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH12 '  -ScriptBlock {sc.exe failure	QCBatchEvaluationProcess 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH12 '  -ScriptBlock {sc.exe failure	QCBatchSendProcess 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH12 '  -ScriptBlock {sc.exe failure	QCCleanupProcess 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH12'  -ScriptBlock {sc.exe failure	QCImportProcess 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH13'  -ScriptBlock {sc.exe failure	WorkflowService4 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH13'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceBackfeed 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH14'  -ScriptBlock {sc.exe failure	DirectoryWatcherServerIn 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH14'  -ScriptBlock {sc.exe failure	DirectoryWatcherServerOut 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH16'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceCycle3 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH18'  -ScriptBlock {sc.exe failure	LetterGen 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH19'  -ScriptBlock {sc.exe failure	MSGSRVREXTSANT 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH19'  -ScriptBlock {sc.exe failure	LDHServiceSANT 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH20'  -ScriptBlock {sc.exe failure	WorkflowService5 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH20'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceCycleSANT 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH20'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceCycleSANT2 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH21'  -ScriptBlock {sc.exe failure	MSGSRVREXTWellsFargo 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName ' Unitrac-WH21'  -ScriptBlock {sc.exe failure	LDHWellsFargo 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'utprod-asr1.colo.as.local'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceDist 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'utprod-asr2.colo.as.local '  -ScriptBlock {sc.exe failure	UnitracBusinessServiceProc1 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'utprod-asr3.colo.as.local'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceProc2	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'utprod-asr4.colo.as.local'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceProc4 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'utprod-asr5.colo.as.local'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceProc5 	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'utprod-asr6.colo.as.local'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceProc6	reset= 86400 actions= restart/5000/restart/5000//}
Invoke-Command -ComputerName 'utprod-asr7.colo.as.local'  -ScriptBlock {sc.exe failure	UnitracBusinessServiceProc7	reset= 86400 actions= restart/5000/restart/5000//}
