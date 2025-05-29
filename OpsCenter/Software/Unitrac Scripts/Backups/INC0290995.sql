USE unitrac

SELECT * FROM dbo.WORK_ITEM
WHERE ID = '38380738'
--43514232

--(Lender Code TX Number inside %%)
SELECT * FROM dbo.PROCESS_DEFINITION
WHERE NAME_TX LIKE '%3181%' AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N'

--436323

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID = '436323'

--date preference would start at the 1st of the previous month 
SELECT ID INTO #tmpPLL FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (436323) AND UPDATE_DT >= '2017-03-01 ' 
AND STATUS_CD = 'Complete'-- AND PROCESS_DEFINITION_ID = '436323'

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (SELECT * FROM #tmpPLL)
--AND PROCESS_LOG_ID = '43514232'
ORDER BY UPDATE_DT DESC 


SELECT RELATE_ID INTO #tmpRHH FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (SELECT * FROM #tmpPLL) AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'


SELECT R.NAME_TX, R. DISPLAY_NAME_TX,RECORD_COUNT_NO,	rh.REPORT_DATA_XML.value( '(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)' ) AS StartDate,
		rh.REPORT_DATA_XML.value( '(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)' ) AS EndDate,
		 rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
rh.*
FROM    REPORT_HISTORY rh
JOIN dbo.REPORT R ON R.ID = RH.REPORT_ID
WHERE  RH.ID IN (SELECT * FROM #tmpRHH)
AND rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) ='38380738'
ORDER BY rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) ASC 

SELECT REPORTED_DT, E.* FROM dbo.ESCROW E
JOIN dbo.LOAN L ON L.ID = E.LOAN_ID
JOIN dbo.REQUIRED_COVERAGE RC ON rc.PROPERTY_ID =e.PROPERTY_ID
WHERE LENDER_ID = '2337' --AND L.NUMBER_TX = '200095683'
AND RC.ESCROW_IN = 'Y' AND L.RECORD_TYPE_CD = 'G'
AND L.STATUS_CD = 'A' AND REPORTED_DT >= '2017- 03-28 '
ORDER BY E.UPDATE_DT DESC 

SELECT ESCROW_IN * FROM dbo.REQUIRED_COVERAGE

SELECT * FROM dbo.LENDER
WHERE id = 2337

SELECT  R.NAME_TX,rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
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
	RH.*
	FROM REPORT_HISTORY rh 
	LEFT JOIN REPORT R ON R.id = RH.REPORT_ID
WHERE   RH.ID  IN (SELECT * FROM #tmpRHH) AND rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) ='38380738'
	

	-------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE()
--	, REPORT_DATA_XML = ''
--		,REPORT_ID = '27'
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (SELECT * FROM #tmpRH)


