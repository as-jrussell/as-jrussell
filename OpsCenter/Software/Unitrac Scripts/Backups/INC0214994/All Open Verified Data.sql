--All Open Verified Data

SELECT DISTINCT
        wi.id Work_Item_ID ,
        wi.CREATE_DT [WI Create Date] ,
        wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin] ,
        wd.NAME_TX [Workflow] ,
        rc.MEANING_TX AS 'Status' ,
        wi.STATUS_CD AS 'StatusColor' ,
        wq.NAME_TX [Queue] ,
        T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender' ,
        wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') [Lender Code] ,
        wiald.CREATE_DT AS AssignedtoLenderDate ,
        wiala.CREATE_DT AS AssignedtoAdminDate ,
        wia.CREATE_DT AS LastActionCompletedDate
FROM    WORK_ITEM AS wi
        LEFT OUTER JOIN WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
        LEFT OUTER JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wiald ON wi.id = wiald.WORK_ITEM_ID
                                                  AND wiald.ACTION_NOTE_TX LIKE '%Reassign To Lender%'
                                                  AND wiald.ACTION_NOTE_TX NOT LIKE '%Admin%'
        LEFT OUTER JOIN WORK_ITEM_ACTION wiala ON wi.id = wiala.WORK_ITEM_ID
                                                  AND wiala.ACTION_NOTE_TX LIKE '%Reassign To Lender Admin%'
        LEFT OUTER JOIN USERS u ON wi.CURRENT_OWNER_ID = u.ID
        LEFT OUTER JOIN REF_CODE rc ON ( rc.DOMAIN_CD = 'VDWorkItemStatus'
                                         AND rc.CODE_CD = wi.STATUS_CD
                                       )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1 ( LenderName )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2 ( LenderCode )
WHERE   wi.PURGE_DT IS NULL
        AND wd.ID = 8
        AND wi.status_cd IN ( 'Initial', 'PendingReview' )

	  