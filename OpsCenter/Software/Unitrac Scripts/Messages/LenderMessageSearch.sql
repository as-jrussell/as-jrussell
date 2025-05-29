use unitrac



select *
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
where  tpl.create_dt >= '2020-01-02'
and tp.EXTERNAL_ID_TX = '' 
