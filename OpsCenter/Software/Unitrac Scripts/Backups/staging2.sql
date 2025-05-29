-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac


SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '534538'
----If need to check for a report fro process log
SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (33359347,
33359815)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'







-----To place reports from processed log to a TEMP table
select rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, 
* FROM REPORT_HISTORY rh
WHERE CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND --STATUS_CD = 'COMP'
ID IN (9405735,
9405736,
9405737,
9405738,
9405739,
9405741,
9405740,
9405742,
9405743,
9405744)
ORDER BY rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) ASC




