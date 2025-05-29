****NOTE :  if we purge any collateral, we need to calculate balance and run good thru. If there are only few, we can do from UI.****





--SELECT l.RECORD_TYPE_CD, l.STATUS_CD AS LoanStatus, c.loan_id, c.PROPERTY_ID, c.ID AS coll_id, c.STATUS_CD, c.LOAN_BALANCE_NO, c.CREATE_DT 
--INTO #tmp
--FROM COLLATERAL c 
--JOIN LOAN l ON l.ID = c.LOAN_ID and l.PURGE_DT is NULL
--JOIN #dupCollateral c1 ON c1.PROPERTY_ID = c.PROPERTY_ID
--WHERE  c.PURGE_DT is NULL
--AND c.PRIMARY_LOAN_IN = 'Y'

---- Run this update where one collateral is unmatched and the other is active.

--UPDATE C
--SET PRIMARY_LOAN_IN = 'N', UPDATE_USER_TX = 'EOMCleanUp', UPDATE_DT = GETDATE(), LOCK_ID = c.LOCK_ID + 1
--FROM #tmp t
--join collateral c on c.id = t.coll_id
--WHERE t.STATUS_CD = 'U' AND t.PROPERTY_ID IN (SELECT PROPERTY_ID FROM #tmp t2 where t2.STATUS_CD = 'A') AND c.PRIMARY_LOAN_IN = 'Y'



----If all loans have same record type of and status and collateral status then update based on loan balance


--UPDATE c
--SET PRIMARY_LOAN_IN = 'N', UPDATE_USER_TX = 'EOMCleanUp', UPDATE_DT = GETDATE(), LOCK_ID = c.LOCK_ID + 1
--fROM #tmp t
--JOIN COLLATERAL c ON c.PROPERTY_ID = t.PROPERTY_ID and c.PURGE_DT IS NULL 
--JOIN LOAN l ON l.ID = c.LOAN_ID
--WHERE 
--t.LOAN_BALANCE_NO > c.LOAN_BALANCE_NO
--and t.STATUS_CD = c.STATUS_CD
--AND c.PRIMARY_LOAN_IN = 'Y'
--AND t.RECORD_TYPE_CD = l.RECORD_TYPE_CD 
----AND l.RECORD_TYPE_CD = 'G'
--AND t.LoanStatus = l.STATUS_CD
--AND CAST(c.UPDATE_DT AS date) != CAST(GETDATE() AS date)



drop table #tmp

---- clean up duplicates all with zero loan balance

select max(c.id) as collid 
into #tmpid
from #dupCollateral d
join COLLATERAL c on c.PROPERTY_ID = d.PROPERTY_ID and c.PURGE_DT is null and c.PRIMARY_LOAN_IN = 'Y' and c.LOAN_BALANCE_NO = '0.00'
group by c.PROPERTY_ID
having count(*) > 1


update C
set PRIMARY_LOAN_IN = 'N', UPDATE_USER_TX = 'EOMCleanUp', UPDATE_DT = GETDATE(), LOCK_ID = c.LOCK_ID + 1
from #tmpid t
join COLLATERAL c on c.id = t.collid


----


---- check out the remaining duplicates

select c.* 
from #dupCollateral d
join COLLATERAL c on c.PROPERTY_ID = d.PROPERTY_ID and c.PURGE_DT is null and c.PRIMARY_LOAN_IN = 'Y'
order by c.PROPERTY_ID, c.id




