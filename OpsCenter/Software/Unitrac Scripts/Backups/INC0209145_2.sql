EXECUTE dbo.Report_CPIPolicyStatus @LenderCode = N'1952', -- nvarchar(10)
    @ReportType = N'CPIINFC', -- nvarchar(50)
    @ReportConfig = 'CPIINFC'



EXECUTE dbo.Report_CPIPolicyStatus @LenderCode = N'', -- nvarchar(10)
    @Branch = N'', -- nvarchar(max)
    @Division = N'', -- nvarchar(10)
    @Coverage = N'', -- nvarchar(100)
    @ReportType = N'', -- nvarchar(50)
    @ReportConfig = '', -- varchar(50)
    @GroupByCode = N'', -- nvarchar(50)
    @SortByCode = N'', -- nvarchar(50)
    @FilterByCode = N'', -- nvarchar(50)
    @Report_History_ID = 0 -- bigint


	SELECT * FROM dbo.REPORT_HISTORY
	WHERE LENDER_ID IN  (442) AND 
	REPORT_ID IN (33)
	AND REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) LIKE '%Force%'
	--AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)



	SELECT * FROM  dbo.LENDER
	WHERE CODE_TX = '1952'




	SELECT * FROM dbo.REF_CODE
	WHERE DESCRIPTION_TX LIKE '%inforce%'



	SELECT * FROM dbo.REF_CODE
	WHERE DOMAIN_CD = 'LoanStat4'


	SELECT TOP 5 * FROM dbo.CPI_ACTIVITY

	SELECT TOP 5 * FROM dbo.CPI_QUOTE





	SELECT *
	from dbo.PROPERTY P 
Join dbo.COLLATERAL C on C.PROPERTY_ID = P.ID AND C.PURGE_DT IS NULL and C.PRIMARY_LOAN_IN = 'Y' 
Join dbo.LOAN L on L.ID = C.LOAN_ID and L.LENDER_ID = P.LENDER_ID AND L.PURGE_DT IS NULL
Join dbo.LENDER LND on LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
where 
P.PURGE_DT IS NULL AND L.LENDER_ID = '442'



   SELECT
      ID,
      BASIS_TYPE_CD,
      BASIS_NO,
      TERM_TYPE_CD,
      TERM_NO,
      CLOSE_DT,
      CLOSE_REASON_CD,
      COVERAGE_AMOUNT_NO,
      PAYMENT_INCREASE_METHOD_CD, 
      PAYMENT_INCREASE_METHOD_VALUE_NO,
      FIRST_PAYMENT_DIFFERENCE_NO,
      NEW_PAYMENT_AMOUNT_NO,
      LOCK_ID,
      MASTER_POLICY_ASSIGNMENT_ID,
      TOTAL_COVERAGE_AMOUNT_NO,
      FIRST_MONTH_BILL_NO,
      NEXT_MONTH_BILL_NO
   FROM CPI_QUOTE
   WHERE
      ID = '442'