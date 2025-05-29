--Last Completed Month of Completed AS Images
USE UniTrac

SELECT DISTINCT
 wi.id Work_Item_ID ,
       CONVERT(DATE,wi.CREATE_DT) AS [WI Create Date],
        wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin] ,
        wd.NAME_TX [Workflow] ,
        rc.MEANING_TX AS 'Status' ,
        wi.STATUS_CD AS 'StatusColor' ,
        wq.NAME_TX [Queue] ,
		'QueueAge' = CEILING(CAST(( GETDATE() - wi.CREATE_DT ) AS FLOAT)) ,
        'ActionAge' = CEILING(CAST(( GETDATE() - wia.CREATE_DT ) AS FLOAT)),
		wia.ACTION_CD [Last Action], wia.ACTION_NOTE_TX [User Level], 
		uu.GIVEN_NAME_TX [First Name],
		 uu.FAMILY_NAME_TX [Last Name],
		CONVERT(DATE,wialc.CREATE_DT) AS [Date  assigned to Lender Admin],
		CONVERT(DATE,wiala.CREATE_DT) AS [WI Completed] ,
						     T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender' ,
        wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') [Lender Code] ,
		wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]', 'varchar (50)') [Next Cycle Date],		
		wi.CONTENT_XML.value('(/Content/Lender/DaysUntilNextCycle)[1]', 'varchar (50)') [Days until Next Cycle]
	--	SELECT DISTINCT wia.ACTION_CD
	INTO jcs..INC0313518
FROM    WORK_ITEM AS wi
        LEFT OUTER JOIN WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
        LEFT OUTER JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wiald ON wi.id = wiald.WORK_ITEM_ID
                                                  AND wiald.ACTION_NOTE_TX LIKE '%User Level%'
                                                  AND wiald.ACTION_NOTE_TX NOT LIKE '%Admin%'
       LEFT OUTER JOIN WORK_ITEM_ACTION wialc ON wi.id = wialc.WORK_ITEM_ID
                                                  AND wialc.ACTION_CD = 'Reassign User Level'
        LEFT OUTER JOIN WORK_ITEM_ACTION wiala ON wi.id = wiala.WORK_ITEM_ID AND wiala.TO_STATUS_CD = 'Complete'
        LEFT OUTER JOIN USERS u ON wi.CURRENT_OWNER_ID = u.ID 
		LEFT OUTER JOIN dbo.USERS uu ON uu.id = wia.ACTION_USER_ID
        LEFT OUTER JOIN REF_CODE rc ON ( rc.DOMAIN_CD = 'VDWorkItemStatus'
                                         AND rc.CODE_CD = wi.STATUS_CD
                                       )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1 ( LenderName )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2 ( LenderCode )
WHERE   wi.PURGE_DT IS NULL
        AND wd.ID = 4 
        --AND wi.status_cd IN ('Complete' )  AND wiald.ACTION_NOTE_TX LIKE '%User Level%' 
		AND wia.CREATE_DT >= '2017-09-01'  AND wiald.ACTION_CD <> 'Reassign User Level'
        AND wia.CREATE_DT <= '2017-10-31' 
		ORDER BY CONVERT(DATE,wi.CREATE_DT) DESC 





