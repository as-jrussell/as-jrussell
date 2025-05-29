USE UniTrac;

--Stats on reports for the day
SELECT MIN(rh.create_dt) [Oldest report],COUNT(*) [Counts], rh.STATUS_CD [Status]
	--select *
FROM REPORT_HISTORY  rh
LEFT JOIN dbo.DOCUMENT_CONTAINER dc ON dc.id = rh.DOCUMENT_CONTAINER_ID
WHERE CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)  AND rh.GENERATION_SOURCE_CD = 'u'
GROUP BY	STATUS_CD

--DROP TABLE #tmpRHID
--SELECT * FROM #tmpRHID
----Place reports that are in error into a temp table
IF Object_id(N'tempdb..#tmpRHID') IS NOT NULL
  DROP TABLE #tmpRHID

SELECT L.NAME_TX [Lender Name],
       R.NAME_TX [Report Name],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)') AS [WI.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)') AS [PD.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)') AS [ProcessLog.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Title/@value)[1]', 'varchar(500)') AS TITLE,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)') AS Branch,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Division/@value)[1]', 'varchar(500)') AS Division,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)') AS Coverage,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)') AS GroupByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/FilterByTx/@value)[1]', 'varchar(500)') AS FilterByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)') AS ReportConfig,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)') AS SortByCode,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)') AS StartDate,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)') AS EndDate,
       rh.*
INTO #tmpRHID
FROM REPORT_HISTORY rh
    JOIN dbo.LENDER L
        ON L.ID = rh.LENDER_ID
    LEFT JOIN REPORT R
        ON R.ID = rh.REPORT_ID
WHERE rh.STATUS_CD = 'ERR'
      AND CAST(rh.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
ORDER BY rh.MSG_LOG_TX DESC;


select * from #tmpRHID
order by UPDATE_DT desc 

SELECT COUNT(ID), CAST(UPDATE_DT AS date) 
FROM REPORT_HISTORY
WHERE STATUS_CD = 'ERR'
AND MSG_LOG_TX='Error in GenerateReport: The request failed with HTTP status 503: Server Error.'
GROUP BY  CAST(UPDATE_DT AS date) 

--Breakdown of errors by report name
SELECT COUNT(*) [Counts],
       R.NAME_TX [Report Name],
       R.ID [Report ID]
FROM #tmpRHID T
    JOIN dbo.REPORT R
        ON T.REPORT_ID = R.ID
GROUP BY R.NAME_TX,
         R.ID

--If any reports are missing report Id
SELECT *
FROM #tmpRHID T
WHERE T.REPORT_ID IS NULL 



--Implementation if you need to restore the reports to a PEND status

SELECT * 

FROM dbo.REPORT_HISTORY
WHERE 
    ID IN (SELECT id FROM #tmpRHID )

UPDATE RH
SET STATUS_CD = 'PEND',
    RETRY_COUNT_NO = 0,
    MSG_LOG_TX = NULL,
    RECORD_COUNT_NO = 0,
    ELAPSED_RUNTIME_NO = 0,
    UPDATE_DT = GETDATE(),
    DOCUMENT_CONTAINER_ID = NULL, RH.UPDATE_USER_TX = 'CHG011793'
--SELECT * 
FROM  [UniTrac].[dbo].[REPORT_HISTORY] RH
WHERE 
    ID IN (SELECT id FROM #tmpRHID )


--BackOut 
UPDATE RH 
SET STATUS_CD = HR,STATUS_CD,
    RETRY_COUNT_NO = HR.RETRY_COUNT_NO,
    MSG_LOG_TX = HR.MSG_LOG_TX,
    RECORD_COUNT_NO = HR.RECORD_COUNT_NO,
    ELAPSED_RUNTIME_NO = HR.ELAPSED_RUNTIME_NO,
    UPDATE_DT = GETDATE(),
    DOCUMENT_CONTAINER_ID = HR.DOCUMENT_CONTAINER_ID
--SELECT * 
	FROM  [UniTrac].[dbo].[REPORT_HISTORY] RH
	JOIN UniTracHDStorage..CHG011793 HR ON HR.ID = RH.ID

----Pending
SELECT rh.ID,
       L.NAME_TX,
       R.NAME_TX,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)') AS [WI.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)') AS [PD.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)') AS [ProcessLog.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Title/@value)[1]', 'varchar(500)') AS TITLE,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)') AS Branch,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Division/@value)[1]', 'varchar(500)') AS Division,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)') AS Coverage,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)') AS GroupByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/FilterByTx/@value)[1]', 'varchar(500)') AS FilterByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)') AS ReportConfig,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)') AS SortByCode,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)') AS StartDate,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)') AS EndDate,
       rh.*
