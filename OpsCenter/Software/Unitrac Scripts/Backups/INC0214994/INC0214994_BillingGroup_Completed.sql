USE UniTrac

--Last Completed Month of Completed Billing Group

SELECT DISTINCT wi.id Work_Item_ID ,
        wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin] ,
        wd.NAME_TX [Workflow] ,
        rc.MEANING_TX AS 'Status' ,
        wi.STATUS_CD AS 'StatusColor' ,
        wq.NAME_TX [Queue] ,
        T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender' ,
        wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'nvarchar (50)') [Lender Code] ,
        CONVERT(DATE,wi.CREATE_DT) [WI Create Date] ,
        CONVERT(DATE,wiala.CREATE_DT) AS [Reassign To Billing File Group] ,
        CONVERT(DATE,wialb.CREATE_DT) AS [Create Refund WorkItem] ,
        CONVERT(DATE,wialc.CREATE_DT) AS [Generate Billing File],
		CONVERT(DATE,wiald.CREATE_DT) AS [Reassign to Lender],
		CONVERT(DATE,wiale.CREATE_DT) AS [Reassign to Lender Admin],
		CONVERT(DATE,wialg.CREATE_DT) AS [Reassign to CPI Accounting],
		CONVERT(DATE,wialh.CREATE_DT) AS [WI Completed] 
	FROM    WORK_ITEM AS wi
        LEFT OUTER JOIN WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
        LEFT OUTER JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
        LEFT OUTER JOIN WORK_ITEM_ACTION wiala ON wi.id = wiala.WORK_ITEM_ID
                                                  AND wiala.ACTION_NOTE_TX LIKE '%Reassign To Billing File Group%'
        LEFT OUTER JOIN WORK_ITEM_ACTION wialb ON wi.id = wialb.WORK_ITEM_ID
                                                  AND wialb.ACTION_NOTE_TX LIKE '%Create Refund WorkItem%'
        LEFT OUTER JOIN WORK_ITEM_ACTION wialc ON wi.id = wialc.WORK_ITEM_ID
                                                  AND wialc.ACTION_NOTE_TX LIKE '%Generate Billing File%'
		LEFT OUTER JOIN WORK_ITEM_ACTION wiald ON wi.id = wiald.WORK_ITEM_ID
                                                  AND wia.ACTION_NOTE_TX LIKE '%Reassign To Lender%'
		LEFT OUTER JOIN WORK_ITEM_ACTION wiale ON wi.id = wiale.WORK_ITEM_ID
                                                  AND wiale.ACTION_NOTE_TX LIKE  '%Reassign To Lender Admin%'
		LEFT OUTER JOIN WORK_ITEM_ACTION wialf ON wi.id = wialf.WORK_ITEM_ID
                                                  AND wialf.ACTION_NOTE_TX LIKE  'create refund%'
  		LEFT OUTER JOIN WORK_ITEM_ACTION wialg ON wi.id = wialg.WORK_ITEM_ID
                                                  AND wialg.ACTION_NOTE_TX LIKE  '%ReassignCPI Accounting%'
		LEFT OUTER JOIN WORK_ITEM_ACTION wialh ON wi.id = wialh.WORK_ITEM_ID AND wialh.TO_STATUS_CD = 'Complete'
 LEFT OUTER JOIN USERS u ON wi.CURRENT_OWNER_ID = u.ID
        LEFT OUTER JOIN REF_CODE rc ON ( rc.DOMAIN_CD = 'VDWorkItemStatus'
                                         AND rc.CODE_CD = wi.STATUS_CD
                                       )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1 ( LenderName )
        OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2 ( LenderCode )
WHERE   wi.PURGE_DT IS NULL AND wd.ID = 10 
        AND wi.status_cd IN ( 'Complete' )
        AND wia.CREATE_DT >= '2016-08-01'
        AND wia.CREATE_DT <= '2016-08-31'