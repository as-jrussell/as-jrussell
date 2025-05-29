USE UniTrac

-----Error Status
SELECT rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)' ) as [PD.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as [ProcessLog.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, R.NAME_TX,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)' ) AS ReportType,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)' ) AS Branch,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Division/@value)[1]', 'varchar(500)' ) AS Division,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)' ) AS Coverage,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)' ) AS GroupByTx,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)' ) AS ReportConfig,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/FilterByTx/@value)[1]', 'varchar(500)' ) AS FilterByCode,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)' ) AS SortByCode,
	RH.*
	FROM REPORT_HISTORY rh 
	LEFT JOIN REPORT R ON R.id = RH.REPORT_ID
WHERE   RH.STATUS_CD = 'ERR' 
        AND CAST(RH.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE) 
		ORDER BY RH.MSG_LOG_TX DESC


----Pending
SELECT rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)' ) as [PD.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as [ProcessLog.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, R.NAME_TX,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)' ) AS ReportType,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)' ) AS Branch,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Division/@value)[1]', 'varchar(500)' ) AS Division,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)' ) AS Coverage,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)' ) AS GroupByTx,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)' ) AS ReportConfig,
	RH.*
	FROM REPORT_HISTORY rh 
	JOIN REPORT R ON R.id = RH.REPORT_ID
	WHERE CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND rh.STATUS_CD = 'PEND'
	ORDER BY CREATE_DT ASC  
 
 

-----Complete
SELECT rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)' ) as [PD.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as [ProcessLog.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, R.NAME_TX,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)' ) AS ReportType,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)' ) AS Branch,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Division/@value)[1]', 'varchar(500)' ) AS Division,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)' ) AS Coverage,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)' ) AS GroupByTx,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)' ) AS ReportConfig,
rh.*
FROM    REPORT_HISTORY rh
	JOIN REPORT R ON R.id = RH.REPORT_ID
WHERE   STATUS_CD = 'COMP' 
		AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
ORDER BY rh.UPDATE_DT DESC



---ProcessDefinition
SELECT  STATUS_CD ,* FROM dbo.PROCESS_DEFINITION
WHERE ID = '30'

--Process Log
SELECT TOP 10 * FROM dbo.PROCESS_LOG
ORDER BY UPDATE_DT DESC 

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD ='RPTGEN'


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N' AND STATUS_CD <> 'Complete' AND STATUS_CD!= 'Expired'

		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
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
WHERE   ID IN ()
