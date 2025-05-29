SELECT DISTINCT wi.id Work_Item_ID,
wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin],
wi.CREATE_DT,  
--U.UPDATE_USER_TX [Owner],
wd.NAME_TX [Workflow], 	rc.MEANING_TX AS 'Status',
			wi.STATUS_CD as 'StatusColor', wq.NAME_TX [Queue],
'QueueAge' = CEILING(CAST((GETDATE() - wi.CREATE_DT) as Float)),
			'ActionAge' = CEILING(CAST((GETDATE() - wia.CREATE_DT) as Float)), wia.ACTION_CD [Last Action Note], 
	 wia.CREATE_DT [Create Date], 
	 L.NAME_TX [Lender], L.CODE_TX [Lender Code], 
wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]', 'varchar (50)') NextCycleDate,
wi.CONTENT_XML.value('(/Content/Loan/Balance)[1]', 'varchar (50)') Balance, 
wia.UPDATE_DT [Update Last Action],
wia.ACTION_NOTE_TX
FROM  
dbo.WORK_ITEM wi   
inner join dbo.WORK_QUEUE_WORK_ITEM_RELATE wqwi on wi.ID = wqwi.WORK_ITEM_ID  
INNER JOIN dbo.WORK_ITEM_ACTION wia ON wi.ID = wia.WORK_ITEM_ID  
INNER JOIN dbo.WORK_QUEUE wq on wq.ID = wqwi.WORK_QUEUE_ID 
INNER JOIN dbo.USER_WORK_QUEUE_RELATE uk ON uk.WORK_QUEUE_ID = wq.ID
INNER JOIN dbo.WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.LENDER L ON wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = L.CODE_TX
left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
INNER JOIN dbo.USERS U ON U.ID = uk.USER_ID 
WHERE  
--CAST(WI.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 wqwi.CROSS_QUEUE_COUNT_IND = 'Y'  
 
--AND wi.STATUS_CD NOT IN ( 'Complete', 'Withdrawn')
--AND wi.UPDATE_DT >= @startdate and wi.Update_dt < @endDate  
--AND wi.content_xml.value('Content[1]/Lender[1]/Id[1]','bigint') = '5600' 
AND WI.PURGE_DT IS NULL  
AND WQWI.PURGE_DT IS NULL  
AND wia.PURGE_DT is NULL  
AND wq.ACTIVE_IN='Y'
AND wi.WORKFLOW_DEFINITION_ID = '8' AND WI.ID  = '27594855' --AND ACTION_CD = 'Reassign User Level'


SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (27594855)

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID  = '27594855' 


SELECT DISTINCT TOP 50 
 wi.id Work_Item_ID,
wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin],
wi.CREATE_DT,  
--U.UPDATE_USER_TX [Owner],
wd.NAME_TX [Workflow], 	rc.MEANING_TX AS 'Status',
			wi.STATUS_CD as 'StatusColor', wq.NAME_TX [Queue],
'QueueAge' = CEILING(CAST((GETDATE() - wi.CREATE_DT) as Float)),
			'ActionAge' = CEILING(CAST((GETDATE() - wia.CREATE_DT) as Float)), wia.ACTION_CD [Last Action Note], 
	 wia.CREATE_DT [Create Date], 
	 L.NAME_TX [Lender], L.CODE_TX [Lender Code], 
wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]', 'varchar (50)') NextCycleDate,
wi.CONTENT_XML.value('(/Content/Loan/Balance)[1]', 'varchar (50)') Balance, 
wia.UPDATE_DT [Update Last Action],
wia.ACTION_NOTE_TX
FROM [UniTrac].[dbo].[WORK_ITEM] wi 
  join WORK_ITEM_ACTION wia on wia.work_item_id = wi.ID 
  join WORK_QUEUE_WORK_ITEM_RELATE wqwir on wqwir.work_item_id = wi.id and wi.CURRENT_QUEUE_ID=wqwir.WORK_QUEUE_ID
  join WORK_QUEUE wq on wqwir.work_queue_id = wq.ID 
  join WORK_QUEUE wq2 on wq2.ID=wia.CURRENT_QUEUE_ID
  INNER JOIN dbo.WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.LENDER L ON wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = L.CODE_TX
left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
where 1=1
  and wi.WORKFLOW_DEFINITION_ID=8
  and wi.STATUS_CD NOT IN ('Complete', 'Withdrawn')
  --and wia.update_dt between '' + cast(@FirstDayLastMonth as varchar(max)) +  '' and '' + cast(@LastDayLastMonth as varchar(max)) + ''  
  and ( replace(replace(wia.ACTION_NOTE_TX, @tab, ''), @nl,'') = 'Reassign To Billing File GroupTo User Level: Billing File Specialist' 
  --or replace(replace(wia.ACTION_NOTE_TX, @tab, ''), @nl,'') = 'Generate Billing File'  ) 