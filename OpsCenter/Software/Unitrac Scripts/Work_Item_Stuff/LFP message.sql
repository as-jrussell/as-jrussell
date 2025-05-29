Use Unitrac




declare @ID as varchar(MAX)

set @ID = XXXXXXX 


select * from WORK_ITEM
where id in (@ID )


select relate_id into #tmpM from WORK_ITEM
where id in (@id )


select * from message
where id in (select * from #tmp) or relate_id_tx in (select * from #tmp)


select id into #tmpTPL from message
where id in (select * from #tmp) or relate_id_tx in (select * from #tmp)
and MESSAGE_DIRECTION_CD = 'I'


select * from trading_partner_log
where message_id in (select * from #tmpTPL)
order by message_id, create_dt asc


