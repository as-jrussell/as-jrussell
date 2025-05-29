USE unitrac


SELECT RC.*
into unitrachdstorage..INC0449530
FROM REQUIRED_COVERAGE RC
INNER JOIN PROPERTY P ON P.ID = RC.PROPERTY_ID AND P.PURGE_DT IS NULL
INNER JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID AND C.PURGE_DT IS NULL
INNER JOIN LOAN L ON L.ID = C.LOAN_ID AND L.PURGE_DT IS NULL
INNER JOIN LENDER LE ON LE.ID = L.LENDER_ID 
WHERE LE.CODE_TX = '3400'
AND L.BRANCH_CODE_TX = 'VSI'
AND L.RECORD_TYPE_CD <> 'D'
AND RC.RECORD_TYPE_CD = 'D'
AND P.RECORD_TYPE_CD <> 'D'



select * from required_coverage rc
join unitrachdstorage..INC0449530 cr on cr.id =rc.id


declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY

 UPDATE  RC
SET RC.RECORD_TYPE_CD = 'G', update_dt = GETDATE(), update_user_tx = 'INC0449530', rc.lender_product_id = null, rc.LOCK_ID = CASE WHEN rc.LOCK_ID >= 255 THEN 1 ELSE rc.LOCK_ID + 1 END
--SELECT   rc.RECORD_TYPE_CD, cr.RECORD_TYPE_CD, rc.lender_product_id,rc.*
from required_coverage rc
join unitrachdstorage..INC0449530 cr on cr.id =rc.id
--where ISNULL(rc.RECORD_TYPE_CD, '')is not null

--88291

 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END
