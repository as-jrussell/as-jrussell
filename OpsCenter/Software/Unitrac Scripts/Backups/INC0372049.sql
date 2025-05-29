USE Unitrac


update OB
set purge_dt = GETDATE(), status_cd = 'EMPTY', OUTSOURCER_STATUS_CD = 'EMPTY', lock_id = lock_id+1, update_user_tx = 'INC0372049'
--select *
from output_batch OB
where external_id = 'PST_62968579_2073944'

