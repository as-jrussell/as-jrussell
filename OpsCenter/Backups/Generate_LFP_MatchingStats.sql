USE [PerfStats]
GO

/****** Object:  StoredProcedure [dbo].[Generate_LFP_MatchingStats]    Script Date: 12/5/2023 1:11:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Generate_LFP_MatchingStats]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @TranType AS varchar(max)

SET @TranType ='UNITRAC'
--SET @TranType ='INFA'

SELECT  wi.ID as WI_ID,  wi.CREATE_DT, t.ID AS trans_id, tpl.UPDATE_USER_TX as MessageServerUserName, Min(tpl.CREATE_DT) AS MessageServerStartTime, MIN(ldr.CODE_TX) AS LenderCode
INTO #tmpWI
FROM UniTrac.dbo.WORK_ITEM wi
JOIN UniTrac.dbo.DOCUMENT D ON wi.RELATE_ID = D.MESSAGE_ID
JOIN UniTrac.dbo.[TRANSACTION] t ON T.document_id = D.ID
join UniTrac.dbo.TRADING_PARTNER_LOG tpl on tpl.MESSAGE_ID = wi.RELATE_ID
JOIN UniTrac.dbo.LENDER ldr ON ldr.id = wi.LENDER_ID
WHERE wi.WORKFLOW_DEFINITION_ID = 1
AND CAST(wi.CREATE_DT AS DATE) = CAST(GETDATE() - 1 AS date)
AND wi.STATUS_CD NOT IN ('error', 'withdrawn', 'late')
AND (t.RELATE_TYPE_CD = @TranType OR T.RELATE_TYPE_CD ='')  
AND T.PURGE_DT is NULL
AND wi.PURGE_DT is null
AND D.PURGE_DT is NULL
AND tpl.LOG_MESSAGE = 'Started Processing Message'
GROUP BY wi.ID ,  wi.CREATE_DT, t.ID , tpl.UPDATE_USER_TX


INSERT into PerfStats.dbo.LFP_MatchingStats 
	(LenderCode, 
	WI_ID, 
	TRANSACTION_ID, 
	MessageServerUserName, 
	CountLetd, 
	MessageServerStartTime, 
	first_letd, 
	last_letd, 
	delta_time_Start_First, 
	delta_time_First_Last, 
	CacheLoadTransformSeconds, 
	MatchingSeconds, 
	loans_per_sec)
SELECT 
MIN (LenderCode) AS LenderCode,
w.WI_ID, 
letd.TRANSACTION_ID, 
MIN(MessageServerUserName) AS MessageServerUserName,
COUNT(*) AS CountLetd, 
MIN(w.MessageServerStartTime) AS MessageServerStartTime ,
min(letd.CREATE_DT) as first_letd,  
     max(letd.CREATE_DT) as last_letd,  
	 max(letd.CREATE_DT)-MIN(MessageServerStartTime) as delta_time_Start_First, 
     max(letd.CREATE_DT)-min(letd.CREATE_DT) as delta_time_First_Last,  
	 datediff(second, MIN(MessageServerStartTime), min(letd.CREATE_DT)) as 'CacheLoadTransformSeconds',
     datediff(second, MIN(letd.CREATE_DT), max(letd.CREATE_DT)) as 'MatchingSeconds'
     ,convert(decimal, count(*))/convert(decimal, datediff(second, MIN(letd.CREATE_DT), max(letd.CREATE_DT))) as 'loans/per-sec' 
FROM #tmpWI w
JOIN UniTrac.dbo.LOAN_EXTRACT_TRANSACTION_DETAIL letd on letd.TRANSACTION_ID = w.trans_id
GROUP BY w.WI_ID, letd.TRANSACTION_ID
HAVING datediff(second, MIN(UPDATE_DT), max(UPDATE_DT)) >1 

END
GO


