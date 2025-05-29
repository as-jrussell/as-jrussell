USE ROLE OWNER_EDW_PROD;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_PROD;
USE SCHEMA stg;

Desc view EDW_DEV.STG.VW_PBI_LONGEST_RUNNING_JOBS_REVIEW;

create or replace view EDW_PROD.STG.VW_PBI_LONGEST_RUNNING_JOBS_REVIEW(
	SOURCE_SYSTEM_NAME,
	PROCESS_NAME,
	RUNTIME
) as 
(
with avg_run as (select source_system_name, process_name, avg(wf_run_time) wf_run_time
from 
(select source_system_name, process_name,datediff(minute, process_start_dt, process_end_dt) wf_run_time , rank() over (partition by source_system_name, process_name order by process_start_Dt desc ) rnk 
from stg.etl_Process_control
where process_status_Code='C') 
where rnk<=10 
group by source_system_name, process_name),
current_run as (select source_system_name, process_name,datediff(minute, process_start_dt, process_end_dt) current_run_time 
from stg.etl_Process_control epc, 
(select source_system, batch_id from stg.etl_batch where batch_end_dt is  null ) eb
where process_status_Code='C'
and epc.batch_id = eb.batch_id 
               and epc.source_system_name = eb.source_system) 
select  current_run.source_system_name, current_run.process_name, case when  avg_run.wf_run_time!=0 and avg_run.wf_run_time is not null then current_run.current_run_time/avg_run.wf_run_time else 0 end as RunTime
from current_run 
left join avg_run on current_run.process_name = avg_run.process_name and current_run.source_system_name = avg_run.source_system_name
where  case when  avg_run.wf_run_time!=0 and avg_run.wf_run_time is not null then current_run.current_run_time/avg_run.wf_run_time else 0 end>1.25
 -- Longer running jobs for reVIEW stg current cycle.
);



Desc view EDW_DEV.STG.VW_PBI_PERCENTAGE_COMPLETE_RUNNING_TASKFLOW;

create or replace view EDW_PROD.STG.VW_PBI_PERCENTAGE_COMPLETE_RUNNING_TASKFLOW(
	SOURCE_SYSTEM_NAME,
	PROCESS_NAME,
	CALCULATED_PCT_COMPLETE,
	EXPECTED_TIME_TO_COMPELTE
) as 
(
with avg_run as (select source_system_name, process_name, avg(wf_run_time) wf_run_time
from 
(select source_system_name, process_name, datediff(minute, process_start_dt, process_end_dt) wf_run_time , rank() over (partition by source_system_name,process_name order by process_start_Dt desc ) rnk 
from stg.etl_Process_control
where process_status_Code='C') 
where rnk<=10 
group by source_system_name,process_name),
current_run as (select source_system_name, process_name, datediff(minute, process_start_dt, getdate()) current_run_time 
from stg.etl_Process_control
where process_status_Code='R' and batch_id in (select batch_id from stg.etl_batch where  batch_end_dt is  null )) 
select current_Run.source_system_name, current_Run.process_name
, current_run.current_run_time*100/avg_run.wf_run_time calculated_pct_complete
, avg_run.wf_run_time - current_run.current_run_time expected_time_to_compelte
from current_Run left join avg_run
on avg_run.process_name = current_run.process_name 
  -- Calculate percentage complete and expected time to complete for all running taskflow
);


Desc view EDW_DEV.STG.VW_PBI_AVERAGE_TASKFLOW_RUN_TIME;

create or replace view EDW_PROD.STG.VW_PBI_AVERAGE_TASKFLOW_RUN_TIME(
	SOURCE_SYSTEM_NAME,
	PROCESS_NAME,
	WF_RUN_TIME
) as (
select source_system_name,process_name, avg(wf_run_time) wf_run_time
from 
(select source_system_name,process_name,datediff(minute, process_start_dt, process_end_dt) wf_run_time , rank() over (partition by source_system_name,process_name order by process_start_Dt desc ) rnk 
from stg.etl_Process_control
where process_status_Code='C' and process_start_dt >= dateadd(month, -2, sysdate())) 
where rnk<=10 and wf_run_time >0 
group by source_system_name,process_name
-- Gives average tf run time 
);


Desc view EDW_DEV.STG.VW_PBI_AVERAGE_BATCH_RUN_TIME;

create or replace view EDW_PROD.STG.VW_PBI_AVERAGE_BATCH_RUN_TIME(
	SOURCE_SYSTEM,
	AVG_RUN_TIME
) as (
select source_system, avg(batch_run_time) avg_run_time
from 
(select source_system, datediff(minute, batch_start_dt, batch_end_dt) batch_run_time,rank() over (partition by source_system order by batch_start_dt desc) rank 
from stg.etl_batch
where batch_end_dt is not null and batch_start_dt >= dateadd(month, -2, sysdate())) a 
where a.rank<=10 
group by source_system  
-- Gives average batch run time 
);


Desc view EDW_DEV.STG.VW_PBI_CURRENT_EXECUTION_LIST;

create or replace view EDW_PROD.STG.VW_PBI_CURRENT_EXECUTION_LIST(
	SOURCE_SYSTEM_NAME,
	BATCH_ID,
	PROCESS_NAME,
	PROCESS_START_DT,
	PROCESS_END_DT,
	PROCESS_STATUS_CODE,
	LWM_DATE,
	HWM_DATE
) as 
(     select epc.source_system_name, epc.Batch_Id, Process_name, process_start_dt, process_end_dt, process_status_code, lwm_date,hwm_date from 
            (select source_System, max(batch_id) as BatchId
               from stg.etl_batch 
--             where batch_end_dt is  null
             group by source_system ) EB, 
              stg.etl_Process_control EPC
              where EB.batchID=EPC.Batch_id
     
-- List of current executions
);


Desc view EDW_DEV.STG.VW_PBI_TOTAL_TASKFLOW_COUNT_SOURCE_SYSTEM;

create or replace view EDW_PROD.STG.VW_PBI_TOTAL_TASKFLOW_COUNT_SOURCE_SYSTEM(
	SOURCE_SYSTEM_NAME,
	TASKFLOW_COUNT
) as 
(
select epc.source_system_name,  count(1) TASKFLOW_COUNT
from stg.etl_Process_control epc
,  (select max(batch_id) batch_id, source_system
               from stg.etl_batch where  batch_end_dt is  not null 
               group by source_system ) eb 
where epc.source_system_name=eb.source_system
and epc.process_status_Code='C'
and epc.batch_id = eb.batch_id
group by epc.source_system_name
-- gives total count  for all the source systems 
);

Desc view EDW_DEV.STG.VW_PBI_COUNT_PERCENTAGE;

create or replace view EDW_PROD.STG.VW_PBI_COUNT_PERCENTAGE(
	SOURCE_SYSTEM_NAME,
	COUNT_PERCENTAGE
) as 
(
with full_count as (select epc.source_system_name,  count(1)  cnt
from stg.etl_Process_control epc
,  (select max(batch_id) batch_id, source_system
               from stg.etl_batch where  batch_end_dt is  not null 
               group by source_system ) eb 
where epc.source_system_name=eb.source_system
and epc.process_status_Code='C'
and epc.batch_id = eb.batch_id
group by epc.source_system_name),
current_count as (select epc.source_system_name,  count(1) cnt
from stg.etl_Process_control epc
,  (select max(batch_id) batch_id, source_system
               from stg.etl_batch where  batch_end_dt is  null 
               group by source_system ) eb 
where epc.source_system_name=eb.source_system
and epc.process_status_Code='C'
and epc.batch_id = eb.batch_id
group by epc.source_system_name)
select full_count.source_system_name, current_count.cnt*100/full_count.cnt AS COUNT_PERCENTAGE
from full_count, current_count 
where full_count.source_system_name = current_Count.source_system_name
 -- count percentage 
);

Desc view EDW_DEV.STG.VW_PBI_TIME_BASED_PERCENTAGE;

create or replace view EDW_PROD.STG.VW_PBI_TIME_BASED_PERCENTAGE(
	SOURCE_SYSTEM,
	TIME_BASED_PERCENTAGE
) as 
(
with avg_run as (select source_system, avg(batch_run_time) avg_run_time
from 
(select source_system, datediff(minute, batch_start_dt, batch_end_dt) batch_run_time,rank() over (partition by source_system order by batch_start_dt desc) rank 
from stg.etl_batch
where batch_end_dt is not null) a 
where a.rank<=10 
group by source_system),
current_run as (select source_system, datediff(minute, batch_start_Dt,  getdate()) current_runtime
from stg.etl_batch 
where batch_end_dt is null) 
select avg_run.source_system, current_run.current_runtime*100/avg_run.avg_run_time AS TIME_BASED_PERCENTAGE
from avg_run, current_run
where avg_run.source_system = current_run.source_system  
-- time based percentage
);
