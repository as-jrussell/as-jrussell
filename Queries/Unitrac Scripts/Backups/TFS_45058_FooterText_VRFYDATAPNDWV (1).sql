
  -- Verify Data Pending Waive Report
  update [UniTrac].[dbo].[REPORT_CONFIG]
  set FOOTER_TX = 'Above is a list of loans that have been assigned to you in the Verify Data work queue on Centerpoint.  It is presently our practice to automatically waive coverage on the loans that are assuming risk if the necessary information is not provided to us within the 90 days of being assigned.  Once the coverage has been waived, Allied Solutions will continue to monitor the insurance for the loan(s); however, no notices will be sent to the borrower and for the duration of the loan, neither the borrower nor the institution may file claims.  To ensure the purpose of this program is adequately fulfilled, it is imperative that the necessary information is provided in the Verify Data work queue in a timely manner, lessening the risk associated to the loan(s).'
  where ID=972

