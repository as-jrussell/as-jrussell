-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac

SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE  WI.ID IN ( 29865505   )






----If need to check for a report fro process log
SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (31532611)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'







-----To place reports from processed log to a TEMP table
select REPORT_ID as REPORT_ID, rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, 
rh.ID AS ID_Number, rh.CREATE_DT, rh.STATUS_CD, rh.LENDER_ID
into #t
from REPORT_HISTORY rh
where ID IN 
(SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (31532611)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'
)


SELECT REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ),* FROM dbo.REPORT_HISTORY
WHERE ID IN (SELECT ID_Number FROM #T) AND REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) = 'Notice Register - Borrowers'

EXEC dbo.Report_NoticeRegister @LenderCode = N'1580', -- nvarchar(10)
    @Division = N'99', -- nvarchar(10)
    Coverage = N'HAZARD', -- nvarchar(100)
    --@Branch = N'', -- nvarchar(max)
    @ReportType = N'NTCREG', -- nvarchar(50)
    --@GroupByCode = N'', -- nvarchar(50)
    --@SortByCode = N'', -- nvarchar(50)
    --@FilterByCode = N'', -- nvarchar(50)
    --@SpecificReport = '', -- varchar(50)
  --  @Report_History_ID = 0, -- bigint
    @ProcessLogID = 31532611 -- bigint


-----Find a report and where document lives
SELECT DC.RELATE_ID[ReportID], DM.SERVER_SHARE_TX,DC.RELATIVE_PATH_TX, DC.ORIGINAL_FILE_NAME_TX, 
DC.RELATE_CLASS_NAME_TX, DM.STORAGE_TYPE_CD, RH.*
FROM dbo.REPORT_HISTORY RH
INNER JOIN dbo.DOCUMENT_CONTAINER DC ON RH.DOCUMENT_CONTAINER_ID = DC.ID
INNER JOIN dbo.DOCUMENT_MANAGEMENT DM ON DM.ID = DC.DOCUMENT_MANAGEMENT_ID
WHERE DC.RELATE_ID IN (SELECT ID_Number FROM #T)


SELECT L.NAME_TX, RH.* FROM dbo.REPORT_HISTORY RH
INNER JOIN dbo.LENDER L ON L.ID = RH.LENDER_ID
WHERE RH.ID IN (8969589, 8969593, 8969601)





		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(),
		DOCUMENT_CONTAINER_ID = NULL
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (8969589, 8969593, 8969601)