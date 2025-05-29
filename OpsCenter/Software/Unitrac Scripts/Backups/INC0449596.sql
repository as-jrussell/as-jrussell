use unitrac 


select ft.*
into unitrachdstorage..INC0449596
from financial_txn ft 
join financial_txn_detail fta on ft.id = fta.FINANCIAL_TXN_ID
where ft.fpc_id =7299264  and ft.purge_dt is null
and ft.create_dt > '2019-04-29'
and ft.create_dt < '2019-04-30'
order by ft.term_no, txn_dt  asc 


update ft set REASON_TX = 'Month 9', term_no = '9'
from financial_txn ft 
join financial_txn_detail fta on ft.id = fta.FINANCIAL_TXN_ID
where ft.fpc_id =7299264  and ft.purge_dt is null
and ft.create_dt > '2019-04-29'
and ft.create_dt < '2019-04-30'






select ft.*
from financial_txn ft 
join financial_txn_detail fta on ft.id = fta.FINANCIAL_TXN_ID
where ft.fpc_id =7299264  and ft.purge_dt is null
and ft.create_dt > '2019-04-29'
and ft.create_dt < '2019-04-30'
order by ft.term_no, txn_dt  asc 


select * from ref_code
where code_cd = 'PRM'


select * from force_placed_certificate
where number_tx = 'mt50029716'

select * from cpi_activity
where cpi_quote_id = 41371713


select rc.DESCRIPTION_TX, ft.*
from financial_txn ft 
join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'
where ft.fpc_id =7299264  and ft.purge_dt is null
order by term_no, txn_dt  asc 

9313900-153



select * from lender_financial_txn
where id in (253246)



select  bg.*
from financial_txn ft 
join financial_txn_apply fta on ft.id = fta.FINANCIAL_TXN_ID
join billing_group bg on bg.id = fta.BILLING_GROUP_ID
where ft.fpc_id =7299264  and ft.purge_dt is null
order by term_no, txn_dt  asc 
