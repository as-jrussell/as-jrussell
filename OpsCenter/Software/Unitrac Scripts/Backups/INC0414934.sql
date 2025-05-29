use unitrac


select L.SPECIAL_HANDLING_XML,  * from loan l 
join lender ll on ll.id = l.lender_id 
where LL.CODE_TX = '1615' and L.Balance_Amount_NO = '0.00'
and L.NUMBER_TX IN 
('0468660553',
'0468660842',
'0468680866',
'0468740800',
'0468780905',
'0468807931',
'0468810249',
'0465763740',
'0029226041',
'0470093221',
'0011742043',
'0469523304',
'0050013240')



select L.*  into unitrachdstorage..INC0414934
from loan l 
join lender ll on ll.id = l.lender_id 
where LL.CODE_TX = '1615' and L.Balance_Amount_NO = '0.00'
and record_type_cd IN ('G', 'A') 
and l.purge_dt is  null



update L
set L.SPECIAL_HANDLING_XML = NULL, UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0414934', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
from loan L
where L.id in (select id from  unitrachdstorage..INC0414934)