SELECT COUNT(*) Pending FROM UniTrac..REPORT_HISTORY
WHERE UPDATE_DT >= '2015-07-27' AND STATUS_CD = 'PEND'

SELECT COUNT(*) Completed FROM UniTrac..REPORT_HISTORY
WHERE UPDATE_DT >= '2015-07-28' AND STATUS_CD = 'COMP'

SELECT COUNT(*) Error FROM UniTrac..REPORT_HISTORY
WHERE UPDATE_DT >= '2015-07-28' AND STATUS_CD = 'ERR'

SELECT COUNT(*) IGN FROM UniTrac..REPORT_HISTORY
WHERE UPDATE_DT >= '2015-07-28' AND STATUS_CD = 'IGN'




--SELECT  * FROM UniTrac..REPORT_HISTORY
--WHERE UPDATE_DT >= '2015-07-28' AND STATUS_CD = 'COMP'
----4916

--SELECT  * FROM UniTrac..REPORT_HISTORY
--WHERE UPDATE_DT >= '2015-07-28' AND STATUS_CD = 'PEND'
----1102
----1052
----1030
----998

select * FROM Report_History
WHERE UPDATE_DT >= '2015-07-28' AND STATUS_CD='pend'