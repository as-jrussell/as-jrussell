use unitrac


SELECT U.USER_NAME_TX,  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
L.NAME_TX,
WI.* 
FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE --WI.STATUS_CD = 'Error' and 
L.Code_tx = '3124' and workflow_definition_id = 1 and wi.update_dt >= '2019-01-08'
ORDER BY WI.LENDER_ID DESC 


select * from trading_partner_log
where message_id = 16331131


--16779485
--2019-01-07 13:11:42.383
--2019-01-07 13:21:42.890

--16779490
--2019-01-07 13:15:41.293
--2019-01-07 13:25:41.533


--16779494
--2019-01-07 13:23:39.720
--2019-01-07 13:33:39.950


select * from trading_partner_log
where trading_partner_id = 3192



SELECT * FROM dbo.MESSAGE
WHERE relate_id_tx IN  (16779485,16779490,16779494)


select max(create_dt) from process_log
where id in (66887389)

--2018-12-01 13:55:16.537


----Reset for Outbound messages
UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'INIT', SENT_STATUS_CD = 'PEND', PROCESSED_IN = 'N'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (16779537,16779533,16779532) 
and PROCESSED_IN = 'N'
