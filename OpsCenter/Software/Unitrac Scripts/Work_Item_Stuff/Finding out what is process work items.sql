Use Unitrac



declare @WorkItem nvarchar(255) 

set @WorkItem =  'XXXXXXX'




select count(*)[Count], relate_type_cd from process_log_item
where process_log_id in (select relate_id from work_item
where id in (@WorkItem )
)
group by relate_type_cd