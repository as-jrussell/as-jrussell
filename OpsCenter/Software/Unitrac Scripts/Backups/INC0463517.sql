use UniTrac


select l.number_tx, le.code_tx, le.name_tx, ftx.* 
--into unitrachdstorage..INC0463517
from force_placed_Certificate fpc
join financial_txn ftx on ftx.fpc_id = fpc.id
join loan l on l.id  =fpc.loan_id
join lender le on le.id = l.lender_id
where fpc.number_tx in ('MT60004985', 'MT60006122')
and amount_no in ('1.45', '0.36')




update ftx set term_no = 7, reason_tx = 'Month 7', lock_id = lock_id+1, update_dt = GETDATE(), update_user_tx = 'INC0463517'
from force_placed_Certificate fpc
join financial_txn ftx on ftx.fpc_id = fpc.id
where number_tx in ('MT60004985', 'MT60006122')
and amount_no in ('1.45')


update ftx set term_no = 4, reason_tx = 'Month 4', lock_id = lock_id+1, update_dt = GETDATE(), update_user_tx = 'INC0463517'
from force_placed_Certificate fpc
join financial_txn ftx on ftx.fpc_id = fpc.id
where number_tx in ('MT60004985', 'MT60006122')
and amount_no in ( '0.36')



update ftx set term_no = txf.term_no, reason_tx =txf.reason_tx, lock_id = lock_id+1, update_dt = GETDATE(), update_user_tx = 'INC0463517'
--select l.number_tx, le.code_tx, le.name_tx, ftx.* 
from financial_txn ftx 
join unitrachdstorage..INC0463517 txf on txf.id = ftx.id

where fpc.number_tx in ('MT60004985', 'MT60006122')
and amount_no in ('1.45', '0.36')

