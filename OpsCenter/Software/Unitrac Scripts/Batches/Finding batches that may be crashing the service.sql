Use Unitrac







select ob.EXTERNAL_ID, ob.status_cd, pli.*
from process_log_item pli
join output_batch ob on pli.relate_id = ob.id and pli.relate_type_cd in ('Allied.UniTrac.NoticeBatch','Allied.UniTrac.FPCBatch') 
where pli.status_cd = 'ERR'  and ob.status_cd not in ( 'COMP', 'EMPTY')
AND CAST(pli.UPDATE_DT AS DATE) >= CAST(GETDATE()-2 AS DATE) 
order by pli.update_dt desc 

--FPC_69689143_2373238


update ob set purge_dt = GETDATE()
--select *
from output_batch ob
where external_id = 'FPC_69689143_2373238'