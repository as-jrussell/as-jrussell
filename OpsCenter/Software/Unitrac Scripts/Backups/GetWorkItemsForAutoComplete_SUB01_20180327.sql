USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetWorkItemsForAutoComplete]    Script Date: 3/27/2018 8:23:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE 
PROCEDURE [dbo].[GetWorkItemsForAutoComplete]
AS
BEGIN
	SET NOCOUNT ON
	
	CREATE TABLE #tmpWI
	(
		WORKFLOW_TYPE_CD nvarchar(10), 
		WORK_ITEM_ID bigint, 
		PROCESS_LOG_ID bigint
	)

	INSERT INTO #tmpWI(WORKFLOW_TYPE_CD, WORK_ITEM_ID, PROCESS_LOG_ID)
	SELECT DISTINCT WORKFLOW_TYPE_CD, WORK_ITEM_ID, PROCESS_LOG_ID
	FROM
	(
   		SELECT 
			  DISTINCT wd.WORKFLOW_TYPE_CD, wi.ID WORK_ITEM_ID, wi.RELATE_ID PROCESS_LOG_ID
		FROM
			WORK_ITEM wi
			JOIN WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID AND wd.WORKFLOW_TYPE_CD = 'CYCLE' 
			JOIN PROCESS_LOG_ITEM pli 
					ON pli.PROCESS_LOG_ID = wi.RELATE_ID
					AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
					AND pli.PURGE_DT IS NULL
			JOIN NOTICE n ON n.id = pli.RELATE_ID AND n.PURGE_DT IS NULL
		WHERE wi.STATUS_CD = 'Initial'
			AND pli.STATUS_CD = 'COMP'
			AND n.PDF_GENERATE_CD = 'COMP'
		UNION ALL
   		SELECT 
			DISTINCT wd.WORKFLOW_TYPE_CD, wi.ID WORK_ITEM_ID, wi.RELATE_ID PROCESS_LOG_ID--, wi.STATUS_CD, wi.CREATE_DT
		FROM
			WORK_ITEM wi
			JOIN WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID AND wd.WORKFLOW_TYPE_CD = 'CYCLE'
			JOIN PROCESS_LOG_ITEM pli 
					ON pli.PROCESS_LOG_ID = wi.RELATE_ID
					AND pli.RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate'
					AND pli.PURGE_DT IS NULL
			JOIN FORCE_PLACED_CERTIFICATE fpc ON fpc.ID = pli.RELATE_ID AND fpc.PURGE_DT IS NULL
		WHERE wi.STATUS_CD = 'Initial'	
			AND pli.STATUS_CD = 'COMP'
			AND fpc.PDF_GENERATE_CD = 'COMP'			
	) tblCycle
	UNION ALL
	SELECT 
		DISTINCT wd.WORKFLOW_TYPE_CD, wi.ID WORK_ITEM_ID, wi.RELATE_ID PROCESS_LOG_ID
	FROM
		WORK_ITEM wi
		JOIN WORKFLOW_DEFINITION wd ON wd.ID = wi.WORKFLOW_DEFINITION_ID AND wd.WORKFLOW_TYPE_CD = 'Escrow' 
	WHERE wi.STATUS_CD = 'Initial'

	--Get WIs which are marked for AutoComplete but have not been processed yet.
	SELECT tmp.WORKFLOW_TYPE_CD, tmp.WORK_ITEM_ID, tmp.PROCESS_LOG_ID
	FROM #tmpWI tmp
		JOIN WORK_ITEM wi ON wi.ID = tmp.WORK_ITEM_ID
	WHERE tmp.WORKFLOW_TYPE_CD = 'Cycle'  
	AND wi.CONTENT_XML.value('(/Content/Cycle/IsAutoCompleteEnabled)[1]', 'varchar(3)') = 'YES'
	AND wi.CONTENT_XML.value('(/Content/Cycle/IsAutoCompleteDone)[1]', 'varchar(3)') = 'NO'	
	UNION ALL	
	SELECT tmp.WORKFLOW_TYPE_CD, tmp.WORK_ITEM_ID, tmp.PROCESS_LOG_ID
	FROM #tmpWI tmp
		JOIN WORK_ITEM wi ON wi.ID = tmp.WORK_ITEM_ID
	WHERE tmp.WORKFLOW_TYPE_CD = 'Escrow'  
	AND wi.CONTENT_XML.value('(/Content/Escrow/IsAutoCompleteEnabled)[1]', 'varchar(3)') = 'YES'
	AND wi.CONTENT_XML.value('(/Content/Escrow/IsAutoCompleteDone)[1]', 'varchar(3)') = 'NO'	

END

GO

