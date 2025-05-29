delete c
from CHANGE_TXN c
left join sys.dm_tran_session_transactions t
on c.TRANSACTION_ID = t.transaction_id
where t.transaction_id is null
