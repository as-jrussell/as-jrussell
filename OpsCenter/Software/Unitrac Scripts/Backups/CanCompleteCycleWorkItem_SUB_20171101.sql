USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[CanCompleteCycleWorkItem]    Script Date: 11/1/2017 8:09:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[CanCompleteCycleWorkItem]
(
	@workItemId   bigint
)
AS
BEGIN
		
    SET NOCOUNT ON
    
    DECLARE @isNotice bigint
    DECLARE @isISCT bigint
    DECLARE @isOBCL bigint
    DECLARE @isAOBC bigint 
    
    --Notice data	    
	SELECT @isNotice = MIN(pli.ID)
	FROM WORK_ITEM wi
		JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'		
	WHERE wi.ID = @workItemId
	AND pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL	    

	--ISCT data    
    SELECT @isISCT = MIN(pli.ID)
	FROM WORK_ITEM wi
		JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'		
	WHERE wi.ID = @workItemId
	AND pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL
	    
    --OBCL data
    SELECT @isOBCL = MIN(pli.ID)
	FROM WORK_ITEM wi
		JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.Workflow.VerificationEventWorkItem'		
	WHERE wi.ID = @workItemId
	AND pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL
		
	--AOBC data
    SELECT @isAOBC = MIN(pli.ID)
	FROM WORK_ITEM wi
		JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.NoticeInteraction'		
	WHERE wi.ID = @workItemId
	AND pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL
		
	
	IF @isNotice IS NOT NULL
	BEGIN	
		SELECT 'NTC' AS EVENT_TYPE, count(*) TOTAL_UNWORKED_COUNT
		INTO #tmpNTC
		FROM WORK_ITEM wi
			JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'
		WHERE wi.ID = @workItemId
		AND pli.STATUS_CD = 'COMP'
		AND pli.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') IS NULL
		AND pli.PURGE_DT IS NULL
	END

	IF @isISCT IS NOT NULL
	BEGIN	
		--Temp table for certs since cross apply duplicates the fpc if multiple owners are present.    
		SELECT DISTINCT fpc.ID
		INTO #tmpISCTTemp
		FROM WORK_ITEM wi
			JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
			JOIN dbo.FORCE_PLACED_CERTIFICATE fpc on fpc.ID = pli.RELATE_ID
			CROSS APPLY fpc.CAPTURED_DATA_XML.nodes('//CapturedData/Owner') as O(Tab) 
		WHERE wi.ID = @workItemId
		AND pli.STATUS_CD = 'COMP'
		AND pli.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') IS NULL
		AND O.Tab.value('@generatePDF', 'nvarchar(10)') = 'true'
		AND O.Tab.value('@lender','nvarchar(10)') = 'false'
		AND pli.PURGE_DT IS NULL
		AND fpc.PURGE_DT IS NULL
			
		SELECT 'ISCT' AS EVENT_TYPE, count(*) TOTAL_UNWORKED_COUNT
		INTO #tmpISCT 
		FROM #tmpISCTTemp
	END

	IF @isOBCL IS NOT NULL
	BEGIN	
		SELECT 'VFY' AS EVENT_TYPE, count(*) TOTAL_UNWORKED_COUNT
		INTO #tmpOBCL
		FROM WORK_ITEM wi
			JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.Workflow.VerificationEventWorkItem'
		WHERE wi.ID = @workItemId
		AND pli.STATUS_CD = 'COMP'
		AND pli.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') IS NULL
		AND pli.PURGE_DT IS NULL
	END

	IF @isAOBC IS NOT NULL
	BEGIN	
		SELECT 'AOBC' AS EVENT_TYPE, count(*) TOTAL_UNWORKED_COUNT
		INTO #tmpAOBC
		FROM WORK_ITEM wi
			JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.NoticeInteraction'
		WHERE wi.ID = @workItemId
		AND pli.STATUS_CD = 'COMP'
		AND pli.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') IS NULL
		AND pli.PURGE_DT IS NULL
	END
	
	DECLARE @sql NVARCHAR(500)
	SET @sql = ''
	
	IF @isNotice IS NOT NULL
	BEGIN
		SET @sql = 'SELECT * FROM #tmpNTC'
	END

	IF @isISCT IS NOT NULL
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'
		
		SET @sql = @sql + ' SELECT * FROM #tmpISCT'
	END
	
	IF @isOBCL IS NOT NULL
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'
		
		SET @sql = @sql + ' SELECT * FROM #tmpOBCL'
	END
	
	IF @isAOBC IS NOT NULL
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'
		
		SET @sql = @sql + ' SELECT * FROM #tmpAOBC'
	END
	
	print @sql
	exec sp_executesql @sql	
	
END


GO

