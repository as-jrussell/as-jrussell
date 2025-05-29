--All Open AS Images
USE UniTrac


SELECT  DISTINCT  wi.id Work_Item_ID ,
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
		CONVERT(DATE,wiale.CREATE_DT) AS [Date  assigned to Lender Admin],
		CONVERT(DATE,wialf.CREATE_DT) AS [Date  assigned to Manager],
		T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender' ,
        wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') [Lender Code] ,
		wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]', 'varchar (50)') [Next Cycle Date],		
		wi.CONTENT_XML.value('(/Content/Lender/DaysUntilNextCycle)[1]', 'varchar (50)') [Days until Next Cycle]
--INTO JCs..INC0214994_AS 
FROM    WORK_ITEM AS wi
        LEFT OUTER JOIN WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
        LEFT OUTER JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wiald ON wi.id = wiald.WORK_ITEM_ID
                                                  AND wiald.ACTION_NOTE_TX LIKE '%Reassign User Level%'
                                                  AND wiald.ACTION_NOTE_TX NOT LIKE '%Admin%'
        LEFT OUTER JOIN WORK_ITEM_ACTION wiala ON wi.id = wiala.WORK_ITEM_ID AND wiala.TO_STATUS_CD = 'Complete'
		     LEFT OUTER JOIN WORK_ITEM_ACTION wiale ON wi.id = wiale.WORK_ITEM_ID
                                                  AND wiale.ACTION_NOTE_TX like '%Lender Admin%'
				     LEFT OUTER JOIN WORK_ITEM_ACTION wialf ON wi.id = wialf.WORK_ITEM_ID
                                                  AND wialf.ACTION_NOTE_TX like '%Manager%'
        LEFT OUTER JOIN USERS u ON wi.CURRENT_OWNER_ID = u.ID 
		LEFT OUTER JOIN dbo.USERS uu ON uu.id = wia.ACTION_USER_ID
        LEFT OUTER JOIN REF_CODE rc ON ( rc.DOMAIN_CD = 'VDWorkItemStatus'
                                         AND rc.CODE_CD = wi.STATUS_CD
                                       )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1 ( LenderName )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2 ( LenderCode )
WHERE   wi.PURGE_DT IS NULL
        AND wd.ID = 4
        AND wi.status_cd IN ( 'Initial', 'PendingReview' )  AND (wiale.CREATE_DT IS NOT NULL OR  wialf.CREATE_DT IS NOT NULL)
				ORDER BY CONVERT(DATE,wi.CREATE_DT) DESC 


