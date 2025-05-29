
---- Set RC to Archived when it is Deleted

update rc
set  update_dt = getdate(), update_user_tx = 'eomclnup', RECORD_TYPE_CD = 'A'
from #fpcNoRelatedBO t
join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on r.FPC_ID = t.FPC_ID and r.PURGE_DT is null
join REQUIRED_COVERAGE rc on rc.id = r.REQUIRED_COVERAGE_ID and rc.PURGE_DT is  null and rc.RECORD_TYPE_CD = 'D'
join PROPERTY p on p.id = rc.PROPERTY_ID and p.PURGE_DT is null




---- unpurge RC and set to archived

update rc
set PURGE_DT = null, update_dt = getdate(), update_user_tx = 'eomclnup', RECORD_TYPE_CD = 'A'
from #fpcNoRelatedBO t
join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on r.FPC_ID = t.FPC_ID and r.PURGE_DT is null
join REQUIRED_COVERAGE rc on rc.id = r.REQUIRED_COVERAGE_ID and rc.PURGE_DT is not null
join PROPERTY p on p.id = rc.PROPERTY_ID and p.PURGE_DT is null





---- Set Property to Archived when it is Deleted

UPDATE p
SET RECORD_TYPE_CD = 'A', UPDATE_USER_TX = 'EOMClnUp', UPDATE_DT = GETDATE()
FROM #fpcNoRelatedBO f 
JOIN REQUIRED_COVERAGE RC ON rc.id = f.rc_id
JOIN PROPERTY P ON P.ID = RC.PROPERTY_ID
WHERE P.RECORD_TYPE_CD = 'D'





------------------Only for Flat Canceled FPCs -----------------



DECLARE @RCold_id AS int
DECLARE @FPCold_id AS int
DECLARE @IHold_id AS int
DECLARE @Propold_id AS int

DECLARE @RCnew_id AS int
DECLARE @FPCnew_id AS int
DECLARE @IHnew_id AS int
DECLARE @Propnew_id AS int


SET @RCold_id = 43176093

SELECT RC.PROPERTY_id INto #tmpPropId FROM REQUIRED_COVERAGE RC where id =  @RCold_id

SELECT c.LOAN_id INTO #tmpLoanId FROM COLLATERAL c
JOIN #tmpPropId t ON t.propertY_id = c.PROPERTY_id


SELECT @RCold_id =  Rc.id  , @FPCold_id  = FPCRCR.FPC_id, @IHold_id  = ih.ID ,@Propold_id = P.id
--SELECT IH.TYPE_CD, OA.LINE_1_TX, P.* 
FROM COLLATERAL C 
JOIN #tmpLoanId li ON li.LOAN_id = C.LOAN_id
JOIN PROPERTY P ON P.ID = C.PROPERTY_id
JOIN REQUIRED_COVERAGE Rc ON rc.PROPERTY_id = P.ID
LEFT JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON Rc.ID = FPCRCR.REQUIRED_COVERAGE_id
JOIN INTERACTION_HISTORY IH ON IH.PROPERTY_id = C.PROPERTY_id AND IH.TYPE_CD = 'CPI'
LEFT JOIN OWNER_ADDRESS OA ON P.ADDRESS_id = OA.ID


SELECT @RCnew_id =  Rc.id  , @FPCnew_id  = FPCRCR.FPC_id, @IHnew_id  = ih.ID ,@Propnew_id = P.id
--SELECT IH.TYPE_CD, OA.LINE_1_TX, P.* 
FROM COLLATERAL C 
JOIN #tmpLoanId li ON li.LOAN_id = C.LOAN_id
JOIN PROPERTY P ON P.ID = C.PROPERTY_id
JOIN REQUIRED_COVERAGE Rc ON rc.PROPERTY_id = P.ID AND Rc.id != @RCold_id
LEFT JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON Rc.ID = FPCRCR.REQUIRED_COVERAGE_id
LEFT JOIN INTERACTION_HISTORY IH ON IH.PROPERTY_id = C.PROPERTY_id AND IH.TYPE_CD = 'CPI'
LEFT JOIN OWNER_ADDRESS OA ON P.ADDRESS_id = OA.ID



BEGIN transaction
UPDATE FPCRCR
SET REQUIRED_COVERAGE_id = @RCnew_id, UPDATE_USER_TX = 'EOMClnUp', update_dt = GETDATE()
FROM FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR WHERE id = @FPCold_id




UPDATE ih
SET SPECIAL_HANDLING_XML.modify('replace value of (/SH/RC[. = sql:variable("@RCold_id")]/text())[1]
        with sql:variable("@RCnew_id")'), PROPERTY_id = @Propnew_id, UPDATE_USER_TX = 'EOMClnUp',UPDATE_DT = GETDATE()
FROM INTERACTION_HISTORY IH WHERE id = @IHold_id



SELECT * FROM INTERACTION_HISTORY IH WHERE id = @IHold_id 

DROP TABLE #tmpLoanId

DROP TABLE #tmpPROPID

