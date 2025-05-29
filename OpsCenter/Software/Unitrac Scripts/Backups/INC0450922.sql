use unitrac


select l.number_tx, c.*
into UnitracHDSTorage..INC0450922
from loan l
join collateral c on c.loan_id = l.id
where l.number_tx in ('002367628101',
'002369338703',
'002376875302',
'002392216401',
'002397552501',
'002406566601',
'002408571801',
'002423876601',
'002422260801',
'002426687901',
'002428623501',
'002447755401'
) and purpose_code_tx like 'RV%'

update c set c.collateral_code_id = 10, purpose_code_tx = 'RV',UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0450922', LOCK_ID = CASE WHEN C.LOCK_ID >= 255 THEN 1 ELSE C.LOCK_ID + 1 END
--select l.number_tx, c.*
from loan l
join collateral c on c.loan_id = l.id
where l.number_tx in ('002367628101',
'002369338703',
'002376875302',
'002392216401',
'002397552501',
'002406566601',
'002408571801',
'002423876601',
'002422260801',
'002426687901',
'002428623501',
'002447755401'
) and purpose_code_tx like 'RV%'


update c set c.COLLATERAL_CODE_ID = 210, purpose_code_tx = 'VEH',UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0450922', LOCK_ID = CASE WHEN C.LOCK_ID >= 255 THEN 1 ELSE C.LOCK_ID + 1 END
--select l.number_tx, c.*
from loan l
join collateral c on c.loan_id = l.id
where l.number_tx in ('002367628101',
'002369338703',
'002376875302',
'002392216401',
'002397552501',
'002406566601',
'002408571801',
'002423876601',
'002422260801',
'002426687901',
'002428623501',
'002447755401'
) and purpose_code_tx not like 'RV%'


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , C.ID , 'INC0450922' , 'N' , 
 GETDATE() ,  1 , 
'Update Collateral Out of Tier Tracking', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , C.ID , 'PEND' , 'N'
FROM Collateral C 
WHERE C.ID IN (SELECT ID FROM UniTracHDStorage..INC0450922)


