SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'MSGSRV'


SELECT * FROM UniTrac..MESSAGE
WHERE UPDATE_USER_TX = 'MsgSrvrEXTUSD'


SELECT  TP.EXTERNAL_ID_TX, TP.NAME_TX, TPL.LOG_MESSAGE, TPL.LOG_SEVERITY_CD, TPL.LOG_TYPE_CD, 
TPL.CREATE_DT [TPL.CREATE_DT], M.*  FROM dbo.MESSAGE M
INNER JOIN dbo.TRADING_PARTNER_LOG TPL ON M.ID = TPL.MESSAGE_ID
INNER JOIN dbo.TRADING_PARTNER TP ON TPL.TRADING_PARTNER_ID = TP.ID
WHERE M.ID IN 
(4716290,
4716291,
4716292,
4716293,
4716350,
4716351,
4716352,
4716353,
4716475)
--TP.EXTERNAL_ID_TX = '2771' AND TPL.CREATE_DT > '2015-11-01'
ORDER BY TP.EXTERNAL_ID_TX, M.ID, TPL.CREATE_DT ASC


SELECT * FROM dbo.MESSAGE
WHERE ID IN (4716475, 4716353)

SELECT * FROM dbo.DOCUMENT
WHERE MESSAGE_ID IN (SELECT Id FROM dbo.MESSAGE
WHERE ID IN (4716475, 4293453))


SELECT * FROM dbo.[TRANSACTION] WHERE DOCUMENT_ID IN(
SELECT ID FROM dbo.DOCUMENT
WHERE MESSAGE_ID IN (SELECT Id FROM dbo.MESSAGE
WHERE ID IN (4716475, 4293453)))


SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN 
(4716290,
4716291,
4716292,
4716293,
4716350,
4716351,
4716352,
4716353,
4716475)

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID = '27095943'



UPDATE dbo.MESSAGE
SET RECEIVED_STATUS_CD = 'RCVD', PROCESSED_IN = 'N'
WHERE ID = '4716475'


EXEC sp_who3
