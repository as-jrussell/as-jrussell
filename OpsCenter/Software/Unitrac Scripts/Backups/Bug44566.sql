USE UniTrac


SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (43399085)


SELECT RELATE_ID INTO #tmpRH FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 56516454 AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'


SELECT * 
FROM dbo.REPORT_HISTORY
WHERE ID IN (SELECT * FROM #tmpRH)


		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE()
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN --(14256437)

(SELECT * FROM #tmpRH) AND DOCUMENT_CONTAINER_ID IS NULL
AND STATUS_CD = 'ERR'


UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'COMP' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), OUTPUT_TYPE_CD= 'E'
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN --(14256437)

(SELECT * FROM #tmpRH) AND DOCUMENT_CONTAINER_ID IS NOT NULL


SELECT * FROM dbo.REPORT
WHERE ID IN (32)



SELECT TOP 5 * FROM dbo.REPORT_HISTORY
WHERE CAST(UPDATE_DT AS DATE) = CAST(GETDATE()AS DATE)
AND OUTPUT_TYPE_CD = 'P'
ORDER BY UPDATE_DT DESC 


SELECT *
FROM REPORT_HISTORY
WHERE  UPDATE_DT >= '2018-03-01' AND LENDER_ID in (957,309)




-----Wildcard search by ID number or by Lender fielder's choice just uncomment to suit needs
SELECT L.NAME_TX,   R.NAME_TX,rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
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
	JOIN REPORT R ON R.id = RH.REPORT_ID
	JOIN dbo.LENDER L ON L.ID = RH.LENDER_ID
WHERE   RH.ID IN 
(SELECT * FROM #tmpRH) AND DOCUMENT_CONTAINER_ID IS NOT NULL AND 
--RH.LENDER_ID IN () AND 
CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
ORDER BY rh.RECORD_COUNT_NO DESC
