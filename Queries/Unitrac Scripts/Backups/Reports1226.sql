-----Error Status
SELECT rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, 
rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as ProcessLogID,
rh.REPORT_DATA_XML.value( '(/ReportData/Report/RelateId/@value)[1]', 'varchar(500)' ) as Relate_ID, * 
FROM    REPORT_HISTORY rh
WHERE   STATUS_CD = 'ERR'
        AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE()-2 AS DATE)
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL
		--AND rh.REPORT_DATA_XML.value( '(/ReportData/Report/RelateId/@value)[1]', 'varchar(500)' ) <> '0'
		ORDER BY rh.REPORT_DATA_XML.value( '(/ReportData/Report/RelateId/@value)[1]', 'varchar(500)' ) DESC

	
		




-----Complete
SELECT *
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'COMP'
		AND REPORT_ID IN (89)
        AND CAST(UPDATE_DT AS DATE) > CAST(GETDATE()-3 AS DATE)
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL

		SELECT * FROM dbo.REPORT
		WHERE ID IN (40)
-----Pending
SELECT *
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'PEND'
        AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
    AND GENERATION_SOURCE_CD = 'u' 
		--AND REPORT_ID = '27'
	    --AND MSG_LOG_TX IS NOT NULL
	ORDER BY UPDATE_DT DESC


		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'ERR' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = 'Error in GenerateReport: Error Rendering XLS Report: An error has occurred during report processing. ---> Microsoft.ReportingServices.ReportProcessing.ProcessingAbortedException: An error has occurred during report processing. ---> Microsoft.ReportingServices.ReportProcessing.ReportProcessingException: Query execution failed for dataset DataSet1. ---> System.Data.SqlClient.SqlException: String or binary data would be truncated.
The statement has been terminated.',
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0
WHERE   ID IN ( 8576418,
8576416,
8576336,
8576434,
8576388,
8576415,
8576413,
8576414,
8576412,
8576411,
8576409,
8576391,
8576408,
8576410,
8576407,
8576404,
8576405,
8576406,
8576403,
8576386,
8576402,
8576401,
8576393,
8576387,
8576383,
8576384,
8576385,
8576399,
8576400,
8576382,
8576433,
8576380,
8576381,
8576431,
8576432,
8576378,
8576379,
8576338,
8576335,
8576377,
8576375,
8576376,
8576374,
8576372,
8576373,
8576334,
8576332,
8576333,
8576370,
8576371,
8576311,
8576331,
8576329,
8576330,
8576369,
8576368,
8576366,
8576367,
8576328,
8576365,
8576364,
8576363,
8576313,
8576362,
8576360,
8576361,
8576359,
8576358,
8576326,
8576327,
8576357,
8576356,
8576353,
8576354,
8576312,
8576355,
8576352,
8576350,
8576351,
8576348,
8576349,
8576347,
8576344,
8576345,
8576324,
8576346,
8576343,
8576325,
8576341,
8576342,
8576397,
8576398,
8576396,
8576395,
8576323,
8576430,
8576320,
8576394,
8576322,
8576321,
8576318,
8576319,
8576340,
8576314,
8576317,
8576315,
8576316,
8576438,
8576439,
8576390,
8576437,
8576337,
8576389,
8576435,
8576339,
8576429,
8576427,
8576426,
8576428,
8576425,
8576424,
8576422,
8576423,
8576436,
8576421,
8576419,
8576420,
8576417,
8576392) 

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE RELATE_TYPE_CD = 'Allied.UniTrac.ServiceFeeInvoice'

AND PROCESS_LOG_ID IN 		
(29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29597596,
29593529,
29593688,
29593691,
29593719,
29593721,
29593747,
29593402)


--UPDATE dbo.REPORT_HISTORY
--SET STATUS_CD = 'PEND'
--WHERE ID IN (
--) and REPORT_ID = 



------Show all Reports

----SELECT * FROM dbo.REPORT


------Show list categories of Reports

----SELECT DISTINCT CATEGORY_CD FROM dbo.REPORT

------Show list Sub categories of Reports

----SELECT DISTINCT SUB_CATEGORY_CD FROM dbo.REPORT

----SELECT * FROM dbo.REPORT
----WHERE CATEGORY_CD = 'Internal' AND SUB_CATEGORY_CD= 'Security'

--SELECT * FROM dbo.DOCUMENT
--WHERE ID IN (XXXXXXX)

--SELECT * FROM dbo.DOCUMENT_CONTAINER
--WHERE ID IN (XXXXXXX)


--SELECT * FROM dbo.DOCUMENT_MANAGEMENT
--ORDER BY SERVER_SHARE_TX ASC


--		SELECT DISTINCT STATUS_CD FROM dbo.REPORT_HISTORY



--		SELECT * FROM dbo.REPORT R
--		INNER JOIN dbo.REPORT_CONFIG RC ON  R.ID = RC.REPORT_ID
--		INNER JOIN dbo.REPORT_CONFIG_ATTRIBUTE RA ON RC.ID = RA.ID


--		SELECT * FROM dbo.REPORT_CONFIG
--		SELECT * FROM dbo.REPORT
--		SELECT * FROM dbo.REPORT_CONFIG_ATTRIBUTE





-----Find a report and where document lives
--SELECT * FROM dbo.REPORT_HISTORY R
--INNER JOIN dbo.DOCUMENT_CONTAINER DC ON R.DOCUMENT_CONTAINER_ID = DC.ID
--INNER JOIN dbo.DOCUMENT_MANAGEMENT DM ON DM.ID = DC.DOCUMENT_MANAGEMENT_ID
--WHERE R.ID IN (XXXXXXX)

--SELECT * FROM dbo.REPORT_HISTORY
--WHERE ID IN (XXXXXXX) 




