-- Cycle WI 

SELECT DISTINCT
        wi.CONTENT_XML.value('(/Content/Coverage/Type)[1]', 'varchar (50)') [Product] ,
        wi.id Work_Item_ID ,
        wi.CREATE_DT [WI Create Date] ,
        wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin] ,
        wd.NAME_TX [Workflow] ,
        rc.MEANING_TX AS 'Status' ,
        wi.STATUS_CD AS 'StatusColor' ,
        wq.NAME_TX [Queue] ,
        T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender' ,
        wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') [Lender Code] ,
        wia.CREATE_DT AS LastActionCompletedDate ,
        'QueueAge' = CEILING(CAST(( GETDATE() - wi.CREATE_DT ) AS FLOAT)) ,
        'ActionAge' = CEILING(CAST(( GETDATE() - wia.CREATE_DT ) AS FLOAT))
FROM    WORK_ITEM AS wi
        LEFT OUTER JOIN WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
        LEFT OUTER JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
        LEFT OUTER JOIN USERS u ON wi.CURRENT_OWNER_ID = u.ID
        LEFT OUTER JOIN REF_CODE rc ON ( rc.DOMAIN_CD = 'ExtractWorkItemStatus'
                                         AND rc.CODE_CD = wi.STATUS_CD
                                       )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1 ( LenderName )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2 ( LenderCode )
WHERE   wi.PURGE_DT IS NULL
        AND wd.ID = '9' 
        AND wi.status_cd IN ( 'Initial', 'PendingReview' )


