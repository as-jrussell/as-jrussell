
--drop table #tmp



----create the temp table for all the below updates

SELECT  l.ID AS loanid, c.ID as collid, c.PROPERTY_ID, c.PRIMARY_LOAN_IN,c.STATUS_CD, c.CREATE_DT 
INTO #tmp
FROM COLLATERAL c 
JOIN LOAN l ON l.ID = c.LOAN_ID and l.PURGE_DT is NULL and c.PURGE_DT IS NULL
join #dupLoanCollatral t ON t.PROPERTY_ID = c.PROPERTY_ID AND t.LOAN_ID = l.ID




---MAY NEED TO RUN THROUGH MORE THAN ONCE-------

---- Purge the non_primary if there is a primary

--UPDATE c
--SET c.PURGE_DT = GETDATE(), c.uPDATE_DT = GETDATE(), c.LOCK_ID = c.LOCK_ID + 1, c.UPDATE_USER_TX = 'EOMCleanUp'
--FROM COLLATERAL c
--JOIN #tmp t ON c.PROPERTY_ID = t.PROPERTY_ID and c.PRIMARY_LOAN_IN = 'N' AND t.PRIMARY_LOAN_IN = 'Y' and c.loan_id = t.loanid

---- Purge the unmatched if there is an active

--UPDATE c
--SET c.PURGE_DT = GETDATE(), c.uPDATE_DT = GETDATE(), c.LOCK_ID = c.LOCK_ID + 1, c.UPDATE_USER_TX = 'EOMCleanUp'
--FROM COLLATERAL c
--JOIN #tmp t ON c.PROPERTY_ID = t.PROPERTY_ID and c.STATUS_CD = 'U' AND t.status_cd = 'A' and c.loan_id = t.loanid


---- Purge the newest when all other status are the same 

--UPDATE c
--SET c.PURGE_DT = GETDATE(), c.uPDATE_DT = GETDATE(), c.LOCK_ID = c.LOCK_ID + 1, c.UPDATE_USER_TX = 'EOMCleanUp'
--FROM COLLATERAL c
--JOIN #tmp t ON c.PROPERTY_ID = t.PROPERTY_ID and c.STATUS_CD = t.status_cd  AND c.ID > t.collid AND c.LOAN_ID = t.loanid and c.PRIMARY_LOAN_IN = t.PRIMARY_LOAN_In



drop table #tmp