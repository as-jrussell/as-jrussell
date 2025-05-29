--EXEC SearchWorkQueue @lenderCode=N'2771',@workFlowId=8,@queueAge=7,@excludeComplete=1,@excludeWithdrawn=1,@lateCyclesOnly=0

SELECT 
 wi.id Work_Item_ID,
wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin],
wd.NAME_TX [Workflow], 	rc.MEANING_TX AS 'Status',
			wi.STATUS_CD as 'StatusColor', wq.NAME_TX [Queue],
	 wia.CREATE_DT [WIA Create Date], 
			 T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender',
			 wiald.CREATE_DT as AssignedtoLenderDate,wiala.CREATE_DT as AssignedtoAdminDate,wia.CREATE_DT as LastActionCompletedDate
	FROM WORK_ITEM AS wi
		left outer join WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
		left outer join WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
		left outer join WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
		left outer join WORK_ITEM_ACTION wiald ON wi.id = wiald.WORK_ITEM_ID and wiald.ACTION_NOTE_TX like '%Reassign To Lender%' and wiald.ACTION_NOTE_TX not like '%Admin%'
		left outer join WORK_ITEM_ACTION wiala ON wi.id = wiala.WORK_ITEM_ID and wiala.ACTION_NOTE_TX like '%Reassign To Lender Admin%'				
		left outer join USERS u ON wi.CURRENT_OWNER_ID = u.ID
		left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'VDWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
		OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1(LenderName)
		OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2(LenderCode)
	 WHERE wi.PURGE_DT is NULL
	 and wd.ID = 8
--AND WI.ID  <> '26783223'	 
	-- AND T2.LenderCode.value('text()[1]', 'VARCHAR(10)') = '2771'
	-- AND DATEDIFF(day, wi.CREATE_DT, GETDATE()) <= 7
	--AND wi.status_cd   NOT IN ( 'Complete',  'Withdrawn', 'PendingReview', 'Error')
	 AND wi.status_cd   IN ('Complete') AND wi.CREATE_DT > '2016-01-01' AND wi.CREATE_DT < '2016-01-31'
	-- AND  rc.MEANING_TX IS NOT NULL  	 AND  rc.MEANING_TX <> 'Error'
	 --AND wiala.CREATE_DT IS NOT NULL AND wia.CREATE_DT IS NOT NULL AND wia.ACTION_NOTE_TX <> ''
	 --AND wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') <> 'NULL'
	-- ORDER BY wi.CREATE_DT DESC
	   ---AND 	rc.MEANING_TX IS NOT NULL


	  