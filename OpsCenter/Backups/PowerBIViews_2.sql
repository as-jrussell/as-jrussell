
USE ROLE OWNER_EDW_PROD;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_PROD;
USE SCHEMA stg;

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
current_run as (select source_system_name, process_name, datediff(minute, process_start_dt, CONVERT_TIMEZONE('America/Chicago', GETDATE())::timestamp_NTZ) current_run_time 
from stg.etl_Process_control
where process_status_Code='R' and batch_id in (select batch_id from edw_prod.stg.etl_batch where  batch_end_dt is  null )) 
select current_Run.source_system_name, current_Run.process_name
, current_run.current_run_time*100/avg_run.wf_run_time calculated_pct_complete
, avg_run.wf_run_time - current_run.current_run_time expected_time_to_compelte
from current_Run left join avg_run
on avg_run.process_name = current_run.process_name and avg_run.source_system_name = current_run.source_system_name
  -- Calculate percentage complete and expected time to complete for all running taskflow
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
current_run as (select source_system, datediff(minute, batch_start_Dt,  CONVERT_TIMEZONE('America/Chicago', GETDATE())::timestamp_NTZ) current_runtime
from stg.etl_batch 
where batch_end_dt is null)
select avg_run.source_system, current_run.current_runtime*100/avg_run.avg_run_time AS TIME_BASED_PERCENTAGE
from avg_run, current_run
where avg_run.source_system = current_run.source_system  
-- time based percentage
);


Desc view EDW_DEV.STG.VW_PBI_TOTAL_TASKFLOW_COUNT;

create or replace view EDW_PROD.STG.VW_PBI_TOTAL_TASKFLOW_COUNT(
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
             where batch_end_dt is NOT null
             group by source_system ) EB, 
              stg.etl_Process_control EPC
              where EB.batchID=EPC.Batch_id
     
-- List of executions Completed Batch
);