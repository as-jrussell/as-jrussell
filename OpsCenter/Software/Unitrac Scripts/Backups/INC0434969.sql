use unitrac


select l.* 
into unitrachdstorage..INC0434969
from loan l
join lender ll on ll.id = lender_id
where ll.code_tx = '7127' and l.PURGE_DT is null
and l.record_type_cd IN ('G', 'A')





USE UniTrac







declare @rowcount int = 1000
while @rowcount >= 1000
BEGIN
 BEGIN TRY

 UPDATE TOP (1000) L
SET division_code_tx = '99',UPDATE_DT = GETDATE(),UPDATE_USER_TX = ' INC0434969', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT   count(STATUS_CD)  
FROM LOAN l
where  ISNULL(division_code_tx, '') != '99'
and id in (select id from unitrachdstorage..INC0434969)


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
				 



	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0434969' , 'N' , 
 GETDATE() ,  1 , 
'Move loans to Division 99', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0434969)


