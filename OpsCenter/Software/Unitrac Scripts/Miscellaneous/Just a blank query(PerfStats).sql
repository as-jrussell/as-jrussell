USE PerfStats

---exec perfstats.dbo.perf_check_and_clear_adhoc_plancache



select * from longrunningtransactions
where current_dt >= '2019-02-04' 
and current_dt <= '2019-02-04 08:32:00.840'
and login_name in ('UTdbIISUnitracServerProd', 'UTdbIISLenderService','UTdbPropertyService-API-Prod','UniTracAppUser')
order by current_dt desc



select * from whoisactive
where collection_time >= '2019-02-04' 
and collection_time <= '2019-02-04 08:32:00.840'
and login_name in ('UTdbIISUnitracServerProd', 'UTdbIISLenderService','UTdbPropertyService-API-Prod','UniTracAppUser')
order by collection_time desc



select * from whoisactive
where collection_time >= '2019-02-04' 
and collection_time <= '2019-02-04 08:32:00.840'
and login_name in ('UTdbIISUnitracServerProd', 'UTdbIISLenderService','UTdbPropertyService-API-Prod','UniTracAppUser')
order by collection_time desc


select * from perfstats..whoisactive
where collection_time >= '2019-03-05 00:00' 
and blocking_session_id is not null
order by collection_time desc

sp_Configure "max degree of parallelism"

select * from perfstats..whoisactive
where collection_time >= '2019-03-01 09:00' --and blocking_session_id is not null
order by collection_time desc

select * from longrunningtransactions
where current_dt >= '2019-03-01 00:00' 

order by current_dt desc


select * from perfstats..whoisactive
where collection_time >= '2019-03-05 00:00' 
and session_id in (265,
275)
order by collection_time desc


select login_name, COUNT(*) from whoisactive
where collection_time >= '2019-03-01 09:00' and
 collection_time <= '2019-03-01 10:00'
 group by login_name 
 order by COUNT(*) desc


select login_name, COUNT(*) from whoisactive
where collection_time >= '2019-03-01 13:00' 
 group by login_name 
 order by COUNT(*) desc


 
select *
from perfstats..whoisactive
where collection_time >= '2019-03-01 00:00' 
and login_name = 'sa' 




SELECT [object_name],
[counter_name],
[cntr_value] FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Manager%'
AND [counter_name] = 'Page life expectancy'



SELECT scheduler_id, current_tasks_count, runnable_tasks_count 
FROM sys.dm_os_schedulers 
WHERE scheduler_id < 255

SELECT scheduler_id, current_tasks_count, runnable_tasks_count 
FROM sys.dm_os_schedulers 
WHERE status = 'VISIBLE ONLINE'



select * from  askbrentresults