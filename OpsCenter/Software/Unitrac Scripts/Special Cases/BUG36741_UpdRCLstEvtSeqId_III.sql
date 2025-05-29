--drop table #Temp1
select ee.required_coverage_id as RCId,max(ee.Group_id) as EEGroupId
into #Temp1
from EVALUATION_EVENT ee
where
ee.STATUS_CD = 'COMP' AND
ee.purge_dt is null
group by ee.required_coverage_id


--drop table #Temp2
--Eliminate those that had succesfully generated AGNO
select ee.*, t1.* 
into #Temp2
from UniTrac.dbo.EVALUATION_EVENT ee
inner join #Temp1 t1 on t1.EEGroupId = ee.Group_id
inner join UniTrac.dbo.EVENT_SEQUENCE es on es.ID = ee.EVENT_SEQUENCE_ID
	and ee.TYPE_CD = 'AGNO'
	and ee.STATUS_CD = 'COMP'
	and ee.RELATE_ID is null
	and ee.MSG_LOG_TX is null
	and ee.PURGE_DT is null
	and es.ORDER_NO <> 1
	
--select * from #Temp2

--drop table #Temp3
select ee.REQUIRED_COVERAGE_ID, ee.GROUP_ID,max(es.ORDER_NO) maxordnumber
into #Temp3
from UniTrac.dbo.EVALUATION_EVENT ee
inner join #Temp2 t2 on t2.required_coverage_id = ee.REQUIRED_COVERAGE_ID
	and t2.group_id = ee.GROUP_ID
	and ee.STATUS_CD = 'COMP'
inner join UniTrac.dbo.EVENT_SEQUENCE es on es.ID = ee.EVENT_SEQUENCE_ID
	and es.EVENT_SEQ_CONTAINER_ID not in (98260,98266,62212) --event seq containers that have notice and agno same order same numb of days from last event
inner join UniTrac.dbo.REQUIRED_COVERAGE rc on rc.ID = ee.REQUIRED_COVERAGE_ID
group by ee.REQUIRED_COVERAGE_ID,ee.GROUP_ID

--select * from #Temp3

--drop table #Temp4
select distinct ee.ID as EEId, ee.GROUP_ID , ee.REQUIRED_COVERAGE_ID,ee.TYPE_CD, ee.EVENT_SEQUENCE_ID, es.TIMING_FROM_LAST_EVENT_DAYS_NO,
rc.LAST_EVENT_SEQ_ID, es.ORDER_NO
into #Temp4
from UniTrac.dbo.EVALUATION_EVENT ee
inner join #Temp3 t3 on t3.required_coverage_id = ee.REQUIRED_COVERAGE_ID
	and t3.group_id = ee.GROUP_ID
inner join UniTrac.dbo.EVENT_SEQUENCE es on es.ID = ee.EVENT_SEQUENCE_ID
inner join UniTrac.dbo.REQUIRED_COVERAGE rc on rc.ID = ee.REQUIRED_COVERAGE_ID
	and rc.LAST_EVENT_SEQ_ID <> 0
WHERE
t3.maxordnumber = es.ORDER_NO
and ee.STATUS_CD = 'COMP'

--select * from #Temp4 where required_coverage_id = 39913603

--drop table #Temp5
select ee.REQUIRED_COVERAGE_ID, max(t4.TIMING_FROM_LAST_EVENT_DAYS_NO) AS TIMING_FROM_LAST_EVENT_DAYS_NO
into #Temp5
from #Temp4 t4
inner join UniTrac.dbo.EVALUATION_EVENT ee on ee.id = t4.EEId
--where t4.required_coverage_id = 39913603
GROUP BY ee.REQUIRED_COVERAGE_ID

--drop table #Temp6
select t4.* 
into #Temp6
from #Temp5 t5
inner join #Temp4 t4 on t4.required_coverage_id = t5.required_coverage_id
	and t4.TIMING_FROM_LAST_EVENT_DAYS_NO = t5.TIMING_FROM_LAST_EVENT_DAYS_NO
	and t4.LAST_EVENT_SEQ_ID <> t4.EVENT_SEQUENCE_ID

--select * from #Temp6

update rc 
SET rc.LAST_EVENT_SEQ_ID = t6.EVENT_SEQUENCE_ID,
rc.UPDATE_DT = getdate(),
rc.UPDATE_USER_TX = 'TFS36741',
rc.LOCK_ID = (rc.LOCK_ID % 255) + 1
--select *
from UniTrac.dbo.REQUIRED_COVERAGE rc
inner join #Temp6 t6 on t6.required_coverage_id = rc.id
GO