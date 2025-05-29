USE [UniTrac]
GO 




select * from lender
where name_tx like '%Amalgamated%'

select * 
into unitrachdstorage..INC0411923
from address
where id in (176375)


update a
set line_1_tx = 'PO BOX 4145', CITY_TX = 'Carmel', STATE_PROV_TX = 'IN', POSTAL_CODE_TX = '46082', update_dt = GETDATE(), LOCK_ID =LOCK_ID+1, update_user_tx = 'INC0411923'
--select *
from address a
where id in (176375)
