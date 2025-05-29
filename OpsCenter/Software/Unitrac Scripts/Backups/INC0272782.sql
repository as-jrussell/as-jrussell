USE UniTrac

SELECT r.NAME_TX, rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, rh.* FROM dbo.REPORT_HISTORY rh
JOIN dbo.LENDER l ON l.id = rh.LENDER_ID
JOIN dbo.REPORT	r ON r.id = rh.REPORT_ID
WHERE l.CODE_TX = '4383' AND rh.UPDATE_DT >= '2016-11-12 '
AND REPORT_ID <> '27' AND rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' )  LIKE '%Payment Increase%'

SELECT *
INTO UniTracHDStorage..INC0272782
 FROM dbo.REPORT_HISTORY
WHERE   ID IN (10779686,
10780538,
10783497,
10787202)


		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), UPDATE_USER_TX =	'INC0272782',
		DOCUMENT_CONTAINER_ID = NULL
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (10779686,
10780538,
10783497,
10787202)
