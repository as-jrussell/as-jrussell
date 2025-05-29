USE UniTrac


--Finding WI via Number
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID IN (XXXXXXXX, XXXXXXXX)



--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,  WI.*
--INTO UniTracHDStorage..INC0253281 
FROM  WORK_ITEM WI
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') IN ('1111', 'USDTest1', '0001')
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WI.WORKFLOW_DEFINITION_ID = '4'


-------------- Complete Key Image Work Items
UPDATE  dbo.WORK_ITEM
SET     STATUS_CD = 'Withdrawn' ,
        PURGE_DT = GETDATE() ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0253281'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0253281 )
		  AND WORKFLOW_DEFINITION_ID = 4
