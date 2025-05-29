-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID


SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( 28578711    )











----If need to check for a report fro process log
SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (29515711)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'







-----To place reports from processed log to a TEMP table
select REPORT_ID as REPORT_ID, rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, 
rh.ID AS ID_Number, rh.CREATE_DT, rh.STATUS_CD, rh.LENDER_ID
into #t
from REPORT_HISTORY rh
where ID IN 
(SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (XXXXXXX)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'
)



SELECT * FROM #T