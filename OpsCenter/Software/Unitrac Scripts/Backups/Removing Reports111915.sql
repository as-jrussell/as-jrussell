select ID as REPORT_ID, rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, LENDER_ID
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

SELECT * FROM #t t
--update rh
--SET STATUS_CD = 'IGN', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'IgnoreRH', LOCK_ID = rh.LOCK_ID + 1, MSG_LOG_TX = 'Ignore excess reports'
--FROM #t t
JOIN dbo.REPORT_HISTORY rh ON t.REPORT_ID = rh.ID
WHERE  STATUS_CD = 'PEND'



 AND 
t.TITLE IN ('Bankruptcy Status Report - Bankruptcy                                          ',
'Mortgagee Impaired Report - Impaired Due to Mortgagee                          ',
'Max Balance Report - Max Balance                                               ',
'Waive Status Report - All Balances                                             ',
'Warehouse Status Report - Warehouse                                            ',
'Track Status Report - Track                                                    ',
'Lienholder Impaired Report - Impaired Due to Lienholder                        ',
'Blanket Status Report - Blanket                                                ',
'Waive Status Report - Since Last Cycle                                         ',
'Active Loan Status Report - Active                                             ',
'Maintenance Status Report - All Collateral, With Insurance Info                ',
'High Deductible Impaired Report - With Comments                                ',
'Loan Status Report (Short) - Loan Status (Short)                               ',
'Layup Status Report - Expired                                                  ',
'Liability Card Impaired Report - Impaired Due to Liability Card                ',
'Repossession Status Report - Repossession                                      ',
'Waive Status Report - Waive                                                    ',
'Cancelled Loan Status Report - With Cancel Reason                              ',
'Audit Status Report - Audit                                                    ',
'Cancelled Loan Status Report - Cancelled                                       ',
'Impaired Insurance Status Report - With Impaired Reason                        ',
'Layup Status Report - Layup                                                    ',
'Old Insurance Report - >42 Months                                              ',
'Old Insurance Report - 12-24 Months                                            ',
'Title Exception Report - Title                                                 ',
'Old Insurance Report - 24-36 Months                                            ',
'Expired Loan Status Report - Expired Loans                                     ',
'Impaired Insurance Status Report - Impaired                                    ',
'Blanket Status Report - Sort By Loan Effective Date                            ',
'Duplicate Collateral Report - Vehicle                                          ',
'Old Insurance Report - >12 Months                                              ',
'Old Insurance Report - >24 Months                                              ',
'Loan Status Report (Short) - With Cosigner                                     ',
'Maintenance Status Report - Maintenance                                        ',
'Warehouse Status Report - With Comments                                        ',
'Expired Loan Status Report - Borrower Insurance Expires Within 30 Days         ',
'Expired Loan Status Report - Borrower Insurance Expires Within 60 Days         ',
'Duplicate Collateral Report - No Branch Grouping (Vehicle)                     ',
'Deductible Report - Mortgage/Equipment >$5000                                  ',
'Active Loan Status Report                                                      ',
'Cancelled Loan Status Report - With Impaired Code                              ',
'Suspend/Delayed Status Report - Suspend/Delayed                                ',
'Old Insurance Report - >36 Months                                              ')
ORDER BY rh.LENDER_ID ASC

DROP table #t



SELECT * FROM dbo.REPORT_HISTORY
WHERE LENDER_ID = '681' AND STATUS_CD <> 'pend'

SELECT * FROM #t
WHERE
--1473