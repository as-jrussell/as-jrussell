-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac

SELECT U.USER_NAME_TX,  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
L.NAME_TX,
WI.* 
FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE WI.STATUS_CD = 'Approve' 
ORDER BY WI.LENDER_ID DESC 

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,* 
FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'LOANPRCPA'
and ACTIVE_IN = 'Y' and onhold_in = 'N'

SELECT PD.NAME_TX, PL.* FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PL.ID IN (XXXXXXXX)


SELECT TOP 100 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (336)
and update_dt >= '2019-01-01'
--ORDER BY UPDATE_DT DESC 

SELECT * FROM dbo.MESSAGE
WHERE ID IN  (XXXXXXXX) OR RELATE_ID_TX IN  (XXXXXXXX)

select * from trading_partner_log
where message_id in (XXXXXXXX)

select case when message_direction_cd = 'I' then 'Inbound' else 'Outbound' end [Messages], count(*)
 from message 
where received_status_cd = 'INIT' and processed_in = 'N' and purge_dt is null 
group by message_direction_cd


select * from message 
where received_status_cd = 'INIT' and processed_in = 'N' and purge_dt is null 

SELECT  WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]',
                             'varchar (50)') ProcessID ,
        *
FROM    dbo.WORK_ITEM WI
        JOIN dbo.MESSAGE M ON M.RELATE_ID_TX = WI.RELATE_ID
                              AND WI.WORKFLOW_DEFINITION_ID = '1'
WHERE   M.RELATE_ID_TX IN (XXXXXXX)
ORDER BY WI.STATUS_CD ASC 




SELECT l.NAME_TX, l.CODE_TX, WI.* 
FROM  dbo.WORK_ITEM WI
JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE WI.STATUS_CD = 'Approve'  AND WI.WORKFLOW_DEFINITION_ID = '1'
AND wi.CREATE_DT <= DATEADD(HOUR, -6, GETDATE())
ORDER BY CHECKED_OUT_DT DESC 

SELECT ID INTO #tmp FROM dbo.MESSAGE
WHERE RELATE_ID_TX IN (XXXXXXXX)




DROP TABLE #tmp

UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'INIT', SENT_STATUS_CD = 'PEND', PROCESSED_IN = 'N'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (14789627) AND PROCESSED_IN <> 'Y'
and message_direction_cd = 'O'







WI#52482278 - Echo File - Approved at 7:16a
WI#52482362




select * from RELATED_DATA
where relate_id in (3456,
3548,
14385)
order by UPDATE_DT desc
