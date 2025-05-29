use unitrac


select relate_id into #tmpPL
from work_item
where id in () 


select * from process_log_item
where process_log_id in (select * from #tmpPL) 




select N.id into #tmpPST
from notice N
join Loan L on L.ID = N.Loan_id 
join Lender LE on LE.ID = L.Lender_id
where N.id in (select relate_id from process_log_item
where process_log_id in (select * from #tmpPL)  and relate_type_cd = 'Allied.UniTrac.Notice') 
and n.type_cd = 'PN'



update N 
set pdf_generate_cd = 'PEND', update_dt = GETDATE(), update_user_tx = 'INC0XXXXXXX', lock_id = lock_id +1
--select pdf_generate_cd,  *
from Notice N
where id in (select * from #tmpPST) 