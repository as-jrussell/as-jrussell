use UniTrac


select * from SERVICE_FEE_INVOICE




select * from work_item
where id in (48208724 )


select * from process_log
where id = 62074255


select*from process_log_item
where process_log_id = 62074255



select DISTINCT RELATE_TYPE_CD, count(*) from process_log_item
where process_log_id = 62074255
group by RELATE_TYPE_CD
order by count(*)  DESC 



select DISTINCT RELATE_TYPE_CD, count(*) from process_log_item
where process_log_id = 61187711
group by RELATE_TYPE_CD
order by count(*)  DESC 



select * from process_log_item
where process_log_id in (61187711,62063739)
and RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'



select * from work_item
where relate_id
in (61187711)
and workflow_definition_id = 15


SELECT CONVERT(TIME,END_DT- START_DT), * from process_log
where process_definition_id = 648524
order by update_dt desc