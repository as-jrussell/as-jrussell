USE UniTrac

	SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO



	DECLARE @OpenWI int
	DECLARE @OldestOpenWI date
	DECLARE @OldestOpenWILastReassign date
	DECLARE @WorkedToday int
	DECLARE @OldestWorkedToday date
	DECLARE @OldestWorkedTodayLastReassign date
	DECLARE @WorkedByMe int
	DECLARE @OldestWorkedByMe date
	DECLARE @OldestWorkedByMeLastReassign date
	DECLARE @OK int
	DECLARE @OldestOK date
	DECLARE @OldestOKLastReassign date
	DECLARE @Warning int
	DECLARE @OldestWarning date
	DECLARE @OldestWarningLastReassign date
	DECLARE @Critical int
	DECLARE @OldestCritical date
	DECLARE @OldestCriticalLastReassign date
	DECLARE @InDefault int
	DECLARE @OldestInDefault date
	DECLARE @OldestInDefaultLastReassign date
	DECLARE @Reserved int
	DECLARE @CheckedOut int
	--declare @sql nvarchar(max)
	--declare @startdate date
	--declare @enddate date
	--declare @cacheKey nvarchar(100)
	--declare @cacheWorkedByUserKey nvarchar(100)
	--declare @cacheWorkedTodayKey nvarchar(100)
	--declare @cacheExpire datetime
	--declare @cacheWorkedByUserExpire datetime
	--declare @cacheWorkedTodayExpire datetime


SELECT  
				@OK = isnull(sum (case when rc.meaning_tx = 'Ok'
							then 1 else 0 end ),0),
				@OldestOK = min(case when rc.meaning_tx = 'Ok' then wi.CREATE_DT else null end),
				@OldestOKLastReassign = isnull(min(case when rc.meaning_tx = 'Ok' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = 'Ok' then wi.CREATE_DT else null end)),

				@Warning = isnull(sum(case when rc.meaning_tx = 'Warning' 
							   then 1 else 0 end),0),
				@OldestWarning = min(case when rc.meaning_tx = 'Warning' then wi.CREATE_DT else null end), 
				@OldestWarningLastReassign = isnull(min(case when rc.meaning_tx = 'Warning' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = 'Warning' then wi.CREATE_DT else null end)),
			
				@Critical = isnull(sum(case when rc.meaning_tx = 'Critical'
								 then 1 else 0 end),0),
				@OldestCritical = min(case when rc.meaning_tx = 'Critical' then wi.CREATE_DT else null end),
				@OldestCriticalLastReassign = isnull(min(case when rc.meaning_tx = 'Critical' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = 'Critical' then wi.CREATE_DT else null end)),
			
				@InDefault = isnull(sum (case when rc.meaning_tx = 'InDefault' 					
								  then 1 else 0 end),0),
				@OldestInDefault = min(case when rc.meaning_tx = 'InDefault' then wi.CREATE_DT else null end),
				@OldestInDefaultLastReassign = isnull(min(case when rc.meaning_tx = 'InDefault' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = 'InDefault' then wi.CREATE_DT else null end)),
			
				@Reserved = isnull(sum (case when wi.RESERVED_DT IS NOT NULL
								 then 1 else 0 end),0),

				@CheckedOut = isnull(sum( case when WI.CHECKED_OUT_OWNER_ID IS NOT NULL
										AND wi.CHECKED_OUT_DT IS NOT NULL 
								   then 1 else 0 end),0),

				@OpenWI = isnull(sum(case when wq.ACTIVE_IN='Y'
								 then 1 else 0 end),0),
				@OldestOpenWI = min(case when wq.ACTIVE_IN='Y' then wi.CREATE_DT else null end),
				@OldestOpenWILastReassign = isnull(min(case when wq.ACTIVE_IN='Y' then wiara.max_reassign_dt else null end), min(case when wq.ACTIVE_IN='Y' then wi.CREATE_DT else null end))
--SELECT top 5 * 
			FROM 
				WORK_QUEUE_WORK_ITEM_RELATE wqwi 
				inner join WORK_ITEM wi  			on wqwi.WORK_ITEM_ID = wi.ID
				join WORK_QUEUE wq 					on wq.ID = wqwi.WORK_QUEUE_ID
				left join REF_CODE rc  			on wqwi.SLA_LEVEL_NO = rc.CODE_CD and rc.DOMAIN_CD = 'SLALevel' 
				left outer join (select wia.work_item_id, max(wia.create_dt) as max_reassign_dt from WORK_ITEM_ACTION wia where
								 wia.ACTION_CD = 'reassign user level' and wia.PURGE_DT is null group by wia.WORK_ITEM_ID) wiaRA on wiaRA.Work_item_id = wi.id 
			--'
		 --   + case when @userRoles is not null then ' inner join #USER_LEVELS ur on ur.USER_ROLE_CD = wi.USER_ROLE_CD' else '' end
			--+ '
			WHERE 
				wqwi.WORK_QUEUE_ID IN (SELECT ID FROM dbo.WORK_QUEUE WHERE WORKFLOW_DEFINITION_ID = '4' AND ACTIVE_IN= 'Y' AND PURGE_DT IS NULL) 
				AND wi.STATUS_CD NOT IN ( 'Complete', 'Withdrawn', 'Error' )
				AND wi.PURGE_DT is NULL
				AND wqwi.PURGE_DT is NULL
				AND wq.purge_dt IS NULL
				AND wqwi.CROSS_QUEUE_COUNT_IND = 'Y'
				AND wq.ACTIVE_IN='Y' 