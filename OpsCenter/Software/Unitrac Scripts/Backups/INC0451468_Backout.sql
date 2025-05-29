use unitrac


update c
set COLLATERAL_CODE_ID = ci.COLLATERAL_CODE_ID, PURPOSE_CODE_TX = ci.PURPOSE_CODE_TX, UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select * 
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id





update L
set  l.branch_code_tx = c.branch_code_tx, UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
from LOAN l 
join unitrachdstorage..INC0451468_branch ci on ci.id = l.id
