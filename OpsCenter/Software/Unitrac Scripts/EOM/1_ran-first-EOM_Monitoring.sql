
USE UniTrac
---------------------------------------------------------------------------------------------------
-- Lender Loan
---------------------------------------------------------------------------------------------------
select ldr.ID as LENDER_ID
into #ldr
from LENDER ldr
  join RELATED_DATA rd on ldr.ID = rd.RELATE_ID and rd.VALUE_TX = 'UniTrac'
  join RELATED_DATA_DEF rdd on rd.DEF_ID = rdd.ID and rdd.NAME_TX = 'TrackingSource' and rdd.RELATE_CLASS_NM = 'Lender' 
where ldr.PURGE_DT is null and ldr.TEST_IN = 'N' AND (ldr.CANCEL_DT IS NULL or ldr.CANCEL_DT >= GETDATE()-365)
--Lenders not canceled or canceled in last year
----- optionally include Cancelled Lenders -----  and ldr.CANCEL_DT is null 

-----------------------------
-- Certs for current EOM
-----------------------------

--SELECT DISTINCT fpc.id FROM FORCE_PLACED_CERTIFICATE fpc
--JOIN FINANCIAL_TXN ft ON ft.FPC_ID = fpc.ID and ft.PURGE_DT is NULL
--JOIN ACCOUNTING_PERIOD ap ON ap.ID = ft.AP_ID and ap.YEAR_NO = 2014 AND ap.PERIOD_NO = 4




  select distinct fpc.ID as 'FPCID'
    into #CurrentFPC
  from FORCE_PLACED_CERTIFICATE fpc
    inner join LOAN l on fpc.LOAN_ID = l.ID
    inner join ACCOUNTING_PERIOD ap on l.AGENCY_ID = ap.AGENCY_ID  AND ap.YEAR_NO = DATEPART(YEAR, GETDATE()) AND ap.PERIOD_NO = DATEPART(month, GETDATE())
    inner join FINANCIAL_TXN ft on fpc.ID = ft.FPC_ID and ft.PURGE_DT is null
                               and ft.TXN_DT >= ap.START_DT and ft.TXN_DT < ap.END_DT
                               and ft.TXN_TYPE_CD in ('P', 'CP')
    inner join #ldr ldr on l.LENDER_ID = ldr. LENDER_ID
  where fpc.PURGE_DT is null

--SELECT * FROM ACCOUNTING_PERIOD ap WHERE ap.YEAR_NO = DATEPART(YEAR, GETDATE())




---------------------------------------------------------------------------------------------------
-- Duplicate Primary Owner
---------------------------------------------------------------------------------------------------
SELECT '1 - Duplicate Primary Owner' AS title, l.ID as LOAN_ID, COUNT(*) as CNT
into #dupOwner
FROM LOAN l
  join #ldr ldr ON l.LENDER_ID = ldr.LENDER_ID
  join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.PURGE_DT IS NULL AND olr.PRIMARY_IN = 'Y'
  JOIN OWNER o ON olr.OWNER_ID = o.ID and o.PURGE_DT is null
WHERE l.PURGE_DT is NULL AND l.RECORD_TYPE_CD IN ('G','A','d')
GROUP BY l.ID 
HAVING COUNT(*) > 1


SELECT '1 - Duplicate Primary Owner' , Count(*) FROM #dupOwner


--0

--------------------------------------------------------------------------------------------------
-- No Primary Owner
---------------------------------------------------------------------------------------------------
SELECT '2 - No Primary Owner'  AS title, l.ID as LOAN_ID
into #noOwner
FROM LOAN l
  join #ldr ldr ON l.LENDER_ID = ldr.LENDER_ID
  left join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.PURGE_DT IS NULL AND olr.PRIMARY_IN = 'Y'
WHERE l.PURGE_DT is NULL AND l.RECORD_TYPE_CD IN ('G','A','d')
  and olr.ID is null
  
SELECT '2 - No Primary Owner' , COUNT(*) FROM #noOwner 

--0



---------------------------------------------------------------------------------------------------
-- Duplicate Primary Loan Collateral
SELECT '3 - Duplicate Primary Loan Collateral' AS title, p.ID as PROPERTY_ID, COUNT(*) as CNT
into #dupCollateral
FROM PROPERTY p
  join #ldr ldr ON p.LENDER_ID = ldr.LENDER_ID
  join COLLATERAL c on p.ID = c.PROPERTY_ID and c.PURGE_DT IS NULL AND c.PRIMARY_LOAN_IN = 'Y'
WHERE p.PURGE_DT is NULL AND p.RECORD_TYPE_CD IN ('G','A','d')
AND CAST(c.UPDATE_DT AS date) != CAST(GETDATE() AS date) --using this because if a WI is posting the results might not be accurate
GROUP BY p.ID 
HAVING COUNT(*) > 1

SELECT '3 - Duplicate Primary Loan Collateral', COUNT(*)  from  #dupCollateral

--0
--drop table #dupCollateral

