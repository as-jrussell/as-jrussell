USE UniTrac;

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




SELECT * FROM #tmpRHID