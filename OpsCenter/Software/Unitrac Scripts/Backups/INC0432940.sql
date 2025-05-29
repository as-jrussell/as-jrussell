use unitrac


select * into unitrachdstorage..INC0432940
from loan L
where id in ('224066666',
'271342425',
'271342439',
'271321005',
'271321011',
'271320983',
'271321008',
'271342473',
'271321007',
'271321005',
'271321011',
'271320983',
'271321008',
'271321007'

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
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0432940)
and status_cd !='U'


update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0432940', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from loan L
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0432940)
and status_cd !='U'


select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0432940)


SELECT * FROM UniTracHDStorage..INC0432940





