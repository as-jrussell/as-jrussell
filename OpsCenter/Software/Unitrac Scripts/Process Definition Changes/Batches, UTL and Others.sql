use unitrac 

select count(*) [UTL Count], min(q.CREATE_DT) [Last UTL Done]
from UTL_CACHE_CHANGE_QUEUE q
where DATEDIFF(hour, q.CREATE_DT, getutcdate()) > 0

SELECT COUNT(*) [UTL Matches for Day]
FROM UTL_MATCH_RESULT umr
WHERE CAST(umr.CREATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
  AND umr.UTL_VERSION_NO = 2


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

SELECT COUNT(*) [WI in Approve needs to be processed and not touched]
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Approve'
AND CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') IS NULL



SELECT COUNT(*) [WIs that excluding LFPs that are in Error]
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Error'
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE()AS DATE)
AND WORKFLOW_DEFINITION_ID <> '1'
AND PURGE_DT IS NULL AND CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)') NOT LIKE '%Unable to load%'
AND CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)') NOT LIKE '%Object reference not set to an instance of an object%'