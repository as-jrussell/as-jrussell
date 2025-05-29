USE UniTrac


----Error Status
SELECT L.NAME_TX [Lender Name],   R.NAME_TX [Report Name],rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)' ) as [PD.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as [ProcessLog.ID],
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE,
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
	JOIN dbo.LENDER L ON L.ID = RH.LENDER_ID
left	JOIN REPORT R ON R.id = RH.REPORT_ID
WHERE   RH.STATUS_CD = 'ERR' 
        AND CAST(RH.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE) 
		ORDER BY RH.MSG_LOG_TX DESC

-----On Hold
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
WHERE   RH.STATUS_CD = 'HOLD' 
		AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
ORDER BY rh.UPDATE_DT DESC

---Ignored
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
WHERE   RH.STATUS_CD = 'IGN' 
 AND CAST(RH.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE) 
ORDER BY rh.UPDATE_DT DESC


----Pending
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
	WHERE CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND rh.STATUS_CD = 'PEND'
ORDER BY RH.CREATE_DT ASC  

-----Complete
SELECT TOP  50  L.NAME_TX,   R.NAME_TX,rh.REPORT_DATA_XML.value( '(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)' ) as [WI.ID],
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
WHERE   RH.STATUS_CD = 'COMP' 
		AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
ORDER BY rh.UPDATE_DT DESC


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
WHERE   RH.ID IN (XXXXXXXX) AND
--RH.LENDER_ID IN () AND 
CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
ORDER BY rh.RECORD_COUNT_NO DESC





		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), DOCUMENT_CONTAINER_ID = NULL
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN 
(SELECT rh.id FROM dbo.REPORT_HISTORY rh
WHERE rh.LENDER_ID = 2292 AND rh.REPORT_ID = 32
AND rh.CREATE_DT >= '2016-07-29' AND rh.CREATE_DT <= '2016-08-07') 
AND UPDATE_USER_TX = 'UBSRPT'