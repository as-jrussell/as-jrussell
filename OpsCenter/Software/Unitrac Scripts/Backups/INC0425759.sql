use unitrac


select * into unitrachdstorage..INC0425759
from loan L
where id in (224142589,
224182954,
272468485,
272468525,
272468552,
272468601,
272468720,
272468721

)




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , '' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan set to Unmatch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0425759)
and status_cd !='U'


update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0425759', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from loan L
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0425759)
and status_cd !='U'


select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0425759)


SELECT * FROM UniTracHDStorage..INC0425759





