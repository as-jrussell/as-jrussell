﻿use unitrac

update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0406447', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select * 
--into unitrachdstorage..INC0406447
from loan L
where id in ('224063333',
'224096280',
'224113014',
'224080324',
'224087482',
'236046154',
'247779278',
'224067669',
'224138601',
'224110277',
'224140548',
'224062849',
'224092727',
'224119543',
'224122403',
'224154568',
'224086167',
'224071443',
'224103261',
'224104638',
'224153796',
'224164057',
'224106848',
'224135913',
'224148732',
'224157190',
'224068582',
'224069508',
'224150655',
'224094658',
'224131424',
'224145315',
'224142202',
'224075450',
'224078842',
'224148186',
'224076447',
'224125828',
'224110278',
'224169365',
'224145981',
'224157892',
'224110511',
'224170986',
'224172347',
'224095115',
'224108480',
'224110228',
'224142196',
'224178824',
'224171289',
'224118638',
'224121157',
'224154255',
'224183067',
'224129181',
'224138064',
'224186581',
'224150746',
'225986950',
'230633889',
'230634075',
'256630653',
'259081447',
'250305339',
'258885496',
'257211449',
'266877607',
'259974940',
'271180437',
'267851715',
'271180441',
'271180457',
'271180463',
'271655415',
'271715192',
'224167018',
'224175688',
'224197273',
'224111799',
'224110085')




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0406447' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan set to Unmatch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0406447)




select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0406447)


SELECT * FROM UniTracHDStorage..INC0406447