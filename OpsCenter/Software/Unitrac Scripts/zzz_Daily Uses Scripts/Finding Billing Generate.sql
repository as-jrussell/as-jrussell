use unitrac

--drop table #tmp
select *
from work_item
where id IN (60832693)
order by update_dt desc

--add the process definition below to the next two queries 
select  * from work_item_action
where  work_item_id  IN (60832693) 
and ACTION_CD = 'Release For Billing'
order by update_dt desc 


update P set status_cd = 'Complete', onhold_in = 'N',  active_in = 'Y'
FROM    PROCESS_DEFINITION P
WHERE   id in (1052815)



---This will create a temp table to check the process log item table 
select * from process_log
where PROCESS_DEFINITION_ID  IN  (899203
) and update_dt >= '2019-10-31'

--Process logs
select * from PROCESS_LOG_ITEM
where process_log_id IN (77637741,
77637784, 77686096)


BILLING


update pd set PROC_PRIORITY_NO ='30', Status_cd= 'Complete'
--select * 
from process_definition pd
where LOAD_BALANCE_IN = 'Y'
and ACTIVE_IN = 'Y' and ONHOLD_IN = 'N'
and status_cd != 'Expired'
and id not in (428780)
and process_type_cd = 'BILLING'


