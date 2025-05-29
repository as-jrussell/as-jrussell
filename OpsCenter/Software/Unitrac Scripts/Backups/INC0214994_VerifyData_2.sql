--EXEC SearchWorkQueue @lenderCode=N'2771',@workFlowId=8,@queueAge=7,@excludeComplete=1,@excludeWithdrawn=1,@lateCyclesOnly=0

SELECT DISTINCT TOP 5
 wi.id Work_Item_ID,
wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin],
wi.CREATE_DT [WI Create Date],  
--U.UPDATE_USER_TX [Owner],
wd.NAME_TX [Workflow], 	rc.MEANING_TX AS 'Status',
			wi.STATUS_CD as 'StatusColor', wq.NAME_TX [Queue],
'QueueAge' = CEILING(CAST((GETDATE() - wi.CREATE_DT) as Float)),
			'ActionAge' = CEILING(CAST((GETDATE() - wia.CREATE_DT) as Float)), wia.ACTION_CD [Last Action Note], 
	 wia.CREATE_DT [WIA Create Date], 
			 T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender',
			 T2.LenderCode.value('text()[1]', 'VARCHAR(10)')  AS 'Loan',
wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]', 'varchar (50)') NextCycleDate,
wi.CONTENT_XML.value('(/Content/Loan/Balance)[1]', 'varchar (50)') Balance, 
wia.UPDATE_DT [Update Last Action],
wia.ACTION_NOTE_TX,wiald.CREATE_DT as AssignedtoLenderDate,wiala.CREATE_DT as AssignedtoAdminDate,wia.CREATE_DT as LastActionCompletedDate
	FROM WORK_ITEM AS wi
		left outer join WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
		left outer join WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
		left outer join WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
		left outer join WORK_ITEM_ACTION wiald ON wi.id = wiald.WORK_ITEM_ID and wiald.ACTION_NOTE_TX like '%Reassign To Lender%' and wiald.ACTION_NOTE_TX not like '%Admin%'
		left outer join WORK_ITEM_ACTION wiala ON wi.id = wiala.WORK_ITEM_ID and wiala.ACTION_NOTE_TX like '%Reassign To Lender Admin%'				
		left outer join USERS u ON wi.CURRENT_OWNER_ID = u.ID
		left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
		OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1(LenderName)
		OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2(LenderCode)
	 WHERE wi.PURGE_DT is NULL
	 and wd.ID = 8
--AND WI.ID  = '27594855'	 
	-- AND T2.LenderCode.value('text()[1]', 'VARCHAR(10)') = '2771'
	 and DATEDIFF(day, wi.CREATE_DT, GETDATE()) <= 7  
	 and wi.status_cd   = 'Complete'--,'Withdrawn') 
	 AND wiala.CREATE_DT IS NOT NULL AND wia.CREATE_DT IS NOT NULL AND wia.ACTION_NOTE_TX <> ''
	 
	   ---AND 	rc.MEANING_TX IS NOT NULL