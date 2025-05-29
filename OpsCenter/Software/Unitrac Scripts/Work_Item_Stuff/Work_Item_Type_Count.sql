---------- By Work Item Type 
SELECT TOP 1000
        LAST_EVALUATION_DT ,
        *
FROM    WORK_ITEM
WHERE   CONTENT_XML.exist('//Content/VerifyData') = 1
        AND create_dt >= '02/19/2014'
ORDER BY update_dt DESC 

---------- Initial Counts Total
SELECT  wd.NAME_TX ,
        COUNT(*)
FROM    WORK_ITEM wi
        JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.id
WHERE   wi.STATUS_CD NOT IN ( 'Error', 'Complete', 'Withdrawn' )
--AND wi.LAST_EVALUATION_DT IS NULL
        AND wi.PURGE_DT IS NULL
GROUP BY wd.NAME_TX

-------------- The Whole Initial Enchilada
SELECT  wd.NAME_TX ,
        wi.WORKFLOW_DEFINITION_ID ,
        COUNT(wi.id) AS WORKITEM_COUNT ,
        GETDATE() - MIN(WI.CREATE_DT) AS ELAPSED ,
        DATEDIFF(second, 0, GETDATE() - MIN(WI.CREATE_DT)) AS elapsed_seconds ,
        MIN(wi.CREATE_DT) AS MIN_CREATE_DT ,
        MAX(WI.CREATE_DT) AS MAX_CREATE_DT
FROM    WORK_ITEM wi
        INNER JOIN WORKFLOW_DEFINITION WD ON WD.ID = wi.WORKFLOW_DEFINITION_ID
        LEFT OUTER JOIN WORK_QUEUE_WORK_ITEM_RELATE wiwqr ON wiwqr.work_item_id = wi.id
        LEFT OUTER JOIN UTL_MATCH_RESULT umr ON umr.ID = wi.RELATE_ID
WHERE   wi.STATUS_CD NOT IN ( 'Complete', 'Error', 'Withdrawn' )
	--and WD.WORKFLOW_TYPE_CD = 'UTLMatch'
	--and wiwqr.id is null
        AND wi.PURGE_DT IS NULL
        AND umr.PURGE_DT IS NULL
GROUP BY wd.name_tx ,
        wi.WORKFLOW_DEFINITION_ID







SELECT * FROM dbo.WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID = '8' AND STATUS_CD <> 'Complete' AND STATUS_CD <> 'Withdrawn'
AND PURGE_DT IS NOT NULL



SELECT  *
FROM    WORK_ITEM wi
        JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.id
WHERE   wi.STATUS_CD NOT IN ( 'Error', 'Complete', 'Withdrawn' )
--AND wi.LAST_EVALUATION_DT IS NULL
        AND wi.PURGE_DT IS NULL AND WORKFLOW_DEFINITION_ID = '8'

		SELECT * FROM dbo.WORK_ITEM_ACTION
		WHERE WORK_ITEM_ID IN (SELECT  wi.ID
FROM    WORK_ITEM wi
        JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.id
WHERE   wi.STATUS_CD NOT IN ( 'Error', 'Complete', 'Withdrawn' )
--AND wi.LAST_EVALUATION_DT IS NULL
        AND wi.PURGE_DT IS NULL AND WORKFLOW_DEFINITION_ID = '8')