---------------------------------------------------------------------------------------------------
-- No Primary Loan Collateral
---------------------------------------------------------------------------------------------------
SELECT '4 - No Primary Loan Collateral'  AS title, p.ID as PROPERTY_ID, c.id as CollId
into #noCollateral
FROM PROPERTY p
  join #ldr ldr ON p.LENDER_ID = ldr.LENDER_ID
  left join COLLATERAL c on p.ID = c.PROPERTY_ID and c.PURGE_DT IS NULL AND c.PRIMARY_LOAN_IN = 'Y'
  left join LOAN l  on l.ID = c.LOAN_ID and l.PURGE_DT IS NULL 
WHERE p.PURGE_DT is NULL AND p.RECORD_TYPE_CD IN ('G','A','d')
  and (c.ID is null or l.id is null)
  


SELECT  '4 - No Primary Loan Collateral'  , COUNT(*)
FROM #noCollateral UHD
join PROPERTY P on UHD.PROPERTY_ID = P.ID
join REQUIRED_COVERAGE rc on P.ID = rc.PROPERTY_ID
LEFT join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRC on rc.ID = FPCRC.REQUIRED_COVERAGE_ID
LEFT join FORCE_PLACED_CERTIFICATE FPC on FPCRC.FPC_ID = FPC.ID
WHERE FPC.ID is not null and effective_dt <> cancellation_dt



--drop table #noCollateral

---------------------------------------------------------------------------------------------------
-- Duplicate Collateral tied to a Property(more than one Loan/Property relationship)
---------------------------------------------------------------------------------------------------
SELECT '5 - more than one Loan/Property relationship' AS Title, COUNT(*) as CNT, c.LOAN_ID, c.PROPERTY_ID
into #dupLoanCollatral
from LOAN l
  join #ldr ldr ON l.LENDER_ID = ldr.LENDER_ID
  join COLLATERAL c on l.ID = c.LOAN_ID and c.PURGE_DT IS NULL
WHERE l.PURGE_DT is NULL AND l.RECORD_TYPE_CD IN ('G','A','d')
group by c.LOAN_ID, c.PROPERTY_ID
having count(*) > 1 

SELECT '5 - more than one Loan/Property relationship', COUNT(*) FROM #dupLoanCollatral

--0
---------------------------------------------------------------------------------------------------
-- FPC (FORCE_PLACED_CERTIFICATE) with bad RequiredCoverage relationship(no relationship or multiple)
---------------------------------------------------------------------------------------------------
 -- FPC having no relationship with Required Coverages
SELECT '6 - FPC no relationship with RC' AS Title, fpc.id as FPC_ID, fpc.NUMBER_TX, fpc.LOAN_ID, fpc.ISSUE_DT, fpc.CANCELLATION_DT, r.ID as FPC_RC_RELATE_ID
into #fpcNoRelate
FROM FORCE_PLACED_CERTIFICATE fpc
  LEFT JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on fpc.ID = r.FPC_ID AND r.PURGE_DT IS NULL
  LEFT JOIN REQUIRED_COVERAGE rc on r.REQUIRED_COVERAGE_ID = rc.ID and rc.PURGE_DT IS NULL
WHERE fpc.PURGE_DT IS NULL AND r.ID IS NULL
order by fpc.ISSUE_DT DESC


SELECT '6 - FPC no relationship with RC', COUNT(*) FROM #fpcNoRelate
--0

---------------------------------
--- If FPC returns MUST clean up before EOM
---------------------------------------

--SELECT * FROM #fpcNoRelate FNR
--JOIN #CurrentFPC cf ON cf.FPCID = FPC_ID

-- FPC having multiple relationship with Required Coverages
SELECT '7 - FPC  multiple relationship with RC' AS Title, COUNT(*) as CNT, r.REQUIRED_COVERAGE_ID, r.FPC_ID 
into #fpcMultRelate
FROM FORCE_PLACED_CERTIFICATE fpc
  left join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on fpc.ID = r.FPC_ID and r.PURGE_DT is null
WHERE FPC.PURGE_DT IS NULL AND REQUIRED_COVERAGE_ID IS NOT NUll
GROUP BY r.REQUIRED_COVERAGE_ID, r.FPC_ID
HAVING COUNT(*) > 1


SELECT '7 - FPC  multiple relationship with RC', COUNT(*) FROM #fpcMultRelate
--0

---------------------------------
--- If FPC returns MUST clean up before EOM
---------------------------------------

--SELECT * FROM #fpcMultRelate FMR
--JOIN #CurrentFPC cf ON cf.FPCID = FPC_ID


---------------------------------------------------------------------------------------------------
-- FPC (FORCE_PLACED_CERTIFICATE) tied to Delete or Purged Collateral/Property/RequiredCoverage
---------------------------------------------------------------------------------------------------
SELECT '8 - FPC tied to Delete/ Purged Coll/Prop/RC' AS Title, fpc.id as FPC_ID, fpc.NUMBER_TX, fpc.LOAN_ID, fpc.ISSUE_DT, fpc.EFFECTIVE_DT, fpc.CANCELLATION_DT,
       rc.RECORD_TYPE_CD as RC_RECORD_TYPE_CD, p.RECORD_TYPE_CD as PROPERTY_RECORD_TYPE_CD, c.ID as COLLATERAL_ID, rc.id AS rc_id, p.ID AS property_id
