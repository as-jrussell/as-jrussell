use unitrac

--Test Plan 
SELECT  L.NUMBER_TX, C.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
inner join COLLATERAL_CODE CC on CC.ID = C.COLLATERAL_CODE_ID
WHERE LL.CODE_TX IN ('1890') and (CC.CODE_TX like '%-A' or CC.CODE_TX like '%-OT')
order by CC.CODE_TX ASC


select T.* 
from unitrachdstorage..[INC0462249] T
join loan l on l.ID = t.LOAN_ID
join COLLATERAL c on c.loan_id = l.id 
join collateral_code cc on c.collateral_code_id = cc.id
where l.lender_id = 147





select C.* 
into unitrachdstorage..INC0462249_C
from unitrachdstorage..[INC0462249] T
join loan l on l.ID = t.LOAN_ID
join COLLATERAL c on c.loan_id = l.id 
where l.lender_id = 147



update C set collateral_code_id = dc.id, lender_collateral_code_tx = T.[New Code] , update_dt = GETDATE(), update_user_tx = 'INC0462249'
--select T.* , C.*
from unitrachdstorage..[INC0462249] T
join loan l on l.ID = t.LOAN_ID
join COLLATERAL c on c.loan_id = l.id 
join collateral_code dc on dc.code_tx = T.[New Code] and dc.agency_id =1 
where l.lender_id = 147





---Backout
update C set collateral_code_id = T.collateral_code_id, lender_collateral_code_tx = T.lender_collateral_code_tx--, update_dt = GETDATE(), update_user_tx = 'INC0462249'
--select T.* , C.*
from COLLATERAL C
join unitrachdstorage..INC0462249_C T on T.ID = C.ID 