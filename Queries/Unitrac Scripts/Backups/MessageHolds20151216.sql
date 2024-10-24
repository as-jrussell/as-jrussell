------------Hold ITEMS

-------Move to ADHOC

---(5034232, 5030089)

BEGIN TRAN


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'ADHOC'
WHERE   ID IN (5034752,
5034753,
5034755,
5034649,
5034650,
5034529,
5034726,
5034727,
5034261,
5034555,
5034673,
5034674)





(5032825,
5034636,
5034580,
5034516,
5034517,
5033807,
5033808,
5034462,
5034463,
5032346)


 (5032684,
5030426,
5032345,
5033388,
5033389,
5030427,
5033120,
5033121,
5034531,
5031766,
5031877,
5031424,
5030527,
5034515)


--ROLLBACK

--COMMIT

				
-------Placing messages on hold
UPDATE dbo.MESSAGE
SET PROCESSED_IN = 'N' , RECEIVED_STATUS_CD = 'RCVD' , LOCK_ID = LOCK_ID+1--, UPDATE_USER_TX = 'JC'
--SELECT * FROM dbo.MESSAGE
WHERE ID IN (5034232, 5030089, 5034754, 5034580)


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

SELECT * FROM dbo.MESSAGE
WHERE ID IN (5034232,
5030089 ) 



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




