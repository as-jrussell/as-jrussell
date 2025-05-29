use unitrac

select *
from users
where family_name_tx= 'server' and (purge_dt is not null or active_in ='N')

select WORK_ITEM_ID INTO #TMPwi 
from work_item_action wia
where ACTION_USER_ID in (select id from users
where family_name_tx= 'server' and purge_dt is not null)

select  wi.id into #tmpWI
from work_item wi 
inner join lender le on le.id = wi.lender_id
where wi.status_cd  = 'error'
--and wi.workflow_definition_id = 10 
and wi.create_dt > = '2019-08-01'
and wi.content_xml.value('(Content/EvaluationError)[1]','nvarchar(70)') like '%user id%'



update wia set current_owner_id = 3935, ACTION_USER_ID = 3935, UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1
--select * 
from work_item_action wia
join #tmpWI T on T.ID = wia.work_item_id




update wi 
set last_evaluation_dt = GETDATE()-1, status_cd= 'Initial', current_owner_id = 3935
--select *
from work_item wi 
where wi.id = 57010138


select  wi.content_xml.value('(Content/EvaluationError)[1]','nvarchar(max)'),last_evaluation_dt,* 
from work_item wi 
inner join lender le on le.id = wi.lender_id
where wi.id = 57010138




select  wi.content_xml.value('(Content/EvaluationError)[1]','nvarchar(max)'),last_evaluation_dt,* 
from work_item wi 
inner join lender le on le.id = wi.lender_id
where wi.id IN (SELECT * FROM #TMPwi)




update wia set current_owner_id = 3935, ACTION_USER_ID = 3935, UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1
--select * 
from work_item_action wia
where wiA.WORK_ITEM_ID IN (SELECT * FROM #TMPwii) AND ACTION_USER_ID in (select id from users
where family_name_tx= 'server' and purge_dt is not null)



update wi 
set last_evaluation_dt = '2019-08-18 07:00:32.537', status_cd= 'Initial', current_owner_id = 3935
--select *
from work_item wi 
where wi.id IN (SELECT * FROM #TMPwii) AND STATUS_CD = 'Error'




select  le.NAME_TX, le.CODE_TX, wi.content_xml.value('(Content/EvaluationError)[1]','nvarchar(max)'), wi.id
from work_item wi 
inner join lender le on le.id = wi.lender_id
where
CAST(wi.CREATE_DT AS DATE) >= CAST(GETDATE()-20 AS DATE)
and wi.content_xml.value('(Content/EvaluationError)[1]','nvarchar(70)') like '%user id%'
and wi.STATUS_CD = 'INitial'



select * from work_item_action
where work_item_id in (select wi.id
from work_item wi 
inner join lender le on le.id = wi.lender_id
where
CAST(wi.CREATE_DT AS DATE) >= CAST(GETDATE()-20 AS DATE)
and wi.content_xml.value('(Content/EvaluationError)[1]','nvarchar(70)') like '%user id%'
and wi.STATUS_CD = 'INitial'
)

