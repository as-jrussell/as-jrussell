USE UniTrac


--Finding WI via Number
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID = '32772355'


--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '####' 
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
--AND WI.WORKFLOW_DEFINITION_ID = 'X'



--Process Log ID


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '35744580'
AND RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage'


SELECT L.NUMBER_TX, EE.* FROM dbo.EVALUATION_EVENT EE
JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = EE.REQUIRED_COVERAGE_ID
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = RC.PROPERTY_ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
WHERE EE.ID IN (SELECT EVALUATION_EVENT_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '35744580'
AND RELATE_TYPE_CD = 'Allied.UniTrac.Workflow.OutboundCallWorkItem')
AND L.NUMBER_TX IN ('150404015', '141070133', '135889133')


SELECT * FROM dbo.EVENT_SEQUENCE
WHERE ID = '400988'

SELECT * FROM dbo.EVENT_SEQUENCE
WHERE EVENT_SEQ_CONTAINER_ID = '113915'




SELECT L.NUMBER_TX, RC.* FROM dbo.REQUIRED_COVERAGE RC 
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = RC.PROPERTY_ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '35744580'
AND RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage')
AND L.NUMBER_TX IN ('150404015', '141070133', '135889133')


SELECT  L.NUMBER_TX, PLI.PROCESS_LOG_ID, N.* FROM dbo.NOTICE N
JOIN dbo.LOAN L ON L.ID = N.LOAN_ID
JOIN dbo.PROCESS_LOG_ITEM PLI ON PLI.RELATE_ID = N.ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
WHERE L.NUMBER_TX IN ('150404015', '141070133', '135889133')
ORDER BY PROCESS_LOG_ID DESC 