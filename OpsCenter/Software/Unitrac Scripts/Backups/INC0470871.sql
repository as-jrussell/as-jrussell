use unitrac


select top 5 * 
from unitrachdstorage..INC0470871 i



select i.*, p.*
into unitrachdstorage..INC0470871_2771TierTracking_Property
from unitrachdstorage..INC0470871 i
join unitrac..PROPERTY p on i.vin = p.vin_tx
where p.lender_id = 968 and i.vin is not null


select * from unitrachdstorage..INC0470871_C

select C.* 
into unitrachdstorage..INC0470871_C
from unitrachdstorage..INC0470871_2771TierTracking_Property P
join unitrac..COLLATERAL c on C.PROPERTY_ID = P.id 
where p.lender_id = 968



update C set collateral_code_id = dc.id, lender_collateral_code_tx = T.[New Code], update_dt = GETDATE(), update_user_tx = 'INC0470871'
--select C.*
from unitrachdstorage..INC0470871_2771TierTracking_Property T
join unitrac..COLLATERAL c on C.ID = T.id
join unitrac..loan l on L.ID = C.LOAN_ID 
join unitrac..collateral_code dc on dc.code_tx = T.[new code] and dc.agency_id =1 
where l.lender_id = 968





---Backout
update C set collateral_code_id = T.collateral_code_id, lender_collateral_code_tx = T.lender_collateral_code_tx, update_dt = GETDATE(), update_user_tx = 'INC0470871'
--select T.* , C.*
from COLLATERAL C
join unitrachdstorage..INC0470871_C T on T.ID = C.ID 