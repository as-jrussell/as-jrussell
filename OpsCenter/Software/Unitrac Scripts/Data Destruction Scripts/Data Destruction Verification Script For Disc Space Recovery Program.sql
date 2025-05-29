SET NOCOUNT ON


PRINT '------------------------------------------------------ Verification script for PERFORMANCE_LOG section ---------------------------------------------------'
DECLARE @retentionPeriod SMALLINT


	/***************************************************************************************************
	*******   Get retention period for the PERFORMANCE_LOG table from RETENTION_PERIOD_BY_TABLE  *******
	***************************************************************************************************/
	
	SELECT
		@retentionPeriod = RETENTION_PERIOD_IN_MONTHS
	FROM RETENTION_PERIOD_BY_TABLE AS RPBT
	WHERE RPBT.TABLE_NAME = 'PERFORMANCE_LOG'

	/***************************************************************************************************
	*******		 Get all PERFORMANCE_LOGs whose create date is over the retention period		 *******
	***************************************************************************************************/
	
	-- 1,106,968,689
	SELECT
		'PERFORMANCE_LOG',COUNT(PL.ID) 
	FROM PERFORMANCE_LOG AS PL
	WHERE PL.CREATE_DT < CONVERT(DATE, DATEADD(MONTH, @retentionPeriod, GETDATE()), 101)

	-- 23,841,848
	SELECT 
		'PERFORMANCE_LOG - RETAINE', COUNT(PL.ID)
	FROM PERFORMANCE_LOG AS PL
	WHERE PL.CREATE_DT >= CONVERT(DATE, DATEADD(MONTH, @retentionPeriod, GETDATE()), 101)

	/***************************************************************************************************
	***************							Drop Temp Tables							****************
	***************************************************************************************************/

PRINT '-------------------------------------------------------- Verification script for PROCESS_DEFINITION section -------------------------------------------------'

	--DECLARE @retentionPeriod SMALLINT

	IF OBJECT_ID('tempdb.dbo.#ProcessDefinitionIds') IS NOT NULL
    	DROP TABLE #ProcessDefinitionIds
    GO
    
	/***************************************************************************************************
	**************							PROCESS_DEFINITION							****************
	***************************************************************************************************/
	
	-- Get all PROCESS_DEFINITION.ID that are older than retention period, do not have any process logs related and EXECUTION_FREQ_CD is 'RUNONCE'
	-- 25492
	SELECT
		PD.ID 
	INTO #ProcessDefinitionIds
	FROM PROCESS_DEFINITION AS PD
	CROSS APPLY(SELECT * FROM RETENTION_PERIOD_BY_TABLE WHERE TABLE_NAME = 'PROCESS_DEFINITION') c
	LEFT JOIN PROCESS_LOG AS PL
		ON PD.ID = PL.PROCESS_DEFINITION_ID
	WHERE PD.EXECUTION_FREQ_CD = 'RUNONCE'
	AND PL.ID IS NULL
	AND PD.UPDATE_DT < CONVERT(DATE, DATEADD(MONTH, c.RETENTION_PERIOD_IN_MONTHS, GETDATE()), 101)

	SELECT 'PROCESS_DEFINITION  ', COUNT(ID) FROM #ProcessDefinitionIds

	SELECT 'PROCESS_DEFINITION - RETAINED', COUNT(PD.ID) 
	FROM PROCESS_DEFINITION AS PD
	CROSS APPLY(SELECT * FROM RETENTION_PERIOD_BY_TABLE WHERE TABLE_NAME = 'PROCESS_DEFINITION') c
	LEFT JOIN PROCESS_LOG AS PL
		ON PD.ID = PL.PROCESS_DEFINITION_ID
	WHERE PD.EXECUTION_FREQ_CD = 'RUNONCE'
	AND PL.ID IS NULL
	AND PD.UPDATE_DT >= CONVERT(DATE, DATEADD(MONTH, c.RETENTION_PERIOD_IN_MONTHS, GETDATE()), 101)

	/***************************************************************************************************
	***************								RELATED_DATA							****************
	***************************************************************************************************/

	-- Get All Related Datas that are Related to the process definitions
	-- 24624
	SELECT
		'PROCESS_DEFINITION - RELATED_DATA  ', COUNT(RD.ID) 
	FROM RELATED_DATA AS RD
	JOIN RELATED_DATA_DEF AS RDD
		ON RD.DEF_ID = RDD.ID
	JOIN #ProcessDefinitionIds AS PDI
		ON PDI.ID = RD.RELATE_ID
			AND RDD.RELATE_CLASS_NM = 'ProcessDefinition'
	
	SELECT
		'PROCESS_DEFINITION - RELATED_DATA  RETAINED ', COUNT(RD.ID) 
	FROM RELATED_DATA AS RD
	JOIN RELATED_DATA_DEF AS RDD
		ON RD.DEF_ID = RDD.ID
	LEFT JOIN #ProcessDefinitionIds AS PDI
		ON PDI.ID = RD.RELATE_ID
	WHERE RDD.RELATE_CLASS_NM = 'ProcessDefinition'	AND PDI.ID IS NULL

	/***************************************************************************************************
	***************							Drop Temp Tables							****************
	***************************************************************************************************/
	DROP TABLE #ProcessDefinitionIds
	
PRINT '------------------------------------------------------------- Verification script for WORK_ITEM section -------------------------------------------------------------------------'


	/*****************************************************************************************************************
	********************								WORK_ITEM									******************			
	*****************************************************************************************************************/

	IF OBJECT_ID('tempdb.dbo.#AllWorkItemIds') IS NOT NULL
		DROP TABLE #AllWorkItemIds

	-- Prod-01 - 37,656,202
	CREATE TABLE #AllWorkItemIds (
		WI_ID BIGINT
	   ,PARENT_ID BIGINT
	   ,WORKFLOW_TYPE_CD NVARCHAR(50)
	   ,RETENTION_PERIOD_IN_MONTHS SMALLINT
	   ,DELETE_IN CHAR(1) DEFAULT ('Y')
	   ,RELATE_ID BIGINT
	   ,RELATE_TYPE_CD NVARCHAR(50)
	)

	-- Get all workitems that are over the retention period and are in status_cds ('Error', 'Complete', 'Withdrawn') 
	-- Prod-01 - 37,658,009 rows
	INSERT INTO #AllWorkItemIds (WI_ID, PARENT_ID, WORKFLOW_TYPE_CD, RETENTION_PERIOD_IN_MONTHS, RELATE_ID, RELATE_TYPE_CD)
		SELECT
			W.ID AS WI_ID
		   ,W.PARENT_ID PARENT_ID
		   ,RPW.WORKFLOW_TYPE_CD
		   ,RPW.RETENTION_PERIOD_IN_MONTHS
		   ,W.RELATE_ID
		   ,W.RELATE_TYPE_CD
		FROM WORK_ITEM AS W
		JOIN WORKFLOW_DEFINITION AS WD
			ON W.WORKFLOW_DEFINITION_ID = WD.ID
		JOIN RETENTION_PERIOD_WORKITEM AS RPW
			ON RPW.WORKFLOW_TYPE_CD = WD.WORKFLOW_TYPE_CD
		WHERE (W.STATUS_CD IN ('Error', 'Complete', 'Withdrawn')
		OR W.PURGE_DT IS NOT NULL)
		AND W.UPDATE_DT < CONVERT(DATE, DATEADD(MONTH, RPW.RETENTION_PERIOD_IN_MONTHS, GETDATE()), 101)

	/*************** WORK_ITEM: Parent / Child check **********************/
	-- Cannot delete children if parent is not in the purge list (meaning we are not deleting parent)
	-- 349 rows
	UPDATE child
	SET DELETE_IN = 'N'
	--SELECT child.*
	FROM #AllWorkItemIds child
	LEFT JOIN #AllWorkItemIds parent
		ON child.PARENT_ID = parent.WI_ID
		AND parent.PARENT_ID IS NULL
	WHERE parent.WI_ID IS NULL
	AND child.PARENT_ID IS NOT NULL

	-- Cannot delete parent if one or more children are not deleted
	-- 24 rows
	UPDATE parent
	SET DELETE_IN = 'N'
	-- select parent.*
	FROM #AllWorkItemIds AS parent
	CROSS APPLY (SELECT
			COUNT(*) CNT
		FROM WORK_ITEM AS child
		WHERE child.PARENT_ID = parent.WI_ID
		AND child.PARENT_ID IS NOT NULL) actual
	CROSS APPLY (SELECT
			COUNT(*) CNT
		FROM #AllWorkItemIds child
		WHERE child.PARENT_ID = parent.WI_ID
		AND child.PARENT_ID IS NOT NULL
		AND child.DELETE_IN = 'Y') purging
	WHERE actual.CNT != purging.CNT
	AND parent.PARENT_ID IS NULL

	-- update the DELETE_IN on all child workitems whose parent workitem has DELETE_IN = 'N'. 
	-- This is done just to make sure that the above update query if it update any Parent 
	-- Workitem DELETE_IN flag then we have to flip the children workitem for that parent.
	-- 0 rows
	UPDATE child
	SET DELETE_IN = 'N'
	FROM #AllWorkItemIds AS parent
	JOIN #AllWorkItemIds AS child
		ON child.PARENT_ID = parent.WI_ID
	WHERE parent.DELETE_IN = 'N'
	AND child.DELETE_IN = 'Y'

    /********************                     SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE              ******************/
	                
	IF OBJECT_ID('tempdb.dbo.#SubWorkItemBusinessObjectItemRelateIds') IS NOT NULL
		DROP TABLE #SubWorkItemBusinessObjectItemRelateIds

	IF OBJECT_ID('tempdb.dbo.#SubParentIds') IS NOT NULL
		DROP TABLE #SubParentIds

	-- Get all parent workitems from the SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE table that are not in #AllWorkItemIds
	-- 18,756
	SELECT DISTINCT
		SWIBOIR.PARENT_WORK_ITEM_ID 
	INTO #SubParentIds
	FROM SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE AS SWIBOIR
	LEFT JOIN #AllWorkItemIds parent
		ON parent.WI_ID = SWIBOIR.PARENT_WORK_ITEM_ID
	WHERE parent.WI_ID IS NULL

	-- Do Not delete Children if the Parent is Not in #AllWorkItemIds
	-- 343
	UPDATE a
	SET DELETE_IN = 'N'
	-- Select a.*
	FROM #AllWorkItemIds a
	JOIN SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE s
		ON a.WI_ID = s.WORK_ITEM_ID
	JOIN #SubParentIds p
		ON s.PARENT_WORK_ITEM_ID = p.PARENT_WORK_ITEM_ID

	-- Do Not delete Parent where one or more Child is Not in #AllWorkItemIds
	-- 23
	UPDATE a
	SET DELETE_IN = 'N'
	--SELECT  a.*, actual.CNT, purging.CNT
	FROM #AllWorkItemIds a
	CROSS APPLY (SELECT DISTINCT
			s.PARENT_WORK_ITEM_ID
		   ,s.WORK_ITEM_ID
		FROM SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE s
		WHERE a.WI_ID = s.PARENT_WORK_ITEM_ID) s
	CROSS APPLY (SELECT
			COUNT(DISTINCT c.WORK_ITEM_ID) CNT
		FROM SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE c
		WHERE s.PARENT_WORK_ITEM_ID = c.PARENT_WORK_ITEM_ID) actual
	CROSS APPLY (SELECT
			COUNT(DISTINCT c.WORK_ITEM_ID) CNT
		FROM SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE c
		JOIN #AllWorkItemIds a
			ON c.WORK_ITEM_ID = a.WI_ID
		WHERE s.PARENT_WORK_ITEM_ID = c.PARENT_WORK_ITEM_ID) purging
	WHERE actual.CNT != purging.CNT
	
	-- Update all child DELETE_IN flag to N if the parent DELETE_IN flag is set to 'N'
	-- 0
	UPDATE child
	SET DELETE_IN = 'N'
	--  select child.*
	FROM #AllWorkItemIds AS parent
	JOIN SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE AS r
		ON r.PARENT_WORK_ITEM_ID = parent.WI_ID
	JOIN #AllWorkItemIds AS child
		ON r.WORK_ITEM_ID = child.WI_ID
	WHERE parent.DELETE_IN = 'N'

	/********************                    WORK_ITEM_PROCESS_LOG_ITEM_RELATE                       ******************/                

	IF OBJECT_ID('tempdb.dbo.#WorkItemProcessLogItemRelateIds') IS NOT NULL
		DROP TABLE #WorkItemProcessLogItemRelateIds

	IF OBJECT_ID('tempdb.dbo.#WIPLIRParentIds') IS NOT NULL
		DROP TABLE #WIPLIRParentIds

	-- Get the parent workitemIds from WORK_ITEM_PROCESS_LOG_ITEM_RELATE table that are not in the #AllWorkItemIds, 
	-- These workitems should not be deleted (The count should be 0 because there are no rows that have PARENT_WORK_ITEM_ID after 2017)
	-- 0
	SELECT
		WIPLIR.PARENT_WORK_ITEM_ID 
	INTO #WIPLIRParentIds
	FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE AS WIPLIR
	LEFT JOIN #AllWorkItemIds AS AWII1
		ON AWII1.WI_ID = WIPLIR.PARENT_WORK_ITEM_ID
	WHERE WIPLIR.PARENT_WORK_ITEM_ID IS NOT NULL
	AND AWII1.WI_ID IS NULL

	-- Do Not delete Children if the Parent is Not in #AllWorkItemIds
	-- 0
	UPDATE a
	SET DELETE_IN = 'N'
	FROM #AllWorkItemIds a
	JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE AS s
		ON a.WI_ID = s.WORK_ITEM_ID
	JOIN #WIPLIRParentIds p
		ON s.PARENT_WORK_ITEM_ID = p.PARENT_WORK_ITEM_ID
		
	-- Do Not delete Parents where Child is Not in #AllWorkItemIds
	-- 0
	UPDATE a
	SET DELETE_IN = 'N'
	--SELECT  a.*, actual.CNT, purging.CNT
	FROM #AllWorkItemIds a
	CROSS APPLY (SELECT DISTINCT
			s.PARENT_WORK_ITEM_ID
		   ,s.WORK_ITEM_ID
		FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE s
		WHERE a.WI_ID = s.PARENT_WORK_ITEM_ID) s
	CROSS APPLY (SELECT
			COUNT(DISTINCT c.WORK_ITEM_ID) CNT
		FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE c
		WHERE s.PARENT_WORK_ITEM_ID = c.PARENT_WORK_ITEM_ID) actual
	CROSS APPLY (SELECT
			COUNT(DISTINCT c.WORK_ITEM_ID) CNT
		FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE c
		JOIN #AllWorkItemIds a
			ON c.WORK_ITEM_ID = a.WI_ID
		WHERE s.PARENT_WORK_ITEM_ID = c.PARENT_WORK_ITEM_ID) purging
	WHERE actual.CNT != purging.CNT

	-- Cannot delete the children if the parent is not getting deleted  
	UPDATE child
	SET DELETE_IN = 'N'
	FROM #AllWorkItemIds AS parent
	JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE AS r
		ON r.PARENT_WORK_ITEM_ID = parent.WI_ID
	JOIN #AllWorkItemIds AS child
		ON r.WORK_ITEM_ID = child.WI_ID
	WHERE parent.DELETE_IN = 'N'

	
	IF OBJECT_ID('tempdb.dbo.#WorkItemsRetained') IS NOT NULL
    	DROP TABLE #WorkItemsRetained
    GO
    
    SELECT 
		ID 
	INTO #WorkItemsRetained
	FROM WORK_ITEM AS WI 
		JOIN #AllWorkItemIds AS AWII1 ON AWII1.WI_ID = WI.ID AND AWII1.DELETE_IN = 'N'

	INSERT INTO #WorkItemsRetained
	SELECT
		ID 
	FROM 
		WORK_ITEM AS WI
		LEFT JOIN #AllWorkItemIds AS AWII1 ON AWII1.WI_ID = WI.ID
	WHERE AWII1.WI_ID IS NULL
	
	-- 37,721,342
	SELECT 'WORK_ITEM', COUNT(WI_ID) FROM #AllWorkItemIds AS AWII WHERE AWII.DELETE_IN = 'Y'

	-- 2,643,250
	SELECT 'WORK_ITEMS RETAINED', COUNT(*) FROM #WorkItemsRetained AS WIR
	
	DROP TABLE #SubParentIds
	DROP TABLE #WIPLIRParentIds

	/*****************************************************************************************************************
	********************				SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE					******************			
	*****************************************************************************************************************/
	
	IF OBJECT_ID('tempdb.dbo.#SubWorkItemBusinessObjectItemRelateIds') IS NOT NULL
		DROP TABLE #SubWorkItemBusinessObjectItemRelateIds

	-- Get all SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE where both WORK_ITEM_ID and PARENT_WORK_ITEM_ID are in #AllWorkItemIds and have DELETE_IN flag set to 'Y'
	-- 1,234,138
	SELECT
		SWIBOIR.ID
	INTO #SubWorkItemBusinessObjectItemRelateIds
	FROM SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE AS SWIBOIR
	JOIN #AllWorkItemIds AS AWII
		ON SWIBOIR.WORK_ITEM_ID = AWII.WI_ID
			AND AWII.DELETE_IN = 'Y'
	JOIN #AllWorkItemIds AS PAWII
		ON SWIBOIR.PARENT_WORK_ITEM_ID = PAWII.PARENT_ID
			AND PAWII.DELETE_IN = 'Y'
	
	-- 1,236,146
	SELECT 'SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE', COUNT(ID) FROM #SubWorkItemBusinessObjectItemRelateIds AS SWIBOIRI

	-- 209,410
	SELECT 'SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE - RETAINED', COUNT(a.ID) 
	FROM SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE a 
	LEFT JOIN #SubWorkItemBusinessObjectItemRelateIds AS SWIBOIRI 
		ON a.ID = SWIBOIRI.ID 
	WHERE SWIBOIRI.ID IS NULL
	
	DROP TABLE #SubWorkItemBusinessObjectItemRelateIds
	
	/*****************************************************************************************************************
	********************					WORK_ITEM_PROCESS_LOG_ITEM_RELATE						******************			
	*****************************************************************************************************************/


set IDENTITY_INSERT #WorkItemProcessLogItemRelateIds ON 
	
	IF OBJECT_ID('tempdb.dbo.#WorkItemProcessLogItemRelateIds', 'U') IS NOT NULL
		DROP TABLE #WorkItemProcessLogItemRelateIds

	-- Get all WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR whose WORK_ITEM_ID IS NULL AND PARENT_WORK_ITEM_ID IS NULL and UPDATE_DT < 6 months old
	-- 0
		SELECT
			WIPLIR.ID
		INTO #WorkItemProcessLogItemRelateIds
		FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE AS WIPLIR
		WHERE WIPLIR.WORK_ITEM_ID IS NULL
		AND WIPLIR.PARENT_WORK_ITEM_ID IS NULL
		AND WIPLIR.UPDATE_DT < CONVERT( DATE, DATEADD(MONTH, -6, GETDATE()), 101)

	-- 58,643,523
	INSERT INTO #WorkItemProcessLogItemRelateIds
		-- Get all WORK_ITEM_PROCESS_LOG_ITEM_RELATEs where PARENT_WORK_ITEM_ID is not null and both work_item_id and parent_work_item_id are in the #AllWorkItemIds table
		SELECT
			WIPLIR.ID
		FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE AS WIPLIR
		JOIN #AllWorkItemIds AS AWII
			ON AWII.WI_ID = WIPLIR.WORK_ITEM_ID
				AND AWII.DELETE_IN = 'Y'
		JOIN #AllWorkItemIds AS PAWII
			ON PAWII.WI_ID = WIPLIR.PARENT_WORK_ITEM_ID
				AND WIPLIR.PARENT_WORK_ITEM_ID IS NOT NULL
				AND PAWII.DELETE_IN = 'Y'
		UNION
		-- Get all WORK_ITEM_PROCESS_LOG_ITEM_RELATEs where PARENT_WORK_ITEM_ID is null and work_item_id is in #AllWorkItemIds.
		SELECT
			WIPLIR.ID
		FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE AS WIPLIR
		JOIN #AllWorkItemIds AS AWII
			ON AWII.WI_ID = WIPLIR.WORK_ITEM_ID
				AND AWII.DELETE_IN = 'Y'
		WHERE WIPLIR.PARENT_WORK_ITEM_ID IS NULL
		
	-- 58,973,304
	SELECT 'WORK_ITEM_PROCESS_LOG_ITEM_RELATE', COUNT(ID) FROM #WorkItemProcessLogItemRelateIds AS WIPLIRI

	-- 11,777,796
	SELECT 'WORK_ITEM_PROCESS_LOG_ITEM_RELATE - RETAINED', COUNT(a.ID) 
	FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE a 
	LEFT JOIN #WorkItemProcessLogItemRelateIds AS WIPLIRI ON WIPLIRI.ID = a.ID 
	WHERE WIPLIRI.ID IS NULL
	
	DROP TABLE #WorkItemProcessLogItemRelateIds
	
	/*****************************************************************************************************************
	********************							WORK_QUEUE_WORK_ITEM_RELATE						******************			
	*****************************************************************************************************************/
	IF OBJECT_ID('tempdb.dbo.#WorkQueueWorkItemRelateIds') IS NOT NULL
    	DROP TABLE #WorkQueueWorkItemRelateIds
    GO
    
	-- Get all WORK_QUEUE_WORK_ITEM_RELATE that are related to the workitem ids in #WorkItemIds table
	
	SELECT
		WQWIR.ID
	INTO #WorkQueueWorkItemRelateIds
	FROM #AllWorkItemIds AS  WI
	JOIN WORK_QUEUE_WORK_ITEM_RELATE AS WQWIR
		ON WI.WI_ID = WQWIR.WORK_ITEM_ID

	-- 57,675,799
	SELECT 'WORK_QUEUE_WORK_ITEM_RELATE', COUNT(ID) FROM #WorkQueueWorkItemRelateIds AS WQWIRI

	-- 5,674,745
	SELECT 'WORK_QUEUE_WORK_ITEM_RELATE - RETAINED', COUNT(a.ID) FROM WORK_QUEUE_WORK_ITEM_RELATE a LEFT JOIN #WorkQueueWorkItemRelateIds AS WQWIRI ON WQWIRI.ID = a.ID WHERE WQWIRI.ID IS NULL
	
	DROP TABLE #WorkQueueWorkItemRelateIds
	/*****************************************************************************************************************
	********************							WORK_ITEM_ACTION								******************			
	*****************************************************************************************************************/
	IF OBJECT_ID('tempdb.dbo.#WorkItemActionIds') IS NOT NULL
		DROP TABLE #WorkItemActionIds

	-- Get all WORK_ITEM_ACTION that are related to the workitem ids in #WorkItemIds table
	SELECT
		WIA.ID
	INTO #WorkItemActionIds
	FROM #AllWorkItemIds AS WI
	JOIN WORK_ITEM_ACTION AS WIA
		ON WIA.WORK_ITEM_ID = WI.WI_ID

	-- 76,905,239
	SELECT 'WORK_ITEM_ACTION', COUNT(ID) FROM #WorkItemActionIds AS WIAI

	-- 6,221,403
	SELECT 'WORK_ITEM_ACTION - RETAINED', COUNT(a.ID) FROM WORK_ITEM_ACTION a LEFT JOIN #WorkItemActionIds AS WIAI ON WIAI.ID = a.ID WHERE WIAI.ID IS NULL
	
	DROP TABLE #WorkItemActionIds
	/*****************************************************************************************************************
	********************							QUALITY_CONTROL_ITEM							******************			
	*****************************************************************************************************************/

	
	-- get all QUALITY_CONTROL_ITEMs that are related to the workitem
	-- QA -
	
	
	SELECT
		WI.RELATE_ID AS ID
	INTO #QualityControlItemIds
	FROM #AllWorkItemIds AS WI
	WHERE WI.RELATE_TYPE_CD = 'Allied.UniTrac.QualityControlItem'

	-- 1022
	SELECT 'QUALITY_CONTROL_ITEM', COUNT(ID) FROM #QualityControlItemIds AS QCII
	-- 43185
	SELECT 'QUALITY_CONTROL_ITEM -  RETAINED', COUNT(QCI.ID) FROM QUALITY_CONTROL_ITEM QCI LEFT JOIN #QualityControlItemIds AS QCII ON QCII.ID = QCI.ID WHERE QCII.ID IS NULL
	
	DROP TABLE #QualityControlItemIds
	/*****************************************************************************************************************
	********************							Drop TempTables									******************			
	*****************************************************************************************************************/

	DROP TABLE #AllWorkItemIds

PRINT '----------------------------------------------------------------- Verification script for MESSAGE section -----------------------------------------------------------------------------'

	-- Temp Table for Inbound MESSAGE
	CREATE TABLE #delInboundMessageTempTable (ID BIGINT NOT NULL )
	
	-- Temp Table for Both Inbound and Outbound MESSAGE
	CREATE TABLE #delMessageTempTable (ID BIGINT NOT NULL)
	
	-- Temp Table for DOCUMENT
	CREATE TABLE #delDocumentTempTable (ID BIGINT NOT NULL)
	
/********************************************************************************************************************
********						Get INBOUND MESSAGES over Retention Period									*********
********************************************************************************************************************/

	-- 6,103,018
	INSERT INTO #delInboundMessageTempTable (ID)
		SELECT
		   M.ID
		FROM [MESSAGE] AS M
			INNER JOIN DBO.TRADING_PARTNER TP
			ON TP.ID=M.RECEIVED_FROM_TRADING_PARTNER_ID
			CROSS APPLY (SELECT * FROM RETENTION_PERIOD_BY_TABLE AS RPBT WHERE RPBT.TABLE_NAME = 'MESSAGE') a
		WHERE (M.UPDATE_DT < CONVERT(DATE, DATEADD(MONTH,a.RETENTION_PERIOD_IN_MONTHS, GETDATE()),101)
		OR M.PURGE_DT IS NOT NULL)
		AND M.MESSAGE_DIRECTION_CD = 'I'
		AND TP.TYPE_CD <> 'LFP_TP'

	-- Copy the Inbound Messages to #delMessageTempTable 
	INSERT INTO #delMessageTempTable (ID)
		SELECT
			ID
		FROM #delInboundMessageTempTable M

/********************************************************************************************************************
********							Get OUTBOUND MESSAGES over Retention Period								*********
********************************************************************************************************************/

	-- 6,103,957
	INSERT INTO #delMessageTempTable (ID)
		SELECT
		   M.ID
		FROM MESSAGE AS M
		INNER JOIN DBO.TRADING_PARTNER TP
			ON TP.ID=M.RECEIVED_FROM_TRADING_PARTNER_ID
		JOIN #delInboundMessageTempTable AS MTT
			ON MTT.ID = M.RELATE_ID_TX AND M.MESSAGE_DIRECTION_CD = 'O'
				AND M.RELATE_TYPE_CD = 'MESSAGE'
		WHERE TP.TYPE_CD <> 'LFP_TP'

	-- 12,234,152
	SELECT 'MESSAGE', COUNT(*) FROM #delMessageTempTable AS MTT

	-- 4,028,196
	SELECT 'MESSAGE - RETAINED', COUNT(*) FROM MESSAGE M LEFT JOIN #delMessageTempTable AS MTT ON MTT.ID = M.ID WHERE MTT.ID IS NULL

/********************************************************************************************************************
********			Get PROCESS_LOG_ITEM related to the MESSAGES that will be purged			*********
********************************************************************************************************************/

		-- 1241
		SELECT
		 'PROCESS_LOG_ITEM', COUNT(PLI.ID)
		FROM #delMessageTempTable D
		JOIN PROCESS_LOG_ITEM AS PLI ON PLI.RELATE_ID = D.ID AND PLI.RELATE_TYPE_CD = 'LDHLib.Message'

		-- 977
		SELECT
		 'PROCESS_LOG_ITEM - RETAINED', COUNT(PLI.ID)
		FROM PROCESS_LOG_ITEM AS PLI
			JOIN MESSAGE M ON PLI.RELATE_ID = M.ID AND PLI.RELATE_TYPE_CD = 'LDHLib.Message'
			LEFT JOIN #delMessageTempTable AS MTT ON MTT.ID = M.ID
		WHERE MTT.ID IS NULL
		

/********************************************************************************************************************
********				Get TRADING_PARTNER_LOG related to the MESSAGES that will be purged					*********
********************************************************************************************************************/
	
		-- 54,344,219
		SELECT
		  'TRADING_PARTNER_LOG', COUNT(TPL.ID)
		FROM dbo.TRADING_PARTNER_LOG TPL
		INNER JOIN #delMessageTempTable OTT
			ON OTT.ID = TPL.MESSAGE_ID

		-- 13,420,043
		SELECT
		  'TRADING_PARTNER_LOG - RETAINED', COUNT(TPL.ID)
		FROM dbo.TRADING_PARTNER_LOG TPL
		JOIN MESSAGE M ON TPL.MESSAGE_ID = M.ID
		LEFT JOIN #delMessageTempTable OTT
			ON OTT.ID = M.ID
		WHERE OTT.ID IS NULL

/********************************************************************************************************************
********						Get DOCUMENTs related to the MESSAGES that will be purged					*********
********************************************************************************************************************/
	
	-- 23,719,036
	INSERT INTO #delDocumentTempTable (ID)
		SELECT
			D.ID
		FROM dbo.DOCUMENT D
		INNER JOIN #delMessageTempTable OTT
			ON OTT.ID = D.MESSAGE_ID

	-- 23,750,429
	SELECT 'DOCUMENT', COUNT(*) FROM #delDocumentTempTable AS DTT

	-- 4,379,256
	SELECT 'DOCUMENT - RETAINED',  COUNT(*) 
	FROM DOCUMENT D  
	JOIN MESSAGE M ON M.ID = D.MESSAGE_ID 
	LEFT JOIN #delMessageTempTable AS MTT ON MTT.ID = M.ID
	WHERE MTT.ID IS NULL

/********************************************************************************************************************
********					Get TRANSACTIONs related to the MESSAGES that will be purged					*********
********************************************************************************************************************/
	
	-- 234,392,472
	SELECT
		'TRANSACTION', COUNT(T.ID)
	FROM dbo.[TRANSACTION] T
	INNER JOIN #delDocumentTempTable OTT
		ON OTT.ID = T.DOCUMENT_ID

	-- 44,363,810
	SELECT
		'TRANSACTION - RETAINED', COUNT(T.ID)
	FROM dbo.[TRANSACTION] T
	INNER JOIN DOCUMENT D
		ON D.ID = T.DOCUMENT_ID
	LEFT JOIN #delDocumentTempTable AS DTT
		ON DTT.ID = D.ID
	WHERE DTT.ID IS NULL

/********************************************************************************************************************
********						Get BLOBs related to the MESSAGES that will be purged						*********
********************************************************************************************************************/
	
	-- 28,038,730
	SELECT
		'BLOB', COUNT(B.ID)
	FROM dbo.BLOB B
	INNER JOIN #delDocumentTempTable OTT
		ON OTT.ID = B.RELATE_ID_TX
			AND B.RELATE_TYPE_CD = 'DOCUMENT'

	-- 6,747,943
	SELECT
		'BLOB - RETAINED', COUNT(B.ID)
	FROM dbo.BLOB B
	INNER JOIN DOCUMENT D 
		ON D.ID = B.RELATE_ID_TX AND B.RELATE_TYPE_CD = 'DOCUMENT'
	LEFT JOIN #delDocumentTempTable OTT
		ON OTT.ID = D.ID
	WHERE OTT.ID IS NULL

/********************************************************************************************************************
********					Get	RELATED_DATAs related to the MESSAGES that will be purged					*********
********************************************************************************************************************/
	
	-- 19,650,176	
	SELECT
		'RELATED_DATA - MESSAGE', COUNT(RD.ID)
	FROM RELATED_DATA AS RD
	JOIN RELATED_DATA_DEF AS RDD
		ON RD.DEF_ID = RDD.ID
			AND RDD.RELATE_CLASS_NM = 'Message'
	JOIN #delMessageTempTable AS MTT
		ON MTT.ID = RD.RELATE_ID

	-- 7,667,783	
	SELECT
		'RELATED_DATA - MESSAGE RETAINED', COUNT(RD.ID)
	FROM RELATED_DATA AS RD
	JOIN RELATED_DATA_DEF AS RDD
		ON RD.DEF_ID = RDD.ID
			AND RDD.RELATE_CLASS_NM = 'Message'
	LEFT JOIN #delMessageTempTable AS MTT
		ON MTT.ID = RD.RELATE_ID
	WHERE MTT.ID IS NULL

/********************************************************************************************************************
********					Get	RELATED_DATAs related to the DOCUMENTs that will be purged					*********
********************************************************************************************************************/
	
	-- 8,029,846
	SELECT
		'RELATED_DATA - DOCUMENT', COUNT(RD.ID)
	FROM RELATED_DATA AS RD
	JOIN RELATED_DATA_DEF AS RDD
		ON RD.DEF_ID = RDD.ID
			AND RDD.RELATE_CLASS_NM = 'Document'
	JOIN #delDocumentTempTable AS DTT
		ON DTT.ID = RD.RELATE_ID

	-- 930,590
	SELECT
		'RELATED_DATA - DOCUMENT - RETAINED', COUNT(RD.ID)
	FROM RELATED_DATA AS RD
	JOIN RELATED_DATA_DEF AS RDD
		ON RD.DEF_ID = RDD.ID
			AND RDD.RELATE_CLASS_NM = 'Document'
	LEFT JOIN #delDocumentTempTable AS DTT
		ON DTT.ID = RD.RELATE_ID
	WHERE DTT.ID IS NULL

	DROP TABLE #delInboundMessageTempTable 
	DROP TABLE #delMessageTempTable 
	DROP TABLE #delDocumentTempTable 



PRINT '-------------------------------------------------------------- Verification script for PROCESS_LOG with No Workitem Relate section ------------------------------------------------------------------------'

/********************************************************************************************************************
********							Get	PROCESS_LOGS with not Related Workitems								*********
********************************************************************************************************************/
		
	-- 51,172,327
	SELECT
		PL.ID INTO #ProcessLogIdsWithNoWorkItemRelate
	FROM PROCESS_DEFINITION AS PD
	JOIN RETENTION_PERIOD_PROCESS_LOG_NO_WORKITEM AS RPPLNW
		ON RPPLNW.PROCESS_DEF_TYPE_CD = PD.PROCESS_TYPE_CD
	JOIN PROCESS_LOG AS PL
		ON PD.ID = PL.PROCESS_DEFINITION_ID
	WHERE PL.UPDATE_DT < CONVERT(DATE, DATEADD(MONTH, RPPLNW.RETENTION_PERIOD_IN_MONTHS, GETDATE()),101)

	-- ProcessLogs that should be retained
	SELECT
		PL.ID INTO #ProcessLogIdsWithNoWorkItemRelateRetained
	FROM PROCESS_DEFINITION AS PD
	JOIN RETENTION_PERIOD_PROCESS_LOG_NO_WORKITEM AS RPPLNW
		ON RPPLNW.PROCESS_DEF_TYPE_CD = PD.PROCESS_TYPE_CD
	JOIN PROCESS_LOG AS PL
		ON PD.ID = PL.PROCESS_DEFINITION_ID
	WHERE PL.UPDATE_DT >= CONVERT(DATE, DATEADD(MONTH, RPPLNW.RETENTION_PERIOD_IN_MONTHS, GETDATE()),101)

	-- 8,065,874
	SELECT 
		'PROCESS_LOG_ITEM', COUNT(*)
	FROM 
		PROCESS_LOG_ITEM
	JOIN #ProcessLogIdsWithNoWorkItemRelate AS PLIWNWIR ON PROCESS_LOG_ID = PLIWNWIR.ID

	-- 591,063
	SELECT 
		'PROCESS_LOG_ITEM - RETAINED', COUNT(*)
	FROM 
		PROCESS_LOG_ITEM
	JOIN #ProcessLogIdsWithNoWorkItemRelateRetained AS PLIWNWIR ON PROCESS_LOG_ID = PLIWNWIR.ID


	-- 51,201,663
	SELECT 
		'PROCESS_LOG', COUNT(*)
	FROM 
		#ProcessLogIdsWithNoWorkItemRelate AS PL

	-- 1,977,600
	SELECT 
		'PROCESS_LOG - RETAINED', COUNT(*)
	FROM 
		#ProcessLogIdsWithNoWorkItemRelateRetained AS PL

	DROP TABLE #ProcessLogIdsWithNoWorkItemRelate
	DROP TABLE #ProcessLogIdsWithNoWorkItemRelateRetained

PRINT '--------------------------------------------------------------- Verification script for PROCESS_LOG with Workitem Relate section ----------------------------------------------------------------------------'

	CREATE TABLE #ProcessTypesAndRetentionPeriods
	(
		PROCESS_TYPE_CD NVARCHAR(50) NOT NULL,
		RETENTION_PERIOD_IN_MONTHS SMALLINT NOT NULL
	)

	CREATE TABLE #ProcessLogIdsByProcessTypeByRP 
	(
		ID BIGINT NOT NULL, 
		PROCESS_DEFINITION_ID BIGINT NOT NULL,
		DELETE_IN CHAR(1) DEFAULT('Y')
	)

	CREATE TABLE #ProcessLogIdsByProcessTypeByRPRetained 
	(
		ID BIGINT NOT NULL, 
		PROCESS_DEFINITION_ID BIGINT NOT NULL,
	)
	
	/*********************************************************************************************************
	*******						Get RetentionPeriods for each ProcessTypeCode							******
	*********************************************************************************************************/

	INSERT INTO #ProcessTypesAndRetentionPeriods 
		SELECT 
			RPPLWM.PROCESS_DEF_TYPE_CD, 
			RPW.RETENTION_PERIOD_IN_MONTHS 
		FROM RETENTION_PERIOD_PROCESS_LOG_WORKITEM_MAP AS RPPLWM 
			JOIN RETENTION_PERIOD_WORKITEM AS RPW 
				ON RPPLWM.WORKFLOW_TYPE_CD = RPW.WORKFLOW_TYPE_CD

	/************************************************************************************************************
	*******					Get all PROCESS_LOGS by PROCESS_TYPE_CD and RetentionPeriod					  *******
	************************************************************************************************************/

	-- 9,991,810
	INSERT INTO #ProcessLogIdsByProcessTypeByRP(ID, PROCESS_DEFINITION_ID)
		SELECT
			PL.ID
			,PD.ID AS PROCESS_DEFINITION_ID 
		FROM PROCESS_DEFINITION AS PD
		JOIN PROCESS_LOG AS PL 
			ON PD.ID = PL.PROCESS_DEFINITION_ID
		JOIN #ProcessTypesAndRetentionPeriods AS PTARP ON PTARP.PROCESS_TYPE_CD = PD.PROCESS_TYPE_CD
		WHERE  PL.UPDATE_DT < CONVERT(DATE, DATEADD(MONTH, PTARP.RETENTION_PERIOD_IN_MONTHS, GETDATE()), 101)

	INSERT INTO #ProcessLogIdsByProcessTypeByRPRetained(ID, PROCESS_DEFINITION_ID)
		SELECT
			PL.ID
			,PD.ID AS PROCESS_DEFINITION_ID 
		FROM PROCESS_DEFINITION AS PD
		JOIN PROCESS_LOG AS PL 
			ON PD.ID = PL.PROCESS_DEFINITION_ID
		JOIN #ProcessTypesAndRetentionPeriods AS PTARP ON PTARP.PROCESS_TYPE_CD = PD.PROCESS_TYPE_CD
		WHERE  PL.UPDATE_DT >= CONVERT(DATE, DATEADD(MONTH, PTARP.RETENTION_PERIOD_IN_MONTHS, GETDATE()), 101)

	/************************************************************************************************************
	*****	Update the DeleteIn to 'N' of ProcessLogIds from #ProcessLogIdsByProcessTypeByRP which still   ******
	*****				have the workitem related through PROCESS_LOG_ITEM.RELATE_ID					   ******
	************************************************************************************************************/
		
	UPDATE t
	SET DELETE_IN = 'N'
	FROM #ProcessLogIdsByProcessTypeByRP t
	JOIN PROCESS_LOG_ITEM pli 
		ON t.ID = pli.PROCESS_LOG_ID  
		and (pli.RELATE_TYPE_CD like 'Osprey.Workflow.%' or pli.RELATE_TYPE_CD like 'Allied.UniTrac.Workflow.%')
	JOIN WORK_ITEM AS WI 
		ON WI.ID = PLI.RELATE_ID

	/************************************************************************************************************
	*****	Update the DeleteIn to 'N' of ProcessLogIds from #ProcessLogIdsByProcessTypeByRP which still	*****
	*****	have the workitem related through WORK_ITEM_PROCESS_LOG_ITEM_RELATE.PROCESS_LOG_ITEM_ID table	*****
	************************************************************************************************************/
		
	UPDATE t
	SET DELETE_IN = 'N'
	FROM #ProcessLogIdsByProcessTypeByRP t 
	JOIN PROCESS_LOG_ITEM AS PLI 
		ON t.ID = PLI.PROCESS_LOG_ID
	JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE AS WIPLIR 
		ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID

	/************************************************************************************************************
	*****	Update the DeleteIn to 'N' of ProcessLogIds from #ProcessLogIdsByProcessTypeByRP which still    *****
	*****   have the workitem related directly through WORK_ITEM.RELATE_ID and RELATE_TYPE_CD				*****
	*****   = 'Osprey.ProcessMgr.ProcessLog'																*****
	************************************************************************************************************/
		
	UPDATE t
	SET DELETE_IN = 'N'
	FROM #ProcessLogIdsByProcessTypeByRP t
	JOIN WORK_ITEM AS WI 
		ON t.ID = WI.RELATE_ID 
		AND WI.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog'

	/****************************************************************************************************************
	*****	Update the DeleteIn to 'N' of ProcessLogIds from #ProcessLogIdsByProcessTypeByRP which still have   *****
	*****   the workitem related directly through WORK_ITEM.RELATE_ID and RELATE_TYPE_CD						*****
	*****   = 'Osprey.ProcessMgr.ProcessLogItem'																*****
	*****************************************************************************************************************/
		
	UPDATE t
	SET DELETE_IN = 'N'
	FROM #ProcessLogIdsByProcessTypeByRP t
	JOIN PROCESS_LOG_ITEM AS PLI 
		ON PLI.PROCESS_LOG_ID = t.ID
	JOIN WORK_ITEM AS WI 
		ON PLI.ID = WI.RELATE_ID 
		AND WI.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLogItem'

	/****************************************************************************************************************
	*****	Update the DeleteIn to 'N' of ProcessLogIds from #ProcessLogIdsByProcessTypeByRP which still have	*****
	*****   the workitem that is related through PROCESS_DEFINITION and WORK_ITEM.RELATE_ID and RELATE_TYPE_CD  *****
	*****	= 'ProcessDefinition'																				*****
	****************************************************************************************************************/
		
	UPDATE t
	SET DELETE_IN = 'N'
	FROM PROCESS_DEFINITION AS PD 
	JOIN #ProcessLogIdsByProcessTypeByRP AS t 
		ON PD.ID = t.PROCESS_DEFINITION_ID 
	JOIN WORK_ITEM AS WI 
		ON WI.RELATE_ID =  PD.ID 
		AND WI.RELATE_TYPE_CD = 'ProcessDefinition'

	/***************************************************************************************************
	***************							Drop Temp Tables							****************
	***************************************************************************************************/

	INSERT INTO #ProcessLogIdsByProcessTypeByRPRetained
	SELECT ID, PROCESS_DEFINITION_ID FROM #ProcessLogIdsByProcessTypeByRP AS PLIBPTBR WHERE PLIBPTBR.DELETE_IN = 'N'

	SELECT 'WORK_ITEM_RELATED - PROCESS_LOG', COUNT(*) FROM #ProcessLogIdsByProcessTypeByRP WHERE DELETE_IN = 'Y'

	SELECT 'WORK_ITEM_RELATED - PROCESS_LOG - RETAINED', COUNT(*) FROM #ProcessLogIdsByProcessTypeByRPRetained AS PLIBPTBR

	DROP TABLE #ProcessTypesAndRetentionPeriods
	DROP TABLE #ProcessLogIdsByProcessTypeByRP
	DROP TABLE #ProcessLogIdsByProcessTypeByRPRetained
