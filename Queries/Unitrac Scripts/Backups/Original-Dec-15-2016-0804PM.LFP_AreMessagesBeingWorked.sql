USE UniTrac

SELECT M.PROCESSED_IN, MESSAGE_ID, TPL.UPDATE_USER_TX, TP.EXTERNAL_ID_TX, TPl.* , Tp.*
FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID
JOIN dbo.MESSAGE M ON M.ID = TPL.MESSAGE_ID
WHERE  
CAST(TPL.CREATE_DT AS date) = CAST(GETDATE()  AS date) 
AND TPL.PROCESS_CD = 'MS'
AND M.PROCESSED_IN <> 'Y' AND TP.EXTERNAL_ID_TX NOT IN ('1771', '2771', '5350', '3400', '1574', '4824', '4204', 'BSSWeb')
AND TPL.UPDATE_USER_TX <> 'MsgSrvrEDIIDR'
ORDER BY m.ID,TPL.CREATE_DT ASC 

SELECT M.PROCESSED_IN, MESSAGE_ID, TPL.UPDATE_USER_TX, TP.EXTERNAL_ID_TX, TPl.* , Tp.*
FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID
JOIN dbo.MESSAGE M ON M.ID = TPL.MESSAGE_ID
WHERE EXTERNAL_ID_TX = 'XXXX' AND M.PROCESSED_IN = 'Y'
ORDER BY TPL.CREATE_DT ASC 

SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (seLECT ID FROM dbo.MESSAGE WHERE ID = 'XXXXXXX') AND WORKFLOW_DEFINITION_ID = '1'



SELECT TOP 10 PD.NAME_TX, PROCESS_TYPE_CD, PL.* FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PD.ID IN (13555, 7920, 199525)
ORDER BY PL.UPDATE_DT DESC

