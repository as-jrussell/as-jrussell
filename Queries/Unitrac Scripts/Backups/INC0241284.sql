USE UniTrac



SELECT * FROM dbo.LENDER_REPORT_CONFIG LRC
INNER JOIN dbo.LENDER L ON L.ID = LRC.LENDER_ID
WHERE L.CODE_TX = '3141' 
ORDER BY DESCRIPTION_TX ASC  


SELECT * FROM dbo.REPORT
ORDER BY DESCRIPTION_TX ASC  


	SELECT TOP 500
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE,
	*
	FROM REPORT_HISTORY rh 
	WHERE REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) LIKE '%Contract Status%'
	AND REPORT_ID IS NOT NULL
	ORDER BY CREATE_DT DESC   


	
SELECT LRC.* INTO UniTracHDStorage..INC0241284
FROM dbo.LENDER_REPORT_CONFIG LRC
INNER JOIN dbo.LENDER L ON L.ID = LRC.LENDER_ID
WHERE L.CODE_TX = '3141' 
ORDER BY DESCRIPTION_TX ASC  




 
SELECT LRC.* FROM dbo.LENDER_REPORT_CONFIG LRC
INNER JOIN dbo.LENDER L ON L.ID = LRC.LENDER_ID
WHERE L.CODE_TX = '3141' AND LRC.TITLE_TX LIKE '%Contract%'
-- AND LRC.WEB_ENABLED_CD <> 'WE'
ORDER BY DESCRIPTION_TX ASC  



SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'WebPublishStatus'



SELECT LRC.DESCRIPTION_TX, LRC.TITLE_TX, LRC.GENERATION_TYPE_CD, RC.DESCRIPTION_TX  FROM dbo.LENDER_REPORT_CONFIG LRC
INNER JOIN dbo.LENDER L ON L.ID = LRC.LENDER_ID
LEFT JOIN dbo.REF_CODE RC ON RC.CODE_CD = LRC.WEB_ENABLED_CD AND RC.DOMAIN_CD = 'WebPublishStatus'
WHERE L.CODE_TX = '3141'