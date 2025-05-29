use unitrac



select  l.* into unitrachdstorage..Task49528 from process_log_item pli

inner join required_coverage rc on rc.id = pli.relate_id

inner join collateral c on c.property_id = rc.property_id

inner join loan l on l.id = c.loan_id

inner join property p on p.id = rc.property_id

where pli.process_log_id = 71895106

and pli.status_cd = 'err'

and l.division_code_tx = 4

and rc.type_cd = 'phys-damage'

and l.RECORD_TYPE_CD <> 'd'


UPDATE L
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'Task49528', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, Division_Code_tx = '99'
--SELECT * 
from loan L
WHERE ID IN (SELECT ID FROM UniTracHDStorage..Task49528)
	
	
	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'Task49528' , 'N' , 
 GETDATE() ,  1 , 
'Make Division 99', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..Task49528)





