use unitrac


select * 
into unitrachdstorage..INC0380604
from work_queue
where id in (11 ,194,236,183,110 ,380)



update WQ
set purge_dt =GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0380604', lock_id = lock_id+1
--select *
from work_queue WQ
where id in (11 ,194,236,183,110 ,380)