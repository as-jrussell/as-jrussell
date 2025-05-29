use unitrac


select * from trading_partner_log
where log_message like '%Foer_Bhup_IDR%'
and create_dt >= '2018-06-28 13:00'


select * from trading_partner_log
where message_id in (13282526,
13282531)