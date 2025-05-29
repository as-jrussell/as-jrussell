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


update rh
SET STATUS_CD = 'IGN', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'IgnoreRH', LOCK_ID = rh.LOCK_ID + 1, MSG_LOG_TX = 'Ignore excess reports'
FROM #t t
--SELECT * FROM #t t
JOIN dbo.REPORT_HISTORY rh ON t.REPORT_ID = rh.ID
WHERE STATUS_CD <> 'IGN' AND t.TITLE IN 
('Max Balance Report - Max Balance',
'Repossession Status Report - Repossession',
'Deductible Report - Mortgage/Equipment >5% of Coverage',
'Deductible Report - Mortgage/Equipment >$1000',
'Blanket Status Report - Mortgage/Commercial Mortgage',
'Deductible Report - Mortgage/Equipment >$2500',
'Suspend/Delayed Status Report - Suspend/Delayed',
'Layup Status Report - Layup',
'Loan Status Report (Short) - Multiple Collaterals that are Duplicates')


DROP table #t

SELECT  COUNT(*) TotalPending
FROM    report_history
WHERE   STATUS_CD = 'IGN'
AND CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)
