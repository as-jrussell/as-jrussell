USE UniTrac


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE NAME_TX LIKE '%4286%' AND ACTIVE_IN = 'Y'
AND PROCESS_TYPE_CD = 'CYCLEPRC'


SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (15307)
AND UPDATE_DT >= '2017-12-01 ' AND END_DT IS NOT NULL


SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (53613818)
AND WORKFLOW_DEFINITION_ID = 9

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (42848408)

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID = 646760

UPDATE PL SET purge_dt = GETDATE()
--SELECT * 
FROM dbo.PROCESS_LOG PL
WHERE PROCESS_DEFINITION_ID IN (647021)



SELECT * FROM dbo.WORK_ITEM
WHERE ID = 42860494 

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE RELATE_ID = 1800713

SELECT * FROM dbo.PROCESS_LOG
WHERE ID = 53732392

UPDATE PD SET PD.STATUS_CD = 'Complete', PD.LOCK_ID = PD.LOCK_ID+1, PD.UPDATE_DT = GETDATE()
--SELECT PD.STATUS_CD , * 
FROM dbo.PROCESS_DEFINITION PD
WHERE ID = 647021




SELECT * 
FROM dbo.LOAN L
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0330199_D)





SELECT * 
from OUTPUT_BATCH_LOG
WHERE LOG_TXN_TYPE_CD IN ('ACK','Verify') and 
CREATE_DT >= DateAdd(MINUTE, -25, getdate())


SELECT CONTENT_XML.value('(/Content/VerifyData/Detail/@FieldDisplayName)[1]' , 'varchar(100)'), CONTENT_XML
from work_item
where lender_id = '2238' and workflow_definition_id = '8' and status_cd = 'Initial' 