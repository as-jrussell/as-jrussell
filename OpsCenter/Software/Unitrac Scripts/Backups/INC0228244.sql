-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac

SELECT 
        CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender ,
        WD.NAME_TX [Definition] ,
        WQ.NAME_TX [Queue] ,
        WI.*
		--INTO UniTracHDStorage..INC0228244
FROM    WORK_ITEM WI
        INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
        INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE   WI.WORKFLOW_DEFINITION_ID = '4'
        AND WI.CURRENT_QUEUE_ID IN ( 135, 194, 215, 236, 243, 244, 277, 308 )
		AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn') AND WI.PURGE_DT IS NULL
ORDER BY WI.CURRENT_QUEUE_ID ASC 

SELECT * FROM dbo.WORK_QUEUE
WHERE WORKFLOW_DEFINITION_ID = '4'
AND DESCRIPTION_TX LIKE 'Freimark%'



SELECT * FROM UniTracHDStorage..INC0228244


/*
UPDATE  dbo.WORK_ITEM
SET     STATUS_CD = 'Withdrawn' ,
        PURGE_DT = GETDATE() ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0228244'
--SELECT * FROM dbo.WORK_ITEM
WHERE   WORKFLOW_DEFINITION_ID = 4
		  AND ID IN (SELECT ID FROM UniTracHDStorage..INC0228244 )


---3563
*/

