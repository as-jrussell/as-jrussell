use unitrac

 Declare @PLI nvarchar(255)    = XXXXXXXXX  -- (Place Process Log Item Id given from ticket here)
  DECLARE @retVal nvarchar(255)
 DECLARE @relateId nvarchar(255) 
 
 SELECT @retVal = relate_type_cd, @relateId = relate_id
from process_log_item
where id in (@PLI)
 
 
IF (@retVal = 'Allied.UniTrac.Collateral')
BEGIN
select le.name_tx, le.code_tx, l.number_tx
from collateral c
 join loan l on l.id = c.loan_id 
 join lender le on le.id = l.lender_id
 where C.ID in (@relateId)
 END
ELSE
BEGIN
select le.name_tx, le.code_tx, l.number_tx
from collateral c
 join loan l on l.id = c.loan_id 
 join lender le on le.id = l.lender_id
 where L.ID in (@relateId)
END 