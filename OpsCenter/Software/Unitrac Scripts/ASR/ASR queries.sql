USE UniTrac

SELECT 
id, NAME_TX, process_type_cd, STATUS_CD, LAST_PROCESS_HEARTBEAT_DT, PROC_PRIORITY_NO,
LOAD_BALANCE_IN, DATEDIFF(SECOND,LAST_PROCESS_HEARTBEAT_DT,GETDATE()), CONVERSATION_HANDLE_GUID
FROM dbo.PROCESS_DEFINITION
WHERE LOAD_BALANCE_IN = 'Y' AND STATUS_CD NOT IN ('Complete', 'Expired') --and process_type_cd <> 'GOODTHRUDT'
order by LAST_PROCESS_HEARTBEAT_DT DESC


SELECT count(id), process_type_cd
FROM dbo.PROCESS_DEFINITION
WHERE LOAD_BALANCE_IN = 'Y' AND STATUS_CD NOT IN ('Complete', 'Expired')
Group by process_type_cd 



SELECT count(id), min(UPDATE_DT) process_type_cd
FROM dbo.PROCESS_DEFINITION
WHERE LOAD_BALANCE_IN = 'Y' AND STATUS_CD NOT IN ('Complete', 'Expired')
Group by process_type_cd 



select * from process_definition
where PROCESS_TYPE_CD = 'UTTOVUT'

select * from PROCESS_DEFINITION
where id in ( 899303)



SELECT count(*)
FROM dbo.UBSReadyToExecuteQueue AS t1
	JOIN PROCESS_DEFINITION PD ON CAST(t1.MESSAGE_BODY AS XML).value(N'(/MsgRoot/Id/node())[1]', N'bigint') = PD.ID
	JOIN sys.conversation_endpoints ce ON t1.conversation_handle = ce.conversation_handle
	AND ce.security_timestamp <= DATEADD(MINUTE, -420, GETDATE())
AND PD.PROCESS_TYPE_CD NOT in ('GOODTHRUDT','GTRUNONCE')


SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss.ms],  SERVER_TX [Server], SERVICE_NAME_TX [Service], PD.NAME_TX [Process Defintion], MSG_TX [Message], 
        START_DT [Start] ,
        END_DT [End] ,
        PL.STATUS_CD ,
        LOAD_BALANCE_IN ,
        PROC_TARGET_SERVICE_NAME_TX ,
        PROC_PRIORITY_NO ,
        LAST_PROCESS_HEARTBEAT_DT ,
        CONVERSATION_HANDLE_GUID
FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PD.LOAD_BALANCE_IN = 'Y'  AND PD.ID IN  (
735516,
759701) AND 
CAST(PL.UPDATE_DT AS DATE) >= CAST(GETDATE()-3 AS DATE)
and end_dt is not null
order by pl.update_dt desc


