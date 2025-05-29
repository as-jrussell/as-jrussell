USE [UniTrac]
GO 

DECLARE @retVal int

SELECT @retVal = COUNT(*)
from OUTPUT_BATCH_LOG
WHERE LOG_TXN_TYPE_CD IN ('ACK','Verify') and  
CREATE_DT >= DateAdd(MINUTE, -15, getdate())

IF (@retVal > 0)
BEGIN
SELECT 'Yes' [Are batches processing in last 15 minutes?]
END
ELSE
BEGIN
SELECT 'No' [Are batches processing in last 15 minutes?]
END 

DECLARE @retVala int

SELECT @retVala = COUNT(*)
	FROM TRADING_PARTNER_LOG 

WHERE LOG_MESSAGE LIKE '%There is not enough space on the disk.%' AND 
CREATE_DT >= DateAdd(MINUTE, -15, getdate())

IF (@retVala > 0)
BEGIN
SELECT 'Yes' [Errors in Trading Partner Logs]
END
ELSE
BEGIN
SELECT 'No' [Errors in Trading Partner Logs]
END 
 use unitrac
	SELECT MIN(rh.create_dt) [Oldest report],COUNT(*) [Counts], rh.STATUS_CD [Status]
	--select *
	FROM REPORT_HISTORY  rh
	LEFT JOIN dbo.DOCUMENT_CONTAINER dc ON dc.id = rh.DOCUMENT_CONTAINER_ID
	WHERE CAST(rh.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)  AND rh.GENERATION_SOURCE_CD = 'u'-- and RH.Status_cd = 'Err'
	GROUP BY	STATUS_CD


	SELECT MAX(rh.UPDATE_DT) [Last Report Done by UBSRPT]
	FROM REPORT_HISTORY  rh
	WHERE   STATUS_CD = 'COMP'
	AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
			AND rh.UPDATE_USER_TX = 'UBSRPT'

SELECT MAX(CREATE_DT) [Last UTL Matched]
FROM UTL_MATCH_RESULT 
WHERE UTL_VERSION_NO = 2 AND CREATE_DT > dateadd(dd, -3, getdate()) 

select count(*)as [OldSyncCount - Should be zero],  min(CREATE_DT) [Oldest UTL] 
from UTL_CACHE_CHANGE_QUEUE
--3089976
--27496420k h


select count(*) [Cert Count]
 from force_placed_certificate
 where   CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
 and pdf_generate_cd = 'PEND'

select count(*) [Notice Count]
from notice
where   CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
and pdf_generate_cd = 'PEND'

---- Inbound (Message Server)
 



SELECT  COUNT(*) [Count] , M.RECEIVED_STATUS_CD [Messages]
FROM    message M 
        JOIN TRADING_PARTNER TP  ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
        JOIN DELIVERY_INFO DI ON M.DELIVERY_INFO_ID = DI.id
        JOIN RELATED_DATA RD ON DI.id = RD.RELATE_ID
        JOIN RELATED_DATA_DEF RDD ON RDD.id = RD.DEF_ID
        LEFT JOIN WORK_ITEM WI ON WI.RELATE_ID = M.ID
                                  AND WI.WORKFLOW_DEFINITION_ID = 1
WHERE   M.PROCESSED_IN = 'N' 
        AND M.RECEIVED_STATUS_CD IN ( 'RCVD', 'ADHOC', 'HOLD' )
        AND M.MESSAGE_DIRECTION_CD = 'I'
        AND TYPE_CD = 'LFP_TP'
        AND RDD.NAME_TX = 'UniTracDeliveryType'
        AND TP.EXTERNAL_ID_TX NOT IN ( '2771', '3400', '1771', '1574', '5350' )
        AND m.DELIVER_TO_TRADING_PARTNER_ID = '2046'
        AND rd.VALUE_TX = 'IMPORT'
        AND M.PURGE_DT IS NULL
		GROUP BY M.RECEIVED_STATUS_CD

SELECT   COUNT(*) [MSG Errors] FROM MESSAGE M
                           WHERE    M.RECEIVED_STATUS_CD = 'ERR'
                  AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)


SELECT COUNT(*) [WI in Approve Total]
FROM dbo.WORK_ITEM WI
JOIN dbo.MESSAGE M ON M.RELATE_ID_TX = WI.RELATE_ID AND WI.WORKFLOW_DEFINITION_ID = '1'
WHERE WI.STATUS_CD = 'Approve'


SELECT COUNT(*) [WI in Approve needs to be processed and not touched]
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Approve'
AND CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') IS NULL



SELECT COUNT(*) [WIs that excluding LFPs that are in Error]
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Error'
AND   CAST(create_dt AS DATE) = CAST(GETDATE()-1AS DATE)
AND WORKFLOW_DEFINITION_ID <> '1'
AND PURGE_DT IS NULL AND CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)') NOT LIKE '%Unable to load%'
AND CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)') NOT LIKE '%Object reference not set to an instance of an object%'




SELECT 'Fulfillment Process', COUNT(PL.ID) [How many time ran today], MAX(PL.UPDATE_DT) [Last Run Time should be less than 10 minutes]
FROM dbo.PROCESS_LOG PL
WHERE CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND PL.PROCESS_DEFINITION_ID IN (51)


SELECT 'Insurance Document Protocol Adapter' , COUNT(PL.ID) [How many time ran today], MAX(PL.UPDATE_DT) [Last Run Time should be less than 5 minutes except on Tuesday or Wednesday]
FROM dbo.PROCESS_LOG PL
WHERE CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND PL.PROCESS_DEFINITION_ID IN (39)