FROM REPORT_HISTORY rh
    JOIN REPORT R
        ON R.ID = rh.REPORT_ID
    JOIN dbo.LENDER L
        ON L.ID = rh.LENDER_ID
WHERE  rh.STATUS_CD = 'PEND' --AND rh.UPDATE_USER_TX = 'UBSRPT' -- and r.id=27
ORDER BY rh.UPDATE_DT ASC;

-----Complete
SELECT 
       rh.*
FROM REPORT_HISTORY rh
WHERE rh.STATUS_CD = 'COMP'
      AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY rh.id DESC;


-----On Hold
SELECT L.NAME_TX,
       R.NAME_TX,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)') AS [WI.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)') AS [PD.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)') AS [ProcessLog.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Title/@value)[1]', 'varchar(500)') AS TITLE,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)') AS Branch,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Division/@value)[1]', 'varchar(500)') AS Division,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)') AS Coverage,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)') AS GroupByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/FilterByTx/@value)[1]', 'varchar(500)') AS FilterByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)') AS ReportConfig,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)') AS SortByCode,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)') AS StartDate,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)') AS EndDate,
       rh.*
FROM REPORT_HISTORY rh
    JOIN REPORT R
        ON R.ID = rh.REPORT_ID
    JOIN dbo.LENDER L
        ON L.ID = rh.LENDER_ID
WHERE rh.STATUS_CD = 'HOLD'
      AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY rh.UPDATE_DT DESC;

---Ignored
SELECT L.NAME_TX,
       R.NAME_TX,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)') AS [WI.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)') AS [PD.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)') AS [ProcessLog.ID],
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Title/@value)[1]', 'varchar(500)') AS TITLE,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)') AS Branch,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Division/@value)[1]', 'varchar(500)') AS Division,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)') AS Coverage,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)') AS GroupByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/FilterByTx/@value)[1]', 'varchar(500)') AS FilterByTx,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)') AS ReportConfig,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)') AS SortByCode,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)') AS StartDate,
       rh.REPORT_DATA_XML.value('(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)') AS EndDate,
       rh.*
FROM REPORT_HISTORY rh
    JOIN REPORT R
        ON R.ID = rh.REPORT_ID
    JOIN dbo.LENDER L
        ON L.ID = rh.LENDER_ID
WHERE rh.STATUS_CD = 'IGN'
      AND CAST(rh.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
ORDER BY rh.UPDATE_DT DESC;


-----Wildcard search by ID number or by Lender fielder's choice just uncomment to suit needs
SELECT --L.NAME_TX,  
    --R.NAME_TX,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/WorkItemId/@value)[1]', 'varchar(500)') AS [WI.ID],
    rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'varchar(500)') AS [PD.ID],
    rh.REPORT_DATA_XML.value('(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)') AS [ProcessLog.ID],
    rh.REPORT_DATA_XML.value('(/ReportData/Report/Title/@value)[1]', 'varchar(500)') AS TITLE,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/Branches/Branch)[1]', 'varchar(500)') AS Branch,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/Division/@value)[1]', 'varchar(500)') AS Division,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/Coverage/@value)[1]', 'varchar(500)') AS Coverage,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/GroupByTx/@value)[1]', 'varchar(500)') AS GroupByTx,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/FilterByTx/@value)[1]', 'varchar(500)') AS FilterByTx,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportConfig/@value)[1]', 'varchar(500)') AS ReportConfig,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'varchar(500)') AS ReportType,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/SortByTx/@value)[1]', 'varchar(500)') AS SortByCode,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/StartDate/@value)[1]', 'varchar(500)') AS StartDate,
    rh.REPORT_DATA_XML.value('(/ReportData/Report/EndDate/@value)[1]', 'varchar(500)') AS EndDate,
    rh.*
FROM REPORT_HISTORY rh
WHERE rh.ID IN (XXXXXXX )
ORDER BY rh.RECORD_COUNT_NO DESC;


--Validation 
SELECT * 
FROM dbo.REPORT_HISTORY
WHERE 
    ID IN (XXXXXXX )







	SELECT COUNT(ID), CAST(UPDATE_DT AS date), MAX(ID) 
FROM REPORT_HISTORY
WHERE STATUS_CD = 'ERR'
AND MSG_LOG_TX='Error in GenerateReport: The request failed with HTTP status 503: Server Error.'
--AND CAST(UPDATE_DT AS date) < '2024-05-14'
GROUP BY  CAST(UPDATE_DT AS date) 





SELECT top 1 * 
FROM PROCESS_LOG_ITEM
where RELATE_ID = '40620719'
