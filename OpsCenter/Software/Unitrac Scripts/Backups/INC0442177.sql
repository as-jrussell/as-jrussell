use unitrac



select * from uniTracHDStorage..INC0442177


select *
into uniTracHDStorage..INC0442177_OwnerPolicy
from Owner_Policy
where id in (select OP_ID from uniTracHDStorage..INC0442177)



update OP
set bic_id = [Allied BIC ID],  update_dt = GETDATE(), update_user_tx = 'INC0442177',  LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select bic_id, bic_name_tx, [Allied BIC ID], [Allied BIC NAME], *
from owner_policy OP
join  uniTracHDStorage..INC0442177 PO on OP.ID = PO.OP_ID


