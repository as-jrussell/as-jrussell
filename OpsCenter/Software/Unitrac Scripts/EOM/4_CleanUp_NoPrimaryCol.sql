****NOTE :  if we purge any collateral, we need to calculate balance and run good thru. If there are only few, we can do from UI.****





---- Set collateral to primary where only 1 collateral

SELECT c.PROPERTY_ID 
INTO #tmp
FROM COLLATERAL c 
JOIN PROPERTY p ON p.ID = c.PROPERTY_ID
JOIN #noCollateral nc ON nc.PROPERTY_ID = p.id
WHERE  c.PURGE_DT IS NULL 
GROUP by c.PROPERTY_ID
HAVING COUNT(*) = 1


UPDATE c
SET c.PRIMARY_LOAN_IN = 'Y', c.UPDATE_USER_TX = 'EOMCleanUp', c.LOCK_ID = c.LOCK_ID + 1, c.UPDATE_DT = GETDATE()
FROM PROPERTY p
JOIN #tmp t ON t.PROPERTY_ID = p.ID
JOIN COLLATERAL c ON c.PROPERTY_ID = p.ID and c.PURGE_DT is NULL  

drop table #tmp


---- Set collateral to primary where more than 1 collateral


SELECT l.RECORD_TYPE_CD, l.STATUS_CD AS LoanStatus, c.loan_id, c.PROPERTY_ID, c.ID AS coll_id, c.STATUS_CD, c.LOAN_BALANCE_NO, c.CREATE_DT 
INTO #tmp1
FROM COLLATERAL c 
JOIN LOAN l ON l.ID = c.LOAN_ID and l.PURGE_DT is NULL
JOIN #noCollateral nc ON nc.PROPERTY_ID = c.PROPERTY_ID
WHERE c.PURGE_DT is NULL
AND c.PRIMARY_LOAN_IN = 'N'  



---- Set Active collateral as primary when other is unmatched

--UPDATE C
--SET PRIMARY_LOAN_IN = 'Y', UPDATE_USER_TX = 'EOMCleanUp', UPDATE_DT = GETDATE(), LOCK_ID = c.LOCK_ID + 1
--  FROM #tmp1 t
--join collateral c on c.id = t.coll_id
--WHERE t.LoanStatus = 'A' AND t.PROPERTY_ID IN (SELECT PROPERTY_ID FROM #tmp1 t2 where t2.LoanStatus = 'U')




---- Set Active collateral as primary when other Loan is unmatched

--UPDATE C
--SET PRIMARY_LOAN_IN = 'Y', UPDATE_USER_TX = 'EOMCleanUp', UPDATE_DT = GETDATE(), LOCK_ID = c.LOCK_ID + 1
--  FROM #tmp1 t
--join collateral c on c.id = t.coll_id
--WHERE t.STATUS_CD = 'A' AND t.PROPERTY_ID IN (SELECT PROPERTY_ID FROM #tmp1 t2 where t2.STATUS_CD = 'U')


--  UPDATE c
--SET PRIMARY_LOAN_IN = 'Y', UPDATE_USER_TX = 'EOMCleanUp', UPDATE_DT = GETDATE(), LOCK_ID = c.LOCK_ID + 1
----SELECT *
--FROM #tmp1 t
--JOIN COLLATERAL c ON c.PROPERTY_ID = t.PROPERTY_ID and c.PURGE_DT IS NULL 
--JOIN LOAN l ON l.ID = c.LOAN_ID
--WHERE 
--t.LOAN_BALANCE_NO < c.LOAN_BALANCE_NO
--and t.STATUS_CD = c.STATUS_CD
--AND c.PRIMARY_LOAN_IN = 'N'
--AND t.RECORD_TYPE_CD = l.RECORD_TYPE_CD 
----AND l.RECORD_TYPE_CD = 'G'
--AND t.LoanStatus = l.STATUS_CD



--UPDATE C
--SET PRIMARY_LOAN_IN = 'Y', UPDATE_USER_TX = 'EOMCleanUp', UPDATE_DT = GETDATE(), LOCK_ID = c.LOCK_ID + 1

----SELECT *
--FROM #tmp1 t
--join collateral c on c.id = t.coll_id
--JOIN LOAN l ON l.ID = t.LOAN_ID
--WHERE t.RECORD_TYPE_CD = 'G' AND t.PROPERTY_ID IN (SELECT PROPERTY_ID FROM #tmp1  where RECORD_TYPE_CD = 'A' and PRIMARY_LOAN_IN = 'N')  and PRIMARY_LOAN_IN = 'N'


drop table #tmp1


-- multiple unmatched collateral
-- rerun step 4 before running!

drop table #noCollateral

  SELECT C.PROPERTY_ID, MIN(c.id) AS PrimeCol
  INTO #tmpcol
  FROM #noCollateral t
  JOIN COLLATERAL C ON t.PROPERTY_ID = C.PROPERTY_ID
  GROUP BY C.PROPERTY_ID 
  
  
  ----SELECT C.*
  
  --UPDATE c
  --SET PRIMARY_LOAN_IN = 'Y', c.UPDATE_USER_TX = 'EOMCleanUp', c.LOCK_ID = c.LOCK_ID + 1, c.UPDATE_DT = GETDATE()
  --FROM  #tmpcol t
  --JOIN COLLATERAL C ON C.ID = t.PrimeCol




---- Purge property that has no collateral


    --Determine property IDs that have collateral
    SELECT p.id
  FROM COLLATERAL c 
JOIN PROPERTY p ON p.ID = c.PROPERTY_ID
JOIN #noCollateral nc ON nc.PROPERTY_ID = p.id
WHERE c.PURGE_DT IS null

   --Determine property IDs that have FPCs
  SELECT p.ID, fpc.ID
  FROM REQUIRED_COVERAGE rc
JOIN PROPERTY p ON p.ID = rc.PROPERTY_ID and rc.PURGE_DT is null
JOIN #noCollateral nc ON nc.PROPERTY_ID = p.ID
JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE fpcrcr ON fpcrcr.REQUIRED_COVERAGE_ID = rc.ID and fpcrcr.PURGE_DT is NULL
JOIN FORCE_PLACED_CERTIFICATE fpc ON fpc.ID = fpcrcr.FPC_ID AND fpc.PURGE_DT is NULL


--UPDATE P
--SET p.PURGE_DT = GETDATE(), p.UPDATE_USER_TX = 'EOMCleanUp', p.UPDATE_DT = GETDATE(), p.LOCK_ID = p.LOCK_ID + 1
--FROM COLLATERAL c 
--right JOIN PROPERTY p ON p.ID = c.PROPERTY_ID and c.PURGE_DT IS null
--JOIN #noCollateral nc ON nc.PROPERTY_ID = p.id
--WHERE c.ID IS NULL 
and p.id NOT IN (property IDs from the above two queries)





---Verify if any FPCs are tied to the properties. If not, can ignore

SELECT FPC.ID,*
FROM #noCollateral UHD
join PROPERTY P on UHD.PROPERTY_ID = P.ID
join REQUIRED_COVERAGE rc on P.ID = rc.PROPERTY_ID
LEFT join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRC on rc.ID = FPCRC.REQUIRED_COVERAGE_ID
LEFT join FORCE_PLACED_CERTIFICATE FPC on FPCRC.FPC_ID = FPC.ID
WHERE FPC.ID is not null and effective_dt <> cancellation_dt

---Also, if FPC is flat cancelled (EFF DATE = CXL DATE), those can also be ignored.
