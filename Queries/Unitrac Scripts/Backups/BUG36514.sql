


SELECT wd.NAME_TX, wq.NAME_TX, wq.DESCRIPTION_TX, * FROM dbo.WORK_ITEM wi
INNER JOIN dbo.WORK_QUEUE wq ON wq.ID = wi.CURRENT_QUEUE_ID
INNER JOIN dbo.WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID
WHERE wi.ID = --28285318
28288952

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID = 28288952

		SELECT * FROM dbo.PROCESS_LOG_ITEM
		WHERE PROCESS_LOG_ID = '29092898'AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'
		
		AND RELATE_ID <> '8464617' 
		
	
	
		
SELECT * FROM dbo.REPORT_HISTORY
WHERE id IN (	SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM
		WHERE PROCESS_LOG_ID = 29086057 AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'
		) ORDER BY DOCUMENT_CONTAINER_ID ASC


		SELECT * FROM dbo.REPORT_HISTORY
		WHERE DOCUMENT_CONTAINER_ID = 49592937


		SELECT A.NAME_TX, * FROM dbo.LENDER L
		INNER JOIN dbo.AGENCY A ON A.ID = L.AGENCY_ID
		WHERE L.ID = '2142'


		UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		DOCUMENT_CONTAINER_ID = NULL
WHERE   ID IN (8464617
			) 



			SELECT * FROM dbo.REPORT_HISTORY
			WHERE ID IN (8463656,
8463657,
8463658,
8464616,
8464618,8464617)


SELECT * FROM dbo.LENDER
WHERE 
CODE_TX IN ('019000') OR
id IN (2142)



SELECT * FROM dbo.DOCUMENT_CONTAINER
WHERE ID IN (49846758)

--PAS\RPT\2016\01\21