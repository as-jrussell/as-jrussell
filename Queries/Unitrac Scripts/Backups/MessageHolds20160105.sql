------------Hold ITEMS

-------Move to ADHOC

BEGIN TRAN


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'ADHOC'
WHERE   ID IN (5099654,
5118117,
5118118,
5118119,
5118214,
5118215,
5118210,
5118213,
5119403,
5118203,
5118204,
5118206,
5118208,
5118205,
5118211,
5118212,
5117918,
5117919,
5118021,
5118022,
5119199,
5118327,
5118328,
5117266,
5117628,
5117629,
5118201,
5117725,
5117726)


--ROLLBACK

--COMMIT

				
-------Placing messages on hold
--UPDATE dbo.MESSAGE
--SET PROCESSED_IN = 'Y' , RECEIVED_STATUS_CD = 'HOLD' , LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'JC'
--WHERE ID IN (XXXXXXX)


----------Taking them off hold for USD
--UPDATE dbo.MESSAGE
--SET PROCESSED_IN = 'N' , RECEIVED_STATUS_CD = 'RCVD' , LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'JC'
--WHERE ID IN (XXXXXXX)



------Taking them off hold for ADHOC
--UPDATE dbo.MESSAGE
--SET PROCESSED_IN = 'N' , 
--LOCK_ID = LOCK_ID+1, 
--RECEIVED_STATUS_CD = 'ADHOC' 
--WHERE ID IN (XXXXXXX)

-------------Checking Statuses

SELECT * FROM dbo.MESSAGE M
WHERE M.UPDATE_USER_TX like 'JC%'

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


----Checking for Errors via Messages
SELECT * FROM dbo.MESSAGE M
WHERE   M.RECEIVED_STATUS_CD = 'ERR'
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY M.UPDATE_DT DESC


---Checking Errors Messages and WI
--SELECT * FROM dbo.WORK_ITEM  WHERE RELATE_TYPE_CD = 'LDHLib.Message' AND 
-- RELATE_ID IN (XXXXXXX) AND STATUS_CD  NOT LIKE 'Withdrawn'


-------Checking Message, Lender and Logs a few at a time
--SELECT  TP.EXTERNAL_ID_TX, TP.NAME_TX, TPL.LOG_MESSAGE, TPL.LOG_SEVERITY_CD, TPL.LOG_TYPE_CD, 
--TPL.CREATE_DT [TPL.CREATE_DT], M.*  FROM dbo.MESSAGE M
--INNER JOIN dbo.TRADING_PARTNER_LOG TPL ON M.ID = TPL.MESSAGE_ID
--INNER JOIN dbo.TRADING_PARTNER TP ON TPL.TRADING_PARTNER_ID = TP.ID
--WHERE M.ID IN ( XXXXXXX ) ----TP.EXTERNAL_ID_TX = 'XXXX' AND TPL.CREATE_DT > 'XXXX-XX-XX'
--ORDER BY TP.EXTERNAL_ID_TX, M.ID, TPL.CREATE_DT ASC


-------Checking Message, Lender and Logs with embedded daily error script as subquery
SELECT  TP.EXTERNAL_ID_TX, TP.NAME_TX, TPL.LOG_MESSAGE, TPL.LOG_SEVERITY_CD, TPL.LOG_TYPE_CD, 
TPL.CREATE_DT [TPL.CREATE_DT], M.*  FROM dbo.MESSAGE M
INNER JOIN dbo.TRADING_PARTNER_LOG TPL ON M.ID = TPL.MESSAGE_ID
INNER JOIN dbo.TRADING_PARTNER TP ON TPL.TRADING_PARTNER_ID = TP.ID
WHERE M.ID IN (SELECT M.ID FROM dbo.MESSAGE M
WHERE   M.RECEIVED_STATUS_CD = 'ERR'
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)) AND LOG_SEVERITY_CD = 'high'
ORDER BY TP.EXTERNAL_ID_TX, M.ID, TPL.CREATE_DT ASC


--SELECT * FROM VUT..tblExtract_27013525



--------Purge Message
--UPDATE dbo.MESSAGE
--SET LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'JC'
--WHERE ID IN (XXXXXXX)

--UPDATE dbo.[TRANSACTION]
--			SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'JC'
--			WHERE ID IN (XXXXXXX)



