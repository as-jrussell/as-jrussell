

SELECT 
'UnitracUBSTargetQueue' AS QUEUE_NAME, 
t1.QUEUING_ORDER AS QUEUE_ORDER, 
t1.CONVERSATION_GROUP_ID, 
t1.CONVERSATION_HANDLE, 
(SELECT 
CAST(MESSAGE_BODY AS XML).value(N'(/MsgRoot/Id/node())[1]', N'bigint') 
FROM dbo.UBSReadyToExecuteQueue t2 WHERE t2.CONVERSATION_HANDLE = t1.CONVERSATION_HANDLE 
) AS PROCESS_DEFINITION_ID, 

CAST(t1.MESSAGE_BODY AS XML) as MESSAGE_BODY, 
ce.security_timestamp AS MESSAGE_ENQUEUE_TIME 
FROM dbo.UBSReadyToExecuteQueue AS t1 
JOIN sys.conversation_endpoints ce ON t1.conversation_handle = ce.conversation_handle 