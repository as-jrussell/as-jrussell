use unitrac


select  esc.* 
---select distinct esc.id
 --into unitrachdstorage..INC0407988
from 
  ESCROW ESC  
 JOIN ESCROW_REQUIRED_COVERAGE_RELATE ER1 ON ER1.escrow_id = ESC.ID
 join REQUIRED_COVERAGE RC1  ON ER1.REQUIRED_COVERAGE_ID = RC1.ID
 JOIN REQUIRED_ESCROW RE1 ON RE1.REQUIRED_COVERAGE_ID = RC1.ID
 join collateral C on C.PROPERTY_ID = RC1.PROPERTY_ID
 join Loan L on L.ID = C.LOAN_ID
 join Lender LL on LL.ID = L.Lender_id
 where LL.CODE_TX = '7400' and esc.STATUS_CD <> 'CLSE'
order by esc.create_dt asc



