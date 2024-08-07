USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[CPGetNotificationEvent]    Script Date: 7/15/2017 12:40:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CPGetNotificationEvent]
AS
BEGIN
DECLARE @ExpirationDays INT = -4
SELECT @ExpirationDays = (SELECT TOP 1 CAST(MEANING_TX AS INT) FROM REF_CODE WHERE DOMAIN_CD = 'CPNotificationEvent' AND CODE_CD = 'EmailNotificationExpirationDays')
DECLARE @OLDEST_DT DATETIME2 = DATEADD(DAY, @ExpirationDays, DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())))
SELECT @OLDEST_DT = DATEADD(DAY, @ExpirationDays, GETDATE())
--SELECT @ExpirationDays,@OLDEST_DT
DECLARE @GroupID BIGINT;
SELECT @GroupId =  (MAX(ISNULL(GROUP_ID, 0)) + 1) FROM dbo.NOTIFICATION_EVENT

-- This should occur before the previous select and the previous should select with GROUP_ID = @GroupId so that any reports added in the 
-- timespan that the query is running are not marked as notified when they were not
DECLARE @TEMP TABLE(id BIGINT)

INSERT INTO @TEMP
SELECT NE.ID
FROM NOTIFICATION_EVENT NE
	JOIN REPORT_HISTORY RH ON RH.ID = NE.RELATE_ID
	LEFT JOIN DOCUMENT_CONTAINER DC ON DC.ID = RH.DOCUMENT_CONTAINER_ID AND DC.PRINT_STATUS_CD IN ('PEND', 'PRINTED')
WHERE NE.TYPE_CD = 'REPORT'
	AND (ISNULL(RH.LENDER_ID,0) <> 0) 
	AND RH.WEB_PUBLISH_STATUS_CD = 'WE'
	AND RH.STATUS_CD = 'COMP'
	AND NE.GROUP_ID = 0
	AND NE.UPDATE_DT > @OLDEST_DT
	AND (RH.GENERATION_SOURCE_CD <> 'U' OR DC.ID > 0 OR RH.CREATED_BY_TX IS NOT NULL) 

SELECT DISTINCT
NE.ID, @GROUPID AS GROUP_ID, 
ne.RELATE_ID, ne.RELATE_CLASS,
LND.CODE_TX AS LENDER_CD,
RC.MEANING_TX AS DIVISION,
--RH.REPORT_DATA_XML.value('(//ReportData/Report/Lender/@value)[1]', 'nvarchar(20)') AS LENDER_ID,
RH.RECORD_COUNT_NO, RH.CREATE_DT, 
RH.REPORT_DATA_XML.value('(//ReportData/Report/Title/@value)[1]', 'nvarchar(300)') + ' - ' + ISNULL(LRC.DESCRIPTION_TX, '')  AS DESCRIPTION_TX,
ne.CREATED_BY_TX, RH.UPDATE_DT
FROM NOTIFICATION_EVENT NE
JOIN REPORT_HISTORY RH ON RH.ID = NE.RELATE_ID AND RH.PURGE_DT IS NULL
JOIN LENDER LND ON RH.LENDER_ID = LND.ID AND LND.PURGE_DT IS NULL
LEFT JOIN DOCUMENT_CONTAINER DC ON DC.ID = RH.DOCUMENT_CONTAINER_ID AND DC.PRINT_STATUS_CD IN ('PEND', 'PRINTED') AND DC.PURGE_DT IS NULL
LEFT JOIN LENDER_REPORT_CONFIG LRC ON LRC.LENDER_ID = RH.LENDER_ID
	AND LRC.REPORT_CONFIG_ID = RH.REPORT_DATA_XML.value('(//ReportData/Report/ReportConfigID/@value)[1]', 'nvarchar(20)') AND LRC.PURGE_DT IS NULL
	AND RH.REPORT_DATA_XML.exist('(/ReportData/Report/SourceReportConfigID)[@value=sql:column("LRC.ID")]') = 1  
LEFT JOIN REF_CODE RC ON RC.DOMAIN_CD = 'ContractType' AND RC.CODE_CD = RH.REPORT_DATA_XML.value('(//ReportData/Report/Division/@value)[1]', 'nvarchar(20)') AND RC.PURGE_DT IS NULL
JOIN  @TEMP T ON  T.id = NE.ID

/*WHERE NE.GROUP_ID = 0 -- @GroupId --(when the update is done first) This is the only thing we need in the WHERE clause then
	AND NE.TYPE_CD = 'REPORT'
	AND (ISNULL(RH.LENDER_ID,0) <> 0) 
	--AND RH.REPORT_DATA_XML.value('(//ReportData/Report/Lender/@value)[1]', 'nvarchar(20)') = '4192'  --4test
	AND RH.WEB_PUBLISH_STATUS_CD = 'WE'
	AND RH.STATUS_CD = 'COMP'
	AND NE.UPDATE_DT > @OLDEST_DT 
	AND (RH.GENERATION_SOURCE_CD <> 'U' OR DC.ID > 0 OR RH.CREATED_BY_TX IS NOT NULL) */

UPDATE NOTIFICATION_EVENT 
SET GROUP_ID =  @GroupId,
	STATUS_CD = 'PENDING',
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'UTLenderSrvc'
FROM NOTIFICATION_EVENT NE
JOIN @TEMP T ON T.id = NE.ID

/*update notification_event set group_id = 0, update_dt = getdate() where group_id = 1338*/
--select max(group_id) from NOTIFICATION_EVENT

END
