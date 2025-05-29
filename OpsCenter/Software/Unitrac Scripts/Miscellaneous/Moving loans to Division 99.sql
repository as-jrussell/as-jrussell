use unitrac


--Change INC0XXXXXX with the ticket number 
---Change XXXX to Lender Code TX


---Query  Loans for the lender 

select *
from LOAN L
join LENDER LL on L.LENDER_ID = LL.ID 
where LL.CODE_TX = 'XXXX'


---Backup (don't remove two dashes to complete the backup) 

select L.*
--into UniTracHDStorage..INC0XXXXXX_L
from LOAN L
join LENDER LL on L.LENDER_ID = LL.ID 
where LL.CODE_TX = 'XXXX'



--update loans
update L
set L.division_code_tx = '99'
--select L.division_code_tx, LL.division_code_tx, *
from LOAN L
join UniTracHDStorage..INC0XXXXXX_L LL on L.ID = LL.ID 


---verify
select L.division_code_tx, LL.division_code_tx, *
from LOAN L
join UniTracHDStorage..INC0XXXXXX_L LL on L.ID = LL.ID 


---insert loan history
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0XXXXXX' , 'N' , 
 GETDATE() ,  1 , 
'Moved to Division 99', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_L)



