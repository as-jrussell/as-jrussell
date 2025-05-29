USE UniTrac




SELECT  WORK_QUEUE_ID , wq.NAME_TX, 
isnull(sum(case when wq.ACTIVE_IN='Y'
								 then 1 else 0 end),0) [Open],
ISNULL(sum (case when rc.meaning_tx = 'Ok'
							then 1 else 0 end ),0) [OK],
				 isnull(sum(case when rc.meaning_tx = 'Warning' 
							   then 1 else 0 end),0) [Warning],
				 isnull(sum(case when rc.meaning_tx = 'Critical'
								 then 1 else 0 end),0) [Critical],
				isnull(sum (case when rc.meaning_tx = 'InDefault' 					
								  then 1 else 0 end),0) [InDefault],

				 
								 isnull(sum( case when WI.CHECKED_OUT_OWNER_ID IS NOT NULL
										AND wi.CHECKED_OUT_DT IS NOT NULL 
								   then 1 else 0 end),0) [Checked Out]
--SELECT top 5 * 
			FROM 
				WORK_QUEUE_WORK_ITEM_RELATE wqwi 
				inner join WORK_ITEM wi  			on wqwi.WORK_ITEM_ID = wi.ID
				join WORK_QUEUE wq 					on wq.ID = wqwi.WORK_QUEUE_ID
				left join REF_CODE rc  			on wqwi.SLA_LEVEL_NO = rc.CODE_CD and rc.DOMAIN_CD = 'SLALevel' 
				left outer join (select wia.work_item_id, max(wia.create_dt) as max_reassign_dt from WORK_ITEM_ACTION wia where
								 wia.ACTION_CD = 'reassign user level' and wia.PURGE_DT is null group by wia.WORK_ITEM_ID) wiaRA on wiaRA.Work_item_id = wi.id 
			WHERE 
				wqwi.WORK_QUEUE_ID IN (SELECT ID FROM dbo.WORK_QUEUE WHERE WORKFLOW_DEFINITION_ID = '4' AND ACTIVE_IN= 'Y' AND PURGE_DT IS NULL) 
				AND wi.STATUS_CD NOT IN ( 'Complete', 'Withdrawn', 'Error' )
				AND wi.PURGE_DT is NULL
				AND wqwi.PURGE_DT is NULL
				AND wq.purge_dt IS NULL
				AND wqwi.CROSS_QUEUE_COUNT_IND = 'Y'
				AND wq.ACTIVE_IN='Y' 
				GROUP BY WORK_QUEUE_ID , wq.NAME_TX,  rc.meaning_tx