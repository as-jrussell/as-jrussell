------------Hold ITEMS

-------Move to ADHOC

BEGIN TRAN


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'ADHOC'
WHERE   ID IN 


(5026264,
5026812,
5026497,
5026778,
5026779,
5026745,
5026361,
5026362,
5026051,
5026052)



(5020592,
5022625,
5021985,
5021986,
5023793,
5023794,
5022190,
5022191,
5020999,
5021003,
5024065,
5024066,
5023586,
5023587,
5020454,
5020455,
5024945,
5024946,
5024947,
5024948,
5023289,
5023187,
5021532,
5018404,
5018406,
5018832,
5018833,
5018836,
5018838,
5018840,
5018123,
5018306,
5018728,
5018730,
5018636,
5018637,
5022896,
5022897,
5019149,
5020998,
5021002,
5018229,
5018230,
5020456,
5020457,
5019152,
5019153,
5021320,
5018233,
5018234,
5020588,
5020593,
5020781,
5024578,
5024579,
5024342,
5024343)

















(5020782,
5020783,
5019037,
5019039,
5018407,
5018408,
5018938,
5020347,
5020349,
5019251,
5019253,
5018124,
5019247,
5019250,
5022426,
5022427,
5018837,
5021110,
5021217,
5019043,
5019045,
5021621,
5018729,
5018731,
5018732,
5018733,
5018403,
5019478)


(5021215,
5020346,
5020348,
5020894,
5020895,
5021000,
5021004,
5019686,
5020136,
5020352,
5020344,
5020345,
5019912,
5019685,
5020137,
5022313,
5021507,
5022410,
5021216,
5021219)







(5018116,
5019040,
5019041,
5018159,
5018160,
5018161,
5018231,
5018232,
5019800,
5019798,
5019799,
5019249,
5017788,
5019476,
5019036,
5019365,
5019366,
5018405,
5018835,
5018839,
5019684,
5019687)





ROLLBACK

COMMIT



(5019367,
5019472,
5019475,
5019477,
5019479,
5019480,
5019248,
5019252,
5019044,
5019047,
5018727,
5019473,
5019474,
5018303,
5018304,
5019035,
5019038)
				
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



SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (5019475,
5019477,
5019479,
5019480)

AND RELATE_TYPE_CD = 'LDHLib.Message'

--SELECT * FROM dbo.WORK_ITEM_ACTION
--WHERE ID IN (XXXXXXX)



SELECT * FROM dbo.MESSAGE
WHERE ID IN (5019475,
5019477,
5019479,
5019480)

SELECT * FROM dbo.[TRANSACTION]
			WHERE DOCUMENT_ID IN (SELECT MESSAGE_ID,ID FROM dbo.DOCUMENT
			WHERE MESSAGE_ID IN (5019475,
5019477,
5019479,
5019480) AND ID IN (11601743,
11601811,
11601852,
11601894))



 SELECT * FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = 128458369
  


-- 128458325    --	11601743		--5019475	-- W
--128458347		--	11601811		--5019477	-- W
--128458348		--	11601852		--5019479	-- A
--128458369		--	11601894		--5019480	-- A


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



