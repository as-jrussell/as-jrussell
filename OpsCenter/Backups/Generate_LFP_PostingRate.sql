USE [PerfStats]
GO

/****** Object:  StoredProcedure [dbo].[Generate_LFP_PostingRate]    Script Date: 12/5/2023 1:10:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Generate_LFP_PostingRate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
DECLARE @TranType AS varchar(max)

SET @TranType ='UNITRAC'
--SET @TranType ='INFA'

SELECT  
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]','nvarchar(max)') AS pl_id,ldr.CODE_TX, wi.ID as wi_id
INTO #tmp
FROM UniTrac.dbo.WORK_ITEM wi
JOIN UniTrac.dbo.LENDER ldr ON ldr.ID = wi.LENDER_ID
JOIN UniTrac.dbo.WORK_ITEM_ACTION wia ON wia.WORK_ITEM_ID = wi.ID 
WHERE wia.TO_STATUS_CD = 'ImportCompleted'
and wi.WORKFLOW_DEFINITION_ID = 1
AND wi.STATUS_CD NOT IN ( 'FileMaintenance','Approve','Withdrawn','Failed Validation', 'error')
AND wia.FROM_STATUS_CD != 'ImportCompleted'
--AND ldr.CODE_TX = '5044'
AND CAST(wi.CREATE_DT AS DATE) = CAST(GETDATE() - 1 AS date)
--AND wia.UPDATE_USER_TX = 'LDHPCRA'

INSERT INTO PerfStats.dbo.LFP_PostingStats 
	(LenderCode, 
	 WI_ID,
	 CreateDate,
	  process_log_id,
	  pli_count,
	  first_pli, 
	  last_pli, 
	  delta_time, 
	  seconds, 
	  loans_per_sec, 
	  Min_UpdateUser, 
	  Max_UpdateUser)
	SELECT

		MIN(t.CODE_TX) AS LenderCode
	   ,MIN(t.WI_ID) AS WI_ID
	   ,MIN(CAST(pli.CREATE_DT AS DATE)) CreateDate
	   ,process_log_id
	   ,COUNT(*) AS pli_count
	   ,MIN(UPDATE_DT) AS first_pli
	   ,MAX(UPDATE_DT) AS last_pli
	   ,MAX(UPDATE_DT) - MIN(UPDATE_DT) AS delta_time
	   ,DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT)) AS 'seconds'
	   ,CONVERT(DECIMAL, COUNT(*)) / CONVERT(DECIMAL, DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT))) AS 'loans/per-sec'
	   ,MIN(pli.UPDATE_USER_TX) AS Min_UpdateUser
	   ,MAX(pli.UPDATE_USER_TX) AS Max_UpdateUser
	FROM UniTrac.dbo.PROCESS_LOG_ITEM pli
	JOIN #tmp t
		ON t.pl_id = pli.process_log_id
	WHERE RELATE_TYPE_CD = 'allied.unitrac.loan'
	AND pli.STATUS_CD != 'GENERIC'
	GROUP BY process_log_id
	HAVING DATEDIFF(SECOND, MIN(UPDATE_DT), MAX(UPDATE_DT)) > 1
	ORDER BY MIN(CAST(pli.CREATE_DT AS DATE)), WI_ID  

END
GO


