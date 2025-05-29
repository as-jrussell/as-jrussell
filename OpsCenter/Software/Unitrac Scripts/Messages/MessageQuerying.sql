USE unitrac 

--All Messages that are currently inqueue to process
select * from message 
where received_status_cd = 'INIT' and processed_in = 'N' and purge_dt is null 


--All Messages that are currently inqueue to process with the breakdown of Outbount and Inbound
select case when message_direction_cd = 'I' then 'Inbound' else 'Outbound' end [Messages], count(*)
 from message 
where received_status_cd = 'INIT' and processed_in = 'N' and purge_dt is null 
group by message_direction_cd


SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (XXXXXXX)


-------Move to ADHOC for inbound

BEGIN TRAN


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'ADHOC'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (XXXXXXX)


--ROLLBACK

--COMMIT


-------Move to ADHOC for outbound
BEGIN TRAN


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'OBADHOC'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   RELATE_ID_TX IN (XXXXXXX)

--ROLLBACK

--COMMIT
		
		USE UniTrac

		SELECT *
		 FROM dbo.USERS U
		WHERE FAMILY_NAME_TX = 'Server'	
		AND ID = 4473

--Outbound Message
update m
set processed_in= 'Y', RECEIVED_STATUS_CD = 'HOLD'
--select *
from message m 
WHERE  RELATE_ID_TX IN  (XXXXXXX) --Relate_ID from LFP work item
and message_direction_cd = 'O'

--Inbound Message
update m
set processed_in= 'Y', RECEIVED_STATUS_CD = 'HOLD'
--select *
from message m 
WHERE  ID IN  (XXXXXXX) --Relate_ID from LFP work item
and message_direction_cd = 'I'



----Remove message off hold for Outbound messages
UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'INIT', SENT_STATUS_CD = 'PEND', PROCESSED_IN = 'N',   purge_dt = null
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD, SENT_STATUS_CD,* FROM dbo.MESSAGE
WHERE  RELATE_ID_TX IN  (XXXXXXX) --Relate_ID from LFP work item
and message_direction_cd = 'O'

---Remove message off Hold for Inbound Messages
UPDATE dbo.MESSAGE
SET PROCESSED_IN = 'N' , RECEIVED_STATUS_CD = 'RCVD' , LOCK_ID = LOCK_ID+1,  purge_dt = null
--SELECT * FROM dbo.MESSAGE
WHERE  ID IN  (23114989) --Relate_ID from LFP work item
and message_direction_cd = 'I'



--------Taking them off removing messages
--UPDATE dbo.MESSAGE
--SET PROCESSED_IN = 'Y' ,  LOCK_ID = LOCK_ID+1, PURGE_DT = GETDATE()
--WHERE ID IN (XXXXXXX)



------Taking them off hold for ADHOC
--UPDATE dbo.MESSAGE
--SET PROCESSED_IN = 'N' , 
--LOCK_ID = LOCK_ID+1, 
--RECEIVED_STATUS_CD = 'ADHOC' 
--WHERE ID IN (XXXXXXX)

-------------Checking Statuses

--SELECT * FROM dbo.MESSAGE
--WHERE ID IN (XXXXXXX ) 



--SELECT * FROM dbo.WORK_ITEM
--WHERE RELATE_ID IN (XXXXXXX)
--AND RELATE_TYPE_CD = 'LDHLib.Message'

--SELECT * FROM dbo.WORK_ITEM_ACTION
--WHERE ID IN (XXXXXXX)

--SELECT * FROM dbo.WORK_ITEM
--WHERE ID IN (XXXXXXX) 
--AND RELATE_TYPE_CD = 'LDHLib.Message'

--SELECT * FROM dbo.DOCUMENT
--			WHERE MESSAGE_ID IN (XXXXXXX)

--SELECT * FROM dbo.[TRANSACTION]
--			WHERE DOCUMENT_ID IN (XXXXXXX)


------Checking for Errors via Messages
--SELECT * FROM dbo.MESSAGE M
--WHERE   M.RECEIVED_STATUS_CD = 'ERR' AND 
--M.UPDATE_DT >= '2018-01-01 00:00'
--AND M.UPDATE_USER_TX = 'MsgSrvrEXTINFO'
--ORDER BY M.UPDATE_DT DESC


--SELECT * FROM dbo.TRADING_PARTNER_LOG
--WHERE MESSAGE_ID  IN () AND LOG_TYPE_CD =  'ERROR'


-----Checking Errors Messages and WI
--SELECT * FROM dbo.WORK_ITEM  WHERE RELATE_TYPE_CD = 'LDHLib.Message' AND 
-- RELATE_ID IN (XXXXXXX)

-------Checking Message, Lender and Logs a few at a time
--SELECT  TP.EXTERNAL_ID_TX, TP.NAME_TX, TPL.LOG_MESSAGE, TPL.LOG_SEVERITY_CD, TPL.LOG_TYPE_CD, 
--TPL.CREATE_DT [TPL.CREATE_DT], M.*  FROM dbo.MESSAGE M
--INNER JOIN dbo.TRADING_PARTNER_LOG TPL ON M.ID = TPL.MESSAGE_ID
--INNER JOIN dbo.TRADING_PARTNER TP ON TPL.TRADING_PARTNER_ID = TP.ID
--WHERE M.ID IN ( XXXXXXX ) ----TP.EXTERNAL_ID_TX = 'XXXX' AND TPL.CREATE_DT > 'XXXX-XX-XX'
--ORDER BY TP.EXTERNAL_ID_TX, M.ID, TPL.CREATE_DT ASC


---------Checking Message, Lender and Logs with embedded daily error script as subquery
--SELECT  TP.EXTERNAL_ID_TX, TP.NAME_TX, TPL.LOG_MESSAGE, TPL.LOG_SEVERITY_CD, TPL.LOG_TYPE_CD, 
--TPL.CREATE_DT [TPL.CREATE_DT], M.*  FROM dbo.MESSAGE M
--INNER JOIN dbo.TRADING_PARTNER_LOG TPL ON M.ID = TPL.MESSAGE_ID
--INNER JOIN dbo.TRADING_PARTNER TP ON TPL.TRADING_PARTNER_ID = TP.ID
--WHERE M.ID IN (SELECT M.ID FROM dbo.MESSAGE M
--WHERE  CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)) AND M.UPDATE_USER_TX = 'MsgSrvrEXTINFO' AND LOG_SEVERITY_CD = 'high'
----AND tp.EXTERNAL_ID_TX = '2979'
--ORDER BY TPL.CREATE_DT DESC 


--SELECT * FROM VUT..tblExtract_27013525


SELECT   * FROM MESSAGE M
                           WHERE    M.RECEIVED_STATUS_CD = 'ERR'
                  AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)



--------Purge Message
--UPDATE dbo.MESSAGE
--SET LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'JC'
--WHERE ID IN (XXXXXXX)

--UPDATE dbo.[TRANSACTION]
--			SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'JC'
--			WHERE ID IN (XXXXXXX)



