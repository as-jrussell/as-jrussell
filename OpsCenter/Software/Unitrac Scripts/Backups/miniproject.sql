USE UniTrac

SELECT * FROM dbo.LENDER
WHERE CODE_TX IN ('5350', '5310', '3400', '5044', '2771', '1771')


SELECT L.NAME_TX, 	rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)' ) as [PD.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as [ProcessLog.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)' ) AS ReportType,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)' ) AS Branch,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Division/@value)[1]', 'varchar(500)' ) AS Division,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)' ) AS Coverage,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)' ) AS GroupByTx,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/FilterByTx/@value)[1]', 'varchar(500)' ) AS FilterByTx,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)' ) AS ReportConfig,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)' ) AS ReportType,
		rh.REPORT_DATA_XML.value( '(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)' ) AS SortByCode,
		rh.REPORT_DATA_XML.value( '(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)' ) AS StartDate,
		rh.REPORT_DATA_XML.value( '(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)' ) AS EndDate,
 RH.* FROM dbo.REPORT_HISTORY rh
JOIN dbo.LENDER L ON L.ID = RH.LENDER_ID
WHERE CODE_TX IN ('5350', '5310', '3400', '5044', '2771', '1771')
AND Rh.REPORT_ID = '27' AND rh.STATUS_CD <> 'COMP'
AND RH.UPDATE_DT >= '2016-04-16'


SELECT NAME_TX[Lender], rh.STATUS_CD [Status], COUNT(rh.STATUS_CD) [Count]
FROM dbo.REPORT_HISTORY rh
JOIN dbo.LENDER L ON L.ID = RH.LENDER_ID
WHERE CODE_TX IN ('5350', '5310', '3400', '5044', '2771', '1771')
AND Rh.REPORT_ID = '27' AND RH.UPDATE_DT >= '2017-04-01'
GROUP BY NAME_TX, rh.STATUS_CD
ORDER BY L.NAME_TX ASC 


