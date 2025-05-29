use unitrac




select * from unitrachdstorage..INC0439695_C


update op set FLOOD_INSURANCE_TYPE_CD  = C.[New Flood Doc Type Code], update_dt = GETDATE(), update_user_tx = 'INC0439695', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select FLOOD_INSURANCE_TYPE_CD  , C.[New Flood Doc Type Code],* 
--into unitrachdstorage..INC0439695
from owner_policy op
join unitrachdstorage..INC0439695_C C on C.[OP id] = OP.ID
where id in (255260079)