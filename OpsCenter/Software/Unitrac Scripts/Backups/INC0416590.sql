use unitrac


select * 
into unitrachdstorage..INC0416590
from users
where id in (1536, 1538)


update u
set active_in = 'N', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0416590',LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
from users u
where id in (1536, 1538)
