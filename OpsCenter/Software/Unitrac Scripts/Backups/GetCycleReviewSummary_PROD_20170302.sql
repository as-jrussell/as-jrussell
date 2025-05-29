USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetCycleReviewSummary]    Script Date: 3/2/2017 7:25:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[GetCycleReviewSummary]
(
	@workItemId   bigint
)
WITH RECOMPILE
AS
BEGIN
	
    SET NOCOUNT ON
    
    DECLARE @actualISCTCount int
    DECLARE @isNotice bigint
    DECLARE @isEmailNotice bigint
	DECLARE @isFaxNotice bigint
	DECLARE @isTextNotice bigint
    DECLARE @isISCT bigint
    DECLARE @isOBCL bigint
    DECLARE @isAOBC bigint    
    
    DECLARE @childNoticeCnt bigint
    DECLARE @childISCTCnt bigint
    DECLARE @childOBCLCnt bigint
    DECLARE @childAOBCCnt bigint
    
    DECLARE @isChildWI char(1) = 'N'
    DECLARE @parentWI bigint
    DECLARE @plId bigint
    DECLARE @isImmediate varchar(10)
    
	CREATE TABLE #tmpPLI
	(
		PLI_ID		bigint
	)    

	--Identify if WI is immediate 
	SELECT @isImmediate = CONTENT_XML.value('(/Content/Cycle/Immediate)[1]', 'varchar(10)')
		, @plId = RELATE_ID
	FROM WORK_ITEM
	WHERE ID = @workItemId
	
	IF @isImmediate IS NULL
		SET @isImmediate = 'NO'
	
	--Identify if WI is child or parent. MIN ID will be of parent		    
	SELECT @parentWI = MIN(wi.ID)
	FROM WORK_ITEM wi
		JOIN WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID and wd.NAME_TX = 'Cycle'
	WHERE wi.RELATE_ID = @plId
	AND wi.PURGE_DT IS NULL
    
    IF @parentWI != @workItemId
		SET @isChildWI = 'Y'
    
    IF @isChildWI = 'Y'
    BEGIN
		INSERT INTO #tmpPLI (PLI_ID)
		SELECT rel.PROCESS_LOG_ITEM_ID
		FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE rel
			JOIN PROCESS_LOG_ITEM pli ON pli.ID = rel.PROCESS_LOG_ITEM_ID
		WHERE rel.WORK_ITEM_ID = @workItemId
		AND pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND rel.PURGE_DT IS NULL
    END
    ELSE
    BEGIN
		INSERT INTO #tmpPLI (PLI_ID)
		SELECT pli.ID
		FROM WORK_ITEM wi
			JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = wi.RELATE_ID
		WHERE wi.ID = @workItemId
		AND pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND wi.PURGE_DT IS NULL    
    END
        
	--Notice data	    
	SELECT @isNotice = MIN(pli.ID)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli 
            ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice' 
            AND (pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 0		
			      OR pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('','IH','OS') )	
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL	    
	
   -- Email Notice data
	SELECT @isEmailNotice = MIN(pli.ID)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli 
				ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice' 
				AND pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 1		
				AND pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('EMAIL') 
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL	
	    
	-- Fax Notice Data
	SELECT @isFaxNotice =MIN(pli.ID)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli 
				ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice' 
				AND pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 1		
				AND pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('FAX') 
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL	

	-- Text Notice Data
	SELECT @isTextNotice =MIN(pli.ID)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli 
				ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice' 
				AND pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 1		
				AND pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('TXT') 
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL	

	--ISCT data    
    SELECT @actualISCTCount = count(*)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'		
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL
	
    SELECT @isISCT = MIN(pli.ID)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'		
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL
        
    --OBCL data
    SELECT @isOBCL = MIN(pli.ID)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.Workflow.OutboundCallWorkItem'		
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL
	
		
	--AOBC data
    SELECT @isAOBC = MIN(pli.ID)
	FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.NoticeInteraction'		
	WHERE pli.STATUS_CD = 'COMP'
	AND pli.PURGE_DT IS NULL		
	
	
	IF @isNotice IS NOT NULL
	BEGIN	    
		SELECT 'NTC' AS EVENT_TYPE, rc.TYPE_CD, 'Letter ' + CAST(ntc.SEQUENCE_NO AS VARCHAR) ITEM_TYPE, ref.MEANING_TX NOTICE_TYPE_CD
			, sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'decimal')) LOAN_BALANCE
			, sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'decimal')) QUOTE_PREMIUM
			, count(*) ACTUAL_COUNT, count(*) TOTAL_COUNT
		INTO #tmpNTC
		FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli 
               ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice' 
               AND (pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 0		
					OR pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('','IH','OS') )
			JOIN dbo.NOTICE ntc on ntc.ID = pli.RELATE_ID
			JOIN NOTICE_REQUIRED_COVERAGE_RELATE rel on rel.NOTICE_ID = ntc.ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
			JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y' AND COL.PURGE_DT IS NULL
			JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL
			JOIN dbo.REF_CODE ref ON ref.CODE_CD = ntc.TYPE_CD AND ref.DOMAIN_CD = 'NOTICETYPE'
		WHERE pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND ntc.PURGE_DT IS NULL
		AND rel.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL		
		GROUP BY rc.TYPE_CD, ntc.SEQUENCE_NO, ref.MEANING_TX
	END
	
	IF @isEmailNotice IS NOT NULL
	BEGIN	    
		SELECT 'NTC' AS EVENT_TYPE, rc.TYPE_CD, MIN(pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE/text())[1]','nvarchar(5)')) ITEM_TYPE,
			 ref.MEANING_TX NOTICE_TYPE_CD , sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'decimal')) LOAN_BALANCE
			, sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'decimal')) QUOTE_PREMIUM
			, count(*) ACTUAL_COUNT, count(*) TOTAL_COUNT
		INTO #tmpEmailNTC
		FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'
					AND pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 1		
				    AND pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('EMAIL') 
			JOIN dbo.NOTICE ntc on ntc.ID = pli.RELATE_ID
			JOIN NOTICE_REQUIRED_COVERAGE_RELATE rel on rel.NOTICE_ID = ntc.ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
			JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y' AND COL.PURGE_DT IS NULL
			JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL
			JOIN dbo.REF_CODE ref ON ref.CODE_CD = ntc.TYPE_CD AND ref.DOMAIN_CD = 'NOTICETYPE'
		WHERE pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND ntc.PURGE_DT IS NULL
		AND rel.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL		
		GROUP BY rc.TYPE_CD, ntc.SEQUENCE_NO, ref.MEANING_TX
		
	END

	IF @isFaxNotice IS NOT NULL
	BEGIN	    
		SELECT 'NTC' AS EVENT_TYPE, rc.TYPE_CD, MIN(pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE/text())[1]','nvarchar(5)')) ITEM_TYPE,
			 ref.MEANING_TX NOTICE_TYPE_CD , sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'decimal')) LOAN_BALANCE
			, sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'decimal')) QUOTE_PREMIUM
			, count(*) ACTUAL_COUNT, count(*) TOTAL_COUNT
		INTO #tmpFaxNTC
		FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'
					AND pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 1		
				    AND pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('FAX') 
			JOIN dbo.NOTICE ntc on ntc.ID = pli.RELATE_ID
			JOIN NOTICE_REQUIRED_COVERAGE_RELATE rel on rel.NOTICE_ID = ntc.ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
			JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y' AND COL.PURGE_DT IS NULL
			JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL
			JOIN dbo.REF_CODE ref ON ref.CODE_CD = ntc.TYPE_CD AND ref.DOMAIN_CD = 'NOTICETYPE'
		WHERE pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND ntc.PURGE_DT IS NULL
		AND rel.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL		
		GROUP BY rc.TYPE_CD, ntc.SEQUENCE_NO, ref.MEANING_TX
		
	END

	IF @isTextNotice IS NOT NULL
	BEGIN	    
		SELECT 'NTC' AS EVENT_TYPE, rc.TYPE_CD, MIN(pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE/text())[1]','nvarchar(5)')) ITEM_TYPE,
			 ref.MEANING_TX NOTICE_TYPE_CD , sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'decimal')) LOAN_BALANCE
			, sum(ntc.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'decimal')) QUOTE_PREMIUM
			, count(*) ACTUAL_COUNT, count(*) TOTAL_COUNT
		INTO #tmpTextNTC
		FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'
					AND pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE/text())[1]') = 1		
				    AND pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('TXT') 
			JOIN dbo.NOTICE ntc on ntc.ID = pli.RELATE_ID
			JOIN NOTICE_REQUIRED_COVERAGE_RELATE rel on rel.NOTICE_ID = ntc.ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
			JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y' AND COL.PURGE_DT IS NULL
			JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL
			JOIN dbo.REF_CODE ref ON ref.CODE_CD = ntc.TYPE_CD AND ref.DOMAIN_CD = 'NOTICETYPE'
		WHERE pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND ntc.PURGE_DT IS NULL
		AND rel.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL		
		GROUP BY rc.TYPE_CD, ntc.SEQUENCE_NO, ref.MEANING_TX
		
	END

	IF @isISCT IS NOT NULL
	BEGIN
		--Temp table for certs since cross apply duplicates the fpc if multiple owners are present.
		SELECT DISTINCT fpc.ID FPC_ID, pli.ID PLI_ID
		INTO #tmpISCTTemp				
		FROM #tmpPLI tmp
			JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
			JOIN dbo.FORCE_PLACED_CERTIFICATE fpc on fpc.ID = pli.RELATE_ID
			JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE rel on rel.FPC_ID = fpc.ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
			JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y' AND COL.PURGE_DT IS NULL
			JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL		
			CROSS APPLY fpc.CAPTURED_DATA_XML.nodes('//CapturedData/Owner') as O(Tab) 
		WHERE pli.STATUS_CD = 'COMP'
		AND O.Tab.value('@generatePDF', 'nvarchar(10)') = 'true'
		AND O.Tab.value('@lender','nvarchar(10)') = 'false' 
		AND pli.PURGE_DT IS NULL
		AND fpc.PURGE_DT IS NULL
		AND rel.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL

				
		SELECT 'ISCT' AS EVENT_TYPE, rc.TYPE_CD, 'Certificate' AS ITEM_TYPE, '' AS NOTICE_TYPE_CD
			, sum(fpc.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'decimal')) LOAN_BALANCE
			, sum(fpc.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'decimal')) QUOTE_PREMIUM
			, @actualISCTCount ACTUAL_COUNT, count(*) TOTAL_COUNT
		INTO #tmpISCT				
		FROM #tmpISCTTemp tmp 
			JOIN FORCE_PLACED_CERTIFICATE fpc ON fpc.ID = tmp.FPC_ID
			JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE rel on rel.FPC_ID = fpc.ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
			JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID
		WHERE ((@isImmediate = 'YES') OR (@isImmediate != 'YES' AND PLI.EVALUATION_EVENT_ID > 0))	
		GROUP BY rc.TYPE_CD
	END
		
	IF @isOBCL IS NOT NULL
	BEGIN
		SELECT 'OBCL' AS EVENT_TYPE, rc.TYPE_CD, 'Outbound Call' AS ITEM_TYPE, '' AS NOTICE_TYPE_CD
			, NULL AS LOAN_BALANCE
			, NULL AS QUOTE_PREMIUM
			, count(*) ACTUAL_COUNT, count(*) TOTAL_COUNT
		INTO #tmpOBCL
		FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.Workflow.OutboundCallWorkItem'
			JOIN EVALUATION_EVENT evt on evt.ID = pli.EVALUATION_EVENT_ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = evt.REQUIRED_COVERAGE_ID
			JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y' AND COL.PURGE_DT IS NULL
			JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL		
		WHERE pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND evt.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL	
		GROUP BY rc.TYPE_CD
	END
	
	IF @isAOBC IS NOT NULL
	BEGIN
		SELECT 'AOBC' AS EVENT_TYPE, rc.TYPE_CD, 'Automated Outbound Call' AS ITEM_TYPE, '' AS NOTICE_TYPE_CD
			, NULL AS LOAN_BALANCE
			, NULL AS QUOTE_PREMIUM
			, count(*) ACTUAL_COUNT, count(*) TOTAL_COUNT
		INTO #tmpAOBC
		FROM #tmpPLI tmp
		JOIN PROCESS_LOG_ITEM pli ON pli.ID = tmp.PLI_ID AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.NoticeInteraction'
			JOIN EVALUATION_EVENT evt on evt.ID = pli.EVALUATION_EVENT_ID
			JOIN REQUIRED_COVERAGE rc on rc.ID = evt.REQUIRED_COVERAGE_ID
			JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y' AND COL.PURGE_DT IS NULL
			JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL		
		WHERE pli.STATUS_CD = 'COMP'
		AND pli.PURGE_DT IS NULL
		AND evt.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL	
		GROUP BY rc.TYPE_CD
	END	
	
	DECLARE @sql NVARCHAR(500)
	SET @sql = ''
	
	IF @isNotice IS NOT NULL
	BEGIN
		SET @sql = 'SELECT * FROM #tmpNTC'
	END

   IF @isEmailNotice IS NOT NULL
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'

		SET @sql = @sql + ' SELECT * FROM #tmpEmailNTC'
	END

	IF @isFaxNotice IS NOT NULL
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'

		SET @sql = @sql + ' SELECT * FROM #tmpFaxNTC'
	END

	IF @isTextNotice IS NOT NULL
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'

		SET @sql = @sql + ' SELECT * FROM #tmpTextNTC'
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

