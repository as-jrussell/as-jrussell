SELECT * FROM dbo.REPORT
WHERE NAME_TX = 'CPIPolicyStatus'



SELECT * FROM dbo.REPORT_HISTORY
WHERE REPORT_ID ='33' AND LENDER_ID ='2179'


SELECT * FROM dbo.LENDER
WHERE NAME_TX LIKE '%pnc%'

 CODE_TX = '7516'

 SELECT * FROM dbo.REPORT_CONFIG
 WHERE REPORT_ID = '33'


	SELECT * FROM dbo.REPORT_CONFIG
	WHERE REPORT_ID = '33'



	EXEC dbo.Report_CPIPolicyStatus @LenderCode = N'7516', -- nvarchar(10)
     @ReportType = N'CPIEXP', -- nvarchar(50)
	 @ReportConfig = 'CPIEXP' -- varchar(50)