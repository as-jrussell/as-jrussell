select ID as REPORT_ID, rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE
into #t
from REPORT_HISTORY rh
where REPORT_ID = 27 and STATUS_CD = 'PEND'


-- SELECT *
----update rh
----SET STATUS_CD = 'IGN', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'IgnoreRH', LOCK_ID = rh.LOCK_ID + 1, MSG_LOG_TX = 'Ignore excess reports'
--from #t t
--  join REPORT_HISTORY rh on t.REPORT_ID = rh.ID
--where t.TITLE NOT in 
--('Insufficient Insurance Report - Insufficient Insurance', 'Duplicate Collateral Report - Mortgage','Title Exception Report - Title')

SELECT DISTINCT TITLE FROM #t t
--update rh
--SET STATUS_CD = 'IGN', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'IgnoreRH', LOCK_ID = rh.LOCK_ID + 1, MSG_LOG_TX = 'Ignore excess reports'
--FROM #t t
JOIN dbo.REPORT_HISTORY rh ON t.REPORT_ID = rh.ID
WHERE t.TITLE NOT IN ('Bankruptcy Status Report - Bankruptcy', 'Mortgagee Impaired Report - Impaired Due to Mortgagee', 'Waive Status Report - All Balances',
'Warehouse Status Report - Warehouse',' Lienholder Impaired Report - Impaired Due to Lienholder',
'Active Loan Status Report - ACTIVE', 'Blanket Status Report - Blanket', 'Maintenance Status Report - All Collateral, With Insurance Info',
'Waive Status Report - Since Last Cycle', 'Insufficient Insurance Report - Insufficient Insurance', 'Liability Card Impaired Report - Impaired Due to Liability Card',
'Layup Status Report - Expired', 'Loan Status Report (Short) - Loan Status (Short)', 'Cancelled Loan Status Report - Cancelled', 'Cancelled Loan Status Report - With Cancel Reason',
'Audit Status Report - Audit', 'Blanket Status Report - Mortgage/Commercial Mortgage', 'Expired Loan Status Report - Expired Loans', 'Old Insurance Report - >42 Months',
'Expired Loan Status Report - Borrower Insurance Already Expired or Expires Within 90 Days', 'Impaired Insurance Status Report - Impaired' , 'Old Insurance Report - 12-24 Months',
'Expired Loan Status Report - Borrower Insurance Expired or Will Expire', 'Old Insurance Report - 24-36 Months','Maintenance Status Report - Maintenance', 'Blanket Status Report - Sort By Loan Effective Date',
'Duplicate Collateral Report - Vehicle', 'Warehouse Status Report - With Comments', 'Loan Status Report (Short) - Not Expired', 'Old Insurance Report - >12 Months',
'Layup Status Report - Layup', 'Old Insurance Report - >24 Months', 'Suspend/Delayed Status Report - Suspend/Delayed', 'Old Insurance Report - >36 Months', 'Old Insurance Report - 0-12 Months',
'Audit Status Report - Reaudit', 'No Insurance Report - No Insurance', 'Liability Impaired Report - Impaired Due to Liability')
AND STATUS_CD = 'PEND'
ORDER BY TITLE
--t.TITLE NOT IN 
--('Insufficient Insurance Report - Insufficient Insurance', 'Duplicate Collateral Report - Mortgage','Title Exception Report - Title')


DROP table #t


SELECT * FROM dbo.REPORT_HISTORY
WHERE ID IN (8292308)