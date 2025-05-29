use unitrac




select * from unitrachdstorage..INC0442184


update op set FLOOD_INSURANCE_TYPE_CD  = C.[New Flood Doc Type Code], update_dt = GETDATE(), update_user_tx = 'INC0442184', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select FLOOD_INSURANCE_TYPE_CD  , C.[New Flood Doc Type Code],op.* 
--into unitrachdstorage..INC0442184_2
from owner_policy op
join unitrachdstorage..INC0442184 C on C.[OP id] = OP.ID
