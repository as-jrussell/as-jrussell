﻿use unitrac


select * into unitrachdstorage..INC0420385
from loan L
where id in (
'224068238',
'224118756',
'224074042',
'224146654',
'224179696',
'224118014',
'224184704',
'224160115',
'272148113',
'272120021',
'271375546',
'272148117',
'272120026',
'272148116',
'272120040',
'272120030',
'272120053',
'272120054',
'272120043',
'272148130',
'272120055')


update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0420385', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from loan L
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0420385)
and status_cd !='U'


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0420385' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan set to Unmatch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0420385)
and status_cd !='U'



select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0420385)


SELECT * FROM UniTracHDStorage..INC0420385




