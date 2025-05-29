-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac


----Work Items are in Approve Status (Outbound Messages for LFP)
SELECT U.USER_NAME_TX,  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[4]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[5]', 'varchar (50)') ProcessID,
L.NAME_TX,
WI.* 
FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE WI.WORKFLOW_DEFINITION_ID =1  AND WI.STATUS_CD = 'Approve'
AND WI.PURGE_DT IS NULL
ORDER BY WI.LENDER_ID DESC 


SELECT * FROM dbo.LENDER
WHERE CODE_TX = '5350'


--Logix Federal Credit Union

SELECT U.USER_NAME_TX,  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[4]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[5]', 'varchar (50)') ProcessID,
L.NAME_TX,
WI.* 
FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE WORKFLOW_DEFINITION_ID =1 and WI.ID  IN  (XXXXXXX)
ORDER BY WI.LENDER_ID DESC 


--Researching LFP per process log id that is in the XML of the work item under ProcessLogs
SELECT PD.NAME_TX, PL.* FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PL.ID IN (89960877,
89807121)
 order by update_dt desc

 SELECT *
 FROM dbo.PROCESS_LOG
 WHERE CREATE_DT >= DATEADD(DAY, -7, GETDATE())
 AND PROCESS_DEFINITION_ID IN (1229683,
696740) AND SERVER_TX IS NOT NULL



--Researching message inbound and outbound for errors
SELECT M.MESSAGE_DIRECTION_CD, M.PROCESSED_IN, M.RECEIVED_STATUS_CD, *
FROM dbo.MESSAGE M
WHERE ID IN (SELECT WI.RELATE_ID FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE WI.WORKFLOW_DEFINITION_ID =1  AND WI.STATUS_CD = 'Approve'
AND wi.LENDER_ID = 2409) 

OR RELATE_ID_TX IN (SELECT WI.RELATE_ID FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE WI.WORKFLOW_DEFINITION_ID =1  AND WI.STATUS_CD = 'Approve'
AND WI.LENDER_ID = 2409)



and MESSAGE_DIRECTION_CD = 'O'

--Researching message inbound explaining what the error are you can only search inbound messages only
select * from trading_partner_log
where message_id in (29521781)




--Finding LFP work item from Message
SELECT  WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]',
                             'varchar (50)') ProcessID ,
    WI.ID, M.*
FROM    dbo.WORK_ITEM WI
        JOIN dbo.MESSAGE M ON M.RELATE_ID_TX = WI.RELATE_ID
                              AND WI.WORKFLOW_DEFINITION_ID = '1'
WHERE   M.RELATE_ID_TX IN (XXXXXXX) OR M.ID IN  (XXXXXXX)
ORDER BY WI.STATUS_CD ASC 


--Finding LFP work item from Message
SELECT  WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]',
                             'varchar (50)') ProcessID ,
    WI.ID, M.SENT_STATUS_CD [Outbound Sent Status],M.RECEIVED_STATUS_CD [Outbound Received Status], MM.SENT_STATUS_CD [Inbound Sent Status],MM.RECEIVED_STATUS_CD [Inbound Received Status], WI.*
FROM    dbo.WORK_ITEM WI
        JOIN dbo.MESSAGE M ON M.RELATE_ID_TX = WI.RELATE_ID
                              AND WI.WORKFLOW_DEFINITION_ID = '1'
							          JOIN dbo.MESSAGE MM ON MM.ID = WI.RELATE_ID
                              AND WI.WORKFLOW_DEFINITION_ID = '1'
WHERE  WI.ID IN  (XXXXXXX)  

ORDER BY WI.STATUS_CD ASC 


--Message that has been sitting for longer than six hours
SELECT l.NAME_TX, l.CODE_TX, WI.* 
FROM  dbo.WORK_ITEM WI
JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE WI.STATUS_CD  IN ('Approve','Initial') AND WI.WORKFLOW_DEFINITION_ID = '1'
AND wi.CREATE_DT <= DATEADD(HOUR, -4, GETDATE())
ORDER BY CHECKED_OUT_DT DESC 


--All the LFP process to ensure they are not in error
SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,* 
FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'LOANPRCPA'
and ACTIVE_IN = 'Y' and onhold_in = 'N'


--Shows last 100 transactions of each of the LFP posting 
SELECT TOP 100 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (696740)
and CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
ORDER BY UPDATE_DT DESC 

SELECT TOP 100 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (336)
and CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE) 
ORDER BY UPDATE_DT DESC 


SELECT TOP 100 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (75189)
and CAST(UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
ORDER BY UPDATE_DT DESC 

SELECT TOP 100 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (19880)
and CAST(UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE) 
ORDER BY UPDATE_DT DESC 

SELECT TOP 100 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (58339)
and CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-3 AS DATE) 
ORDER BY UPDATE_DT DESC 



/*

Moving Messages from normal processing to ADHOC

SELECT ID INTO #tmp 
select *
FROM dbo.MESSAGE
WHERE RELATE_ID_TX IN (19767818)



DROP TABLE #tmp

UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'INIT', SENT_STATUS_CD = 'PEND', PROCESSED_IN = 'N'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (XXXXXXX)
and message_direction_cd = 'O'


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'INIT', SENT_STATUS_CD = 'HOLD', PROCESSED_IN = 'Y'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (XXXXXXX) 
and message_direction_cd = 'O'


SELECT U.USER_NAME_TX,  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
L.NAME_TX,
WI.* 
FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE WORKFLOW_DEFINITION_ID =1 
and RELATE_ID IN (XXXXXXX)
ORDER BY WI.LENDER_ID DESC 


*/


