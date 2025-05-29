use unitrac

select * into unitrachdstorage..INC0414844
from loan L
where id in (
'224085422',
'224173477',
'224154714',
'257211358',
'262523726',
'270684598',
'271715223',
'271715234',
'271715237',
'271715247',
'271715249')


update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0414844', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from loan L
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0414844)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0414844' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan set to Unmatch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0414844)




select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0414844)


SELECT * FROM UniTracHDStorage..INC0414844

