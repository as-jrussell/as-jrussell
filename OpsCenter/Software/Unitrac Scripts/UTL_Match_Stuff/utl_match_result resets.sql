use unitrac

--utl_match_result

select status_cd, * from PROCESS_DEFINITION
where ID = 36

select * from PROCESS_LOG
where  PROCESS_DEFINITION_ID = 36 and update_dt >= '2018-06-07 3:20'
order by update_dt DESC



update umr set APPLY_STATUS_CD = 'PEND', LOCK_ID = LOCK_ID+1
--select APPLY_STATUS_CD, * 
from utl_match_result umr
where id in ( )



select APPLY_STATUS_CD, * 
from utl_match_result umr
where APPLY_STATUS_CD != 'PEND'
and update_dt >= '2019-06-01 3:20'



SELECT MAX(CREATE_DT) [Last UTL Matched]
FROM UTL_MATCH_RESULT 
WHERE UTL_VERSION_NO = 2 AND CREATE_DT > dateadd(dd, -3, getdate()) 

select count(*)as [OldSyncCount - Should be zero],  min(CREATE_DT) [Oldest UTL] 
from UTL_CACHE_CHANGE_QUEUE
where DATEDIFF(minute, CREATE_DT, getutcdate()) > 120
