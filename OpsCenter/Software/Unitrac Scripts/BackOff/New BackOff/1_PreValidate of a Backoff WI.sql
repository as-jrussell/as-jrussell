USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Support_Backoff_PreValidate]    Script Date: 4/19/2017 2:32:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


DECLARE
   @workitemId BIGINT
	DECLARE @errorText AS NVARCHAR(200)
	DECLARE @wiCount AS INT
	DECLARE @wdCount AS INT
	DECLARE @plCount AS INT
	DECLARE @ftCount AS INT
	DECLARE @approvedCount AS INT
	DECLARE @pdId AS BIGINT
	DECLARE @plId AS BIGINT
	DECLARE @plId2 AS BIGINT	

SET @workitemId = ''	



	-- Rule 1
	SELECT @wiCount = COUNT(*)
	FROM WORK_ITEM wi
	INNER JOIN WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID
	WHERE wi.ID = @workitemId 
	AND wd.WORKFLOW_TYPE_CD = 'Cycle'

	IF @wiCount = 0
	BEGIN
		SET @errorText = 'Cycle WORK_ITEM not found'
		GOTO EXITPATH
	END

	-- Rule 2
	SELECT @wdCount = COUNT(*) 
	FROM WORK_ITEM wi
	WHERE wi.ID = @workitemId 
	AND status_cd = 'Initial'
	
	IF @wdCount = 0
	BEGIN
		SET @errorText = 'WORK_ITEM is not in Initial status'
		GOTO EXITPATH
	END

	-- Rule 3
	SELECT @pdId = PL.PROCESS_DEFINITION_ID, @plId = PL.ID 
	FROM WORK_ITEM WI
	JOIN PROCESS_LOG PL ON PL.ID = WI.RELATE_ID
	WHERE WI.ID = @workitemId

	SELECT @plCount = COUNT(*) 
	FROM PROCESS_LOG 
	WHERE ID = @plId 
	AND STATUS_CD = 'Complete'
	
	IF @plCount = 0
	BEGIN
		SET @errorText = 'PROCESS_LOG is not in Complete status'
		GOTO EXITPATH
	END
	
	-- Rule 4
	SELECT TOP 1 @plId2 = ID 
	FROM PROCESS_LOG 
	WHERE PROCESS_DEFINITION_ID = @pdId --(from previous query)
	AND STATUS_CD = 'Complete' AND MSG_TX <> 'Success' 
	ORDER BY ID DESC

	IF @plId <> @plId2
	BEGIN
		SET @errorText = 'Cycle has been run for given workitem for same PROCESS_DEFINITION/PROCESS_LOG'
		GOTO EXITPATH
	END
	
	-- Rule 5
	SELECT @approvedCount = COUNT(*)
	FROM process_log_item pli
	INNER JOIN process_log pl ON pl.id = pli.process_log_id
	INNER JOIN evaluation_event ee ON ee.id = pli.evaluation_event_id
	INNER JOIN work_item wi ON wi.relate_id = pl.id AND wi.relate_type_cd = 'Osprey.ProcessMgr.ProcessLog'
	WHERE wi.id = @workitemId
	AND ((pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate' AND ee.TYPE_CD IN ('ISCT' , 'PRNT')) 
	OR pli.relate_type_cd = 'Allied.UniTrac.Notice')
	AND pli.STATUS_CD = 'COMP'
	AND ee.STATUS_CD = 'COMP'
	AND pli.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(30)') = 'Approve'
	
	IF @approvedCount > 0
	BEGIN
		SET @errorText = 'PROCESS_LOG_ITEM(s) have been approved'
		GOTO EXITPATH
	END
	
	-- Rule 6
	IF OBJECT_ID(N'tempdb..#tempFPC',N'U') IS NOT NULL
		DROP TABLE #tempFPC   
	
	SELECT pli.RELATE_ID, pli.RELATE_TYPE_CD, ee.TYPE_CD , ee.ID AS EE_ID
	INTO #tempFPC
	FROM process_log_item pli
	INNER JOIN process_log pl ON pl.id = pli.process_log_id
	INNER JOIN evaluation_event ee ON ee.id = pli.evaluation_event_id
	INNER JOIN work_item wi ON wi.relate_id = pl.id AND wi.relate_type_cd = 'Osprey.ProcessMgr.ProcessLog'
	WHERE wi.id = @workitemId
	AND (pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate' AND ee.TYPE_CD = 'ISCT')

	SELECT @ftCount = COUNT(*)
	FROM FINANCIAL_TXN 
	WHERE FPC_ID IN ( SELECT RELATE_ID FROM #tempFPC )
   AND PURGE_DT IS NULL

	IF @ftCount > 0
	BEGIN
		SET @errorText = 'FINANCIAL_TXN posting exist for issued FPCs'
		GOTO EXITPATH
	END
	
	EXITPATH:
		SELECT @errorText as errorText