into #fpcNoRelatedBO
FROM FORCE_PLACED_CERTIFICATE fpc
  join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on fpc.ID = r.FPC_ID AND r.PURGE_DT IS NULL
  left join REQUIRED_COVERAGE rc on r.REQUIRED_COVERAGE_ID = rc.ID and rc.PURGE_DT IS NULL
  left join PROPERTY p on rc.PROPERTY_ID = p.ID and p.PURGE_DT IS NULL
  left join COLLATERAL c on p.ID = c.PROPERTY_ID and c.PURGE_DT IS NULL and c.PRIMARY_LOAN_IN = 'Y'
WHERE fpc.PURGE_DT IS NULL
  and ((rc.ID is null or rc.RECORD_TYPE_CD = 'D') or
       (p.ID is null or p.RECORD_TYPE_CD = 'D') or
       (c.ID is null))
order by fpc.ISSUE_DT DESC

--#fpcNoRelatedBO


SELECT '8 - FPC tied to Delete/ Purged Coll/Prop/RC', COUNT(*) 
from #fpcNoRelatedBO F
join Collateral C on C.LOAN_ID = F.LOAN_ID
where C.LOAN_ID  IN (select LOAN_ID from COLLATERAL
where LOAN_ID NOT IN (select LOAN_ID from #fpcNoRelatedBO))


--0




---------------------------------
--- If FPC returns MUST clean up before EOM
---------------------------------------
--SELECT * FROM #fpcNoRelatedBO  fnrb
--JOIN #CurrentFPC cf ON cf.FPCID = FPC_ID






---------------------------------------------------------------------------------------------------
-- FPC (FORCE_PLACED_CERTIFICATE) tied to Delete or Purged Loan
---------------------------------------------------------------------------------------------------
SELECT '9  FPC tied to deleted/purged loan' AS Title,  fpc.id as FPC_ID, fpc.NUMBER_TX, fpc.LOAN_ID, fpc.ISSUE_DT, fpc.CANCELLATION_DT, l.RECORD_TYPE_CD as LOAN_RECORD_TYPE_CD, fpc.LOAN_NUMBER_TX
into #fpcNoLoan
FROM FORCE_PLACED_CERTIFICATE fpc
  left join LOAN l on fpc.LOAN_ID = l.ID and l.PURGE_DT is null
WHERE fpc.PURGE_DT IS NULL AND (l.ID IS NULL or l.RECORD_TYPE_CD = 'D')
order by fpc.ISSUE_DT desc

--drop table #fpcNoLoan

SELECT '9  FPC tied to deleted/purged loan', COUNT(*) FROM #fpcNoLoan
--0





---------------------------------
--- If FPC returns MUST clean up before EOM
---------------------------------------

--SELECT * FROM #fpcNoLoan  fnl
--JOIN #CurrentFPC cf ON cf.FPCID = FPC_ID




---------------------------------------------------------------------------------------------------
-- FPC (FORCE_PLACED_CERTIFICATE) tied to multiple RCs
---------------------------------------------------------------------------------------------------
SELECT '10 FPC tied to multiple RCs' AS TITLE,
p.LENDER_ID,
      rc.PROPERTY_ID,
  fpc.ID as FPC_ID,
  fpc.NUMBER_TX
INTO #FPCMultRC
from FORCE_PLACED_CERTIFICATE fpc
  join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on fpc.ID = r.FPC_ID AND r.PURGE_DT IS NULL 
  join REQUIRED_COVERAGE rc on r.REQUIRED_COVERAGE_ID = rc.ID 
  join property p ON p.ID = rc.PROPERTY_ID AND p.PURGE_DT IS null
  join #ldr ldr on p.LENDER_ID = ldr.LENDER_ID
where  fpc.PURGE_DT IS NULL
and convert(DATE, fpc.EFFECTIVE_DT) < convert(DATE, isnull(fpc.CANCELLATION_DT, '12/31/9999'))
--this is the list of reviewed FPCs that are "OK"
 AND fpc.id NOT IN (4297054)
group BY
p.LENDER_ID,
  ldr.LENDER_ID,
  rc.PROPERTY_ID,
  fpc.ID,
  fpc.NUMBER_TX
HAVING COUNT(*) > 1
 
 --drop table #FPCMultRC
SELECT '10 FPC tied to multiple RCs', COUNT(*) FROM #FPCMultRC

--0

---------------------------------
--- If FPC returns MUST clean up before EOM
---------------------------------------

--SELECT * FROM #FPCMultRC fnl
--JOIN #CurrentFPC cf ON cf.FPCID = FPC_ID


--SELECT  t.*,ldr.code_tx,  L.* 
--from #FPCMultRC t
--JOIN COLLATERAL C ON t.PROPERTY_ID = C.PROPERTY_ID
--LEFT JOIN LOAN L ON C.LOAN_ID = L.ID
--join lender ldr on t.lender_id = ldr.id





