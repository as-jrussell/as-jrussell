----BSS Check In
SELECT  TP.EXTERNAL_ID_TX ,
        TP.NAME_TX ,
        TP.TYPE_CD ,
        M.ID ,
        M.CREATE_DT ,
        M.UPDATE_DT ,
        M.UPDATE_USER_TX
FROM    message M
        JOIN TRADING_PARTNER TP ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
WHERE   M.PROCESSED_IN = 'N'
        AND M.RECEIVED_STATUS_CD = 'RCVD'
        AND M.MESSAGE_DIRECTION_CD = 'I'
        AND TP.TYPE_CD = 'BSS_TP'
ORDER BY TP.TYPE_CD DESC ,
        M.CREATE_DT ASC 
--5351817


SELECT * FROM dbo.WORK_ITEM
WHERE id = '28836283'

----BSS Check Out
SELECT 
M.SENT_STATUS_CD, M.RECEIVED_STATUS_CD,
     TP.EXTERNAL_ID_TX, 
     TP.NAME_TX, 
     TP.TYPE_CD,
     M.ID, 
     M.CREATE_DT,
	 M.UPDATE_DT,
     M.UPDATE_USER_TX 
FROM message M 
JOIN TRADING_PARTNER TP 
     ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
WHERE M.PROCESSED_IN = 'N' 
AND M.RECEIVED_STATUS_CD = 'RCVD' 
AND M.MESSAGE_DIRECTION_CD = 'O'
AND TP.TYPE_CD = 'BSS_TP' 
ORDER BY TP.TYPE_CD DESC,M.CREATE_DT ASC 
--4789692

SELECT * FROM dbo.MESSAGE
WHERE P
ROCESSED_IN = 'N' AND 
CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
AND UPDATE_USER_TX= 'MsgSrvr'
ORDER BY ID ASC
--4993982

up
SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (4993930)
--(SELECT ID FROM dbo.MESSAGE WHERE PROCESSED_IN = 'N' AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND UPDATE_USER_TX= 'MsgSrvr') 
AND WORKFLOW_DEFINITION_ID = '1'



--UPDATE dbo.MESSAGE
--SET RECEIVED_STATUS_CD = 'HOLD', PROCESSED_IN = 'Y', LOCK_ID = LOCK_ID+1, UPDATE_DT = GETDATE(),
--UPDATE_USER_TX = 'MsgSvrHOLD'
SELECT  *
FROM    message
WHERE   RELATE_ID_TX IN ( 5345727, 5345728, 5345729, 5345730, 5345732,
                5345733, 5345734, 5345735, 5345754, 5345755, 5345756, 5345757,
                5345758, 5345759 )
ORDER BY RELATE_ID_TX ASC


SELECT * FROM UniTracHDStorage..UnitracServices
WHERE Name LIKE	 ('LDH%')

SELECT  *
FROM    message
WHERE   RELATE_ID_TX IN ( 5345725, 5345726)



SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN  (17845356 ) 


SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE ID = '59147452'



----BSS Check In
SELECT  TP.EXTERNAL_ID_TX ,
        TP.NAME_TX ,
        TP.TYPE_CD ,
        M.ID ,
        M.CREATE_DT ,
        M.UPDATE_DT ,
        M.UPDATE_USER_TX
FROM    message M
        JOIN TRADING_PARTNER TP ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
WHERE   M.PROCESSED_IN = 'N'
        AND M.RECEIVED_STATUS_CD = 'RCVD'
        AND M.MESSAGE_DIRECTION_CD = 'I'
        AND TP.TYPE_CD = 'BSS_TP'
ORDER BY TP.TYPE_CD DESC ,
        M.CREATE_DT ASC 
--5351883



UPDATE dbo.MESSAGE
SET RECEIVED_STATUS_CD = 'RCVD', PROCESSED_IN = 'N', LOCK_ID = LOCK_ID+1, UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'MsgSrvr'
--SELECT PROCESSED_IN, RECEIVED_STATUS_CD, UPDATE_DT,  * FROM dbo.MESSAGE
WHERE ID IN (5345727)

SELECT * FROM dbo.DOCUMENT
WHERE MESSAGE_ID = '5345727'

SELECT S.SystemName, M.* FROM dbo.MESSAGE M
INNER JOIN UniTracHDStorage..UnitracServices S ON 
WHERE M.ID IN (5345727)

SELECT * FROM dbo.MESSAGE
WHE

SELECT * FROM UniTracHDStorage..UnitracServices
WHERE Name LIKE	 ('LDH%')

--( 5345725, 
-- 2016-02-22 11:38:28.377 resubmitted
--  processed

--5345726, 
--2016-02-22 11:32:59.790 resubmitted
--  processed

--5345727, 
-- 2016-02-22 11:26:12.643 resubmitted
-- 2016-02-22 11:30:15.147 processed

--5345728, 
-- 2016-02-22 11:25:22.097 resubmitted
-- 2016-02-22 11:22:08.340 processed

--5345729, 
--2016-02-22 11:15:51.930 resubmitted
-- 2016-02-22 11:20:17.370 processed

--5345730, 
-- 2016-02-22 11:08:53.517 resubmitted
-- 2016-02-22 11:10:20.207 processed

--5345732,
-- resubmitted
--  2016-02-22 11:05:16.847 processed

--5345733, 
-- 2016-02-22 10:58:17.630 resubmitted
-- 2016-02-22 11:00:16.197 processed

--5345734, 
--2016-02-22 10:54:58.980 resubmitted
-- 2016-02-22 10:55:16.483 processed

--5345735, 
--2016-02-22 10:46:52.363 resubmitted
-- 2016-02-22 10:50:18.527 processed

--5345754, 
--2016-02-22 10:41:34.070 resubmitted
--2016-02-22 10:45:13.173 processed

--5345755, 
--2016-02-22 10:31:41.543 resubmitted
--2016-02-22 10:37:23.437 processed

--5345756
--2016-02-22 10:27:07.640 resubmitted
--2016-02-22 10:30:17.067 processed
 


UPDATE dbo.MESSAGE
SET RECEIVED_STATUS_CD = 'HOLD', PROCESSED_IN = 'Y', LOCK_ID = LOCK_ID+1, UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'MsgSvrHOLD'
WHERE ID IN (5345725)
