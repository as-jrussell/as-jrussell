use unitrac


select pc.*
into task48170_policycoverage
 from policy_coverage pc
inner join owner_policy op on op.id = pc.owner_policy_id
where owner_policy_id = 41709656

select op.*
into task48170_ownerpolicy
 from policy_coverage pc
inner join owner_policy op on op.id = pc.owner_policy_id
where owner_policy_id = 41709656

update pc set  pc.end_dt = '2013-06-24', UPDATE_DT = GETDATE(), update_user_tx = 'task48170',pc.LOCK_ID = CASE WHEN pc.LOCK_ID >= 255 THEN 1 ELSE pc.LOCK_ID + 1 END
--select * 
from policy_coverage pc
inner join owner_policy op on op.id = pc.owner_policy_id
where owner_policy_id = 41709656




update op set  op.expiration_dt = '2013-06-24', UPDATE_DT = GETDATE(), update_user_tx = 'task48170',LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select * 
from owner_policy op 
where id = 41709656


/* update the op.expiration_dt to 06/24/2013 and pc.end_dt to 06/24/13*/​