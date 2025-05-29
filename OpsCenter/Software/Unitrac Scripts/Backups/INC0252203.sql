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
SELECT DISTINCT rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE
--rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
--	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)' ) as [PD.ID],
--	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as [ProcessLog.ID],
--	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, R.NAME_TX,
--	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)' ) AS ReportType,
--	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)' ) AS Branch,
	--rh.REPORT_DATA_XML.value( '(/ReportData/Report/Division/@value)[1]', 'varchar(500)' ) AS Division,
	--rh.REPORT_DATA_XML.value( '(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)' ) AS Coverage,
	--rh.REPORT_DATA_XML.value( '(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)' ) AS GroupByTx,
	--rh.REPORT_DATA_XML.value( '(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)' ) AS ReportConfig,
	--RH.*
	FROM REPORT_HISTORY rh 
	JOIN REPORT R ON R.id = RH.REPORT_ID
	WHERE rh.id in(6277321,6277322,6277325,6278044,6278045,6278049,6278051,6278058,6278061,6278063,6278068,6283957,6283958,6381868,6381869,6381871,6381872,6381873,6381874,6381887,6381888,6381889,6381890,6364385,6364386,6364390,6367446,6367448,6367449,6367451,6367464,6367465,6367466,6367469,6368853,6369702,6370165,6370166)

	WHERE RH.CREATE_DT >= '2015-01-23 ' AND RH.CREATE_DT <= '2015-01-24 ' AND 
	  RH.LENDER_ID = '867' AND REPORT_ID IN (32,37)
	ORDER BY CREATE_DT ASC  

	SELECT * FROM dbo.LENDER
	WHERE CODE_TX = '6485'

	SELECT * FROM dbo.REPORT WHERE NAME_TX LIKE '%Register%'
 



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
*
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
WHERE PROCESS_DEFINITION_ID = '30'
ORDER BY UPDATE_DT DESC 


		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0, DOCUMENT_CONTAINER_ID = NULL,
		UPDATE_DT = GETDATE()
--	, REPORT_DATA_XML = ''
--		,REPORT_ID = '27'
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (6277321,6277322,6277325,6278044,6278045,6278049,6278051,6278058,6278061,6278063,6278068,6283957,6283958,6381868,6381869,6381871,6381872,6381873,6381874,6381887,6381888,6381889,6381890,6364385,6364386,6364390,6367446,6367448,6367449,6367451,6367464,6367465,6367466,6367469,6368853,6369702,6370165,6370166)