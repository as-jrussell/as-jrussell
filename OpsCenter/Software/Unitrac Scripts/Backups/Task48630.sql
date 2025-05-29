use unitrac


select bic_id, * from owner_policy op
join unitrachdstorage..[homestreetdata] pd on pd.[OP_ID] = OP.ID




select OP.* into unitrachdstorage..Task48631 from owner_policy op
join unitrachdstorage..[homestreetdata] pd on pd.[OP_ID] = OP.ID


update OP set BIC_ID = [Allied BIC ID], update_dt = GETDATE(), lock_id = lock_id+1, update_user_tx = 'Task48631'
--select bic_id,  OP.* 
from owner_policy op
join unitrachdstorage..[homestreetdata] pd on pd.[OP_ID] = OP.ID

