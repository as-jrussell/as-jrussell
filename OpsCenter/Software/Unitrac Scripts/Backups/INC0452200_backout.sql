use unitrac






--revert to back up 

update lpc
set DONT_REPORT_ESCROW_IN = ic.DONT_REPORT_ESCROW_IN, UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0452200', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from lender_payee_code_file lpc 
join unitrachdstorage..INC0452200 ic on lpc.id = ic.id