SET QUOTED_IDENTIFIER ON

declare @lastDate datetime;
--set @lastDate = '2015-01-19'  --ends with the last second before this date

select @lastDate =(SELECT DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()-31)))


--drop table #Temp1
select pd.ID as PDId, MAX(pl.id) as PLId
into #Temp1
from PROCESS_DEFINITION pd
inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
	and pl.PURGE_DT is null
	and pl.CREATE_DT > @lastDate
	and pl.STATUS_CD != 'Reset'
where
pd.PROCESS_TYPE_CD = 'BILLING'
and pd.LAST_RUN_DT > @lastDate
--and pd.ID = 137840
group by pd.ID
order by pd.ID

--select 't1',* from #Temp1

--drop table #Temp2

select pli.PROCESS_LOG_ID as PLId
into #Temp2
from PROCESS_LOG_ITEM pli
inner join #Temp1 t1 on t1.PLId = pli.PROCESS_LOG_ID
where
pli.PURGE_DT is null

--select * from #Temp2

--drop table #Temp3

select pd.ID as PDId, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt, 
settings_xml_im.value ('(//ProcessDefinitionSettings/OriginatorWorkItemId)[1]', 'varchar(50)') as CycleWorkItem,
pd.* 
into #Temp3
from #Temp1 t1
inner join PROCESS_DEFINITION pd on pd.ID = t1.PDId
inner join PROCESS_LOG pl on pl.ID = t1.PLId
where
t1.PLId not in (select PLId from #Temp2)

--select * from #Temp3
--The following step takes those Billing Process Definitions that resulted
-- in no process log items and looks to see if they got realted to another Billing Work Item
--drop table #Temp4
select List.Col as CycleWorkItem
into #Temp4
from work_item_action wia
inner join work_item wi on wi.id = wia.work_item_id
	and wi.relate_type_cd = 'Allied.UniTrac.BillingGroup'
INNER JOIN
    	(
    		SELECT	t3.CycleWorkItem as Col from #Temp3 t3
    	) List ON wia.action_note_tx like '%'+List.Col+'%'

CREATE TABLE #TMP_PDId (
		PD_ID bigint
	)

INSERT INTO #TMP_PDId
select t3.PDId from #Temp3 t3
where
t3.CycleWorkItem not in (select t4.CycleWorkItem from #Temp4 t4)


INSERT INTO #TMP_PDId
select pd.ID as PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt, pli.ID as PLIId, pli.*
from PROCESS_DEFINITION pd
inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
	and pl.CREATE_DT > @lastDate
	and pl.PURGE_DT is null
inner join #Temp1 t1 on t1.PLId = pl.ID
inner join PROCESS_LOG_ITEM pli on pli.PROCESS_LOG_ID = pl.ID
	and pli.PURGE_DT is null
	and pli.STATUS_CD = 'ERR'
	and pli.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'
where
pd.PROCESS_TYPE_CD = 'BILLING'
and pd.LAST_RUN_DT > @lastDate

--drop table #Temp5
select distinct(pd.ID) 
into #Temp5
from BILLING_GROUP bg
inner join PROCESS_LOG_ITEM pli on pli.RELATE_ID = bg.ID
	and pli.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'
	and pli.PURGE_DT is null
inner join PROCESS_LOG pl on pl.ID = pli.PROCESS_LOG_ID
	and pli.PURGE_DT is null
inner join PROCESS_DEFINITION pd on pd.ID = pl.PROCESS_DEFINITION_ID
inner join #Temp1 t1 on t1.PLId = pl.ID
where bg.CREATE_DT > @lastDate and bg.TYPE_CD = 'PEND'

INSERT INTO #TMP_PDId
select pd.ID as PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt
from PROCESS_DEFINITION pd
inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
inner join #Temp5 t5 on t5.ID = pd.ID
where pd.DESCRIPTION_TX = 'Regenerate'

select * from #TMP_PDId

DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS int
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount =
( SELECT count(PD_ID) from #TMP_PDId)

 if @EmailSubjectCount > 0
 Begin

		SELECT 
					(SELECT 
						  CAST(PD_ID AS VARCHAR(20)) + ', ' 
					FROM #TMP_PDId
					FOR xml PATH ('')) AS PDIds
		INTO #tmp



		select @body = 'Process ID(s): ' + (select * from #tmp)
		 
		select @EmailSubject = 'The number of failed bill processes : ' +  CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'richard.wood@ospreysoftware.com;joseph.russell@alliedsolutions.net;wendy.walker@alliedsolutions.net;mike.breitsch@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN
End