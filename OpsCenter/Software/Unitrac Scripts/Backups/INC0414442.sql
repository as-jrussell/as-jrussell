use unitrac

select * into unitrachdstorage..INC0414442
from loan L
where id in (
'224065987',
'224097565',
'224098826',
'224083532',
'224170262',
'224176725',
'271684969',
'271684964',
'271685007',
'271684978',
'271684983',
'271684996')


update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0414442', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from loan L
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0414442)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0414442' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan set to Unmatch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0414442)




select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0414442)


SELECT * FROM UniTracHDStorage..INC0414442

