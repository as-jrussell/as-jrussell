use unitrac


select * into unitrachdstorage..INC0422763
from loan L
where id in (
'224104101',
'224061611',
'224068233',
'224068274',
'224074926',
'224105032',
'224103271',
'224065543',
'224110089',
'224115235',
'224172549',
'272257960',
'270684589',
'272233515',
'272257974',
'272206945',
'272257999',
'272233537')




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , '' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan set to Unmatch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0422763)
and status_cd !='U'


update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0422763', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from loan L
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0422763)
and status_cd !='U'


select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0422763)


SELECT * FROM UniTracHDStorage..INC0422763





