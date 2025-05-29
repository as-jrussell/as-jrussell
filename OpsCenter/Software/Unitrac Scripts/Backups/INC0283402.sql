USE [UniTrac]
GO 


SELECT id INTO #TMP FROM dbo.REPORT_HISTORY
WHERE REPORT_ID = '35' AND LENDER_ID = '2254'
AND UPDATE_DT >= '2016-02-01 ' AND STATUS_CD <> 'comp'


SELECT  
REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
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
		rh.REPORT_DATA_XML.value( '(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)' ) AS SortByCode,
		rh.REPORT_DATA_XML.value( '(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)' ) AS StartDate,
		rh.REPORT_DATA_XML.value( '(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)' ) AS EndDate,
		*
FROM    dbo.REPORT_HISTORY RH
WHERE   ID IN (SELECT * FROM #TMP) AND UPDATE_DT >= '2017-02-06 '


SELECT * FROM dbo.REPORT
WHERE ID = '35'


SELECT * FROM dbo.CHANGE
WHERE ENTITY_NAME_TX = 'Allied.UniTrac.LenderReportConfig'
AND ENTITY_ID IN (88987,
89000,
89013,
89032)

SELECT LRC.* 
--INTO UniTracHDStorage..INC0283402_LRC
FROM dbo.LENDER_REPORT_CONFIG LRC
JOIN dbo.REPORT_CONFIG RC ON RC.ID = LRC.REPORT_CONFIG_ID
WHERE LENDER_ID = '2254' AND rc.id = '658' 

SELECT * FROM dbo.CHANGE
WHERE ENTITY_NAME_TX = 'Allied.UniTrac.LenderReportConfig'
AND ENTITY_ID IN (88987,
89000,
89013,
89032) AND CREATE_DT >= '2017-01-31 '