use unitrac


select * from lender
where code_tx = '3145'


select *
--into UniTracHDStorage..INC0373832_L
from LOAN L
where lender_id = 2097



update L
set L.division_code_tx = '99'
--select L.division_code_tx, LL.division_code_tx, *
from LOAN L
join UniTracHDStorage..INC0373832_L LL on L.ID = LL.ID 
where L.lender_id = 2097


select L.division_code_tx, LL.division_code_tx, *
from LOAN L
join UniTracHDStorage..INC0373832_L LL on L.ID = LL.ID 
where L.lender_id = 2097


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0373832' , 'N' , 
 GETDATE() ,  1 , 
'Moved to Division 99', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0373832_L)


