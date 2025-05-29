USE [QCModule]
GO

/****** Object:  StoredProcedure [dbo].[GetQCModuleResults]    Script Date: 11/19/2018 1:14:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetQCModuleResults]
(
	@qcBatchDefinitionId bigint,
	@qcBatchId bigint,
	@updateUser nvarchar(15),
	@lenderId BIGINT = 0
)
AS
BEGIN
    SET NOCOUNT ON
	
	DECLARE @cmd nvarchar(max)
	DECLARE @storedProcName nvarchar(100)
	DECLARE @paramXML XML
	DECLARE @dbName NVARCHAR(100)
	DECLARE @params NVARCHAR(MAX) = ''
	DECLARE @SPParamName NVARCHAR(50)
	DECLARE @SPParamType NVARCHAR(50)
	DECLARE @ParamValue NVARCHAR(MAX)
	DECLARE @ParamControlType NVARCHAR(MAX)
	DECLARE @DataType NVARCHAR(50)
	DECLARE @recordCount INT
	DECLARE @recordThreshold INT
   DECLARE @lastRunDate DATETIME

	--Get DB Name from system ref domain
	SELECT @dbName = MEANING_TX FROM REF_CODE WHERE DOMAIN_CD = 'System' AND CODE_CD = 'RulesDatabaseName' AND PURGE_DT IS NULL

	--Get max record threshold from system ref domain
	SELECT @recordThreshold = MEANING_TX FROM REF_CODE WHERE DOMAIN_CD = 'System' AND CODE_CD = 'RecordThreshold' AND PURGE_DT IS NULL

	--Get SP name and Proc parameters
	SELECT @storedProcName = ruleDef.PROC_NAME_TX, @paramXML = qcBatch.PARAMETERS_XML
	FROM QC_BATCH_DEFINITION qcBatch
		JOIN QC_RULE_DEFINITION ruleDef ON ruleDef.ID = qcBatch.QC_RULE_DEFINITION_ID and ruleDef.PURGE_DT IS NULL
	WHERE qcBatch.PROCESS_DEFINITION_ID = @qcBatchDefinitionId
   
   -- Get the End Date of the Last Successful Run (status is Complete)
	SELECT	@lastRunDate = ISNULL(MAX(END_DT), DATEADD(year,-1,GETDATE()))
	FROM	PROCESS_LOG PL
	WHERE	ID != @qcBatchId
			AND PROCESS_DEFINITION_ID = @qcBatchDefinitionId
			AND STATUS_CD = 'Complete'
			AND PL.PURGE_DT IS NULL

	DECLARE curParam CURSOR LOCAL FAST_FORWARD FOR
		SELECT params.list.value('(ParameterName/text())[1]', 'nvarchar(50)') SPParamName
			, params.list.value('(ParameterDataType/text())[1]', 'nvarchar(50)') SPParamType
			, params.list.value('(Value/text())[1]', 'nvarchar(max)') ParamValue
			, params.list.value('(ControlType/text())[1]', 'nvarchar(max)') ParamControlType
		FROM @paramXML.nodes('Parameters/ParameterRule') as params(list)

	OPEN curParam
	WHILE 1 = 1
	BEGIN
		FETCH curParam INTO @SPParamName, @SPParamType, @ParamValue, @ParamControlType
		IF @@fetch_status <> 0 BREAK

		IF @params != ''
			SET @params = @params + ','

		-- If the Lender ID is set and this is the Param Control Type of LenderSelector
		-- then use the passed lender Id as the ParamValue
		IF @lenderId != 0 AND @ParamControlType = 'LenderSelector'
			SET @ParamValue = cast(@lenderId as varchar(max))

		IF (@SPParamType = 'STRING')
		BEGIN
			SET @params = @params + '''''' + @ParamValue + ''''''
		END
		ELSE IF @SPParamType = 'INT'			
		BEGIN
			SET @params = @params + @ParamValue
		END
	END
	CLOSE curParam
	DEALLOCATE curParam

	CREATE TABLE #tmpData
	(
		[LENDER_ID] [bigint] NULL,
		[LENDER_CODE] [nvarchar](10) NULL,
		[LENDER_NAME] [nvarchar](100) NULL,
		[LOAN_ID] [bigint] NOT NULL,
		[NUMBER_TX] [nvarchar](18) NOT NULL,
		[FIRST_NAME_TX] [nvarchar](30) NULL,
		[MIDDLE_INITIAL_TX] [char](1) NULL,
		[LAST_NAME_TX] [nvarchar](30) NULL,
		[LOAN_CREATE_DT] [datetime] NOT NULL,
		[PROPERTY_ID] [bigint] NOT NULL,
		[PROPERTY_TYPE_CD] [nvarchar](50) NOT NULL DEFAULT ('OTH'),
		[PROPERTY_DESCRIPTION_TX] [nvarchar](100) NULL,
		[LINE_1_TX] [nvarchar](100) NULL,
		[LINE_2_TX] [nvarchar](100) NULL,
		[CITY_TX] [nvarchar](40) NULL,
		[STATE_PROV_TX] [nvarchar](30) NULL,
		[POSTAL_CODE_TX] [nvarchar](30) NULL,
		[YEAR_TX] [nvarchar](4) NULL,
		[MAKE_TX] [nvarchar](30) NULL,
		[MODEL_TX] [nvarchar](30) NULL,
		[BODY_TX] [nvarchar](40) NULL,
		[VIN_TX] [nvarchar](18) NULL,
		[REQUIRED_COVERAGE_ID] [bigint] NOT NULL,
		[REQUIRED_COVERAGE_TYPE_CD] [nvarchar](30) NOT NULL,
		[SUMMARY_STATUS_CD] [nvarchar](4) NULL,
		[SUMMARY_SUB_STATUS_CD] [nvarchar](4) NULL
	)
		
	SELECT @cmd = 'INSERT INTO #tmpData (
						  [LENDER_ID]
						  ,[LENDER_CODE]
						  ,[LENDER_NAME]
						  ,[LOAN_ID]
						  ,[NUMBER_TX]
						  ,[FIRST_NAME_TX]
						  ,[MIDDLE_INITIAL_TX]
						  ,[LAST_NAME_TX]		
						  ,[LOAN_CREATE_DT]				  
						  ,[PROPERTY_ID]
						  ,[PROPERTY_TYPE_CD]
						  ,[PROPERTY_DESCRIPTION_TX]
						  ,[LINE_1_TX]
						  ,[LINE_2_TX]
						  ,[CITY_TX]
						  ,[STATE_PROV_TX]
						  ,[POSTAL_CODE_TX]
						  ,[YEAR_TX]
						  ,[MAKE_TX]
						  ,[MODEL_TX]
						  ,[BODY_TX]
						  ,[VIN_TX]						  
						  ,[REQUIRED_COVERAGE_ID]
						  ,[REQUIRED_COVERAGE_TYPE_CD]
						  ,[SUMMARY_STATUS_CD]
						  ,[SUMMARY_SUB_STATUS_CD]) '
				+ 'exec ' + @dbName + 'GetQCUnitracResults' 
				+ ' @qcBatchDefId= ' + @qcBatchDefinitionId + ', @functionName=''' + @storedProcName + ''', @params=''' + @params + ', ''''' + convert(varchar(25), @lastRunDate, 120) + ''''''''
	Exec (@cmd)

	SELECT @recordCount = COUNT(*) FROM #tmpData

	IF @recordCount > @recordThreshold
	BEGIN
		DECLARE @msg NVARCHAR(100)
		SET @msg = 'Record count is: ' + CAST(@recordCount AS NVARCHAR) + ' which is above the threshold of ' + CAST(@recordThreshold AS NVARCHAR)
		RAISERROR (@msg, 16, 0)
	END
	ELSE IF @qcBatchId <= 0
	BEGIN
		RAISERROR ('No BatchId specified', 16, 0)
	END
	ELSE IF @qcBatchId > 0
	BEGIN
		INSERT INTO QC_BATCH_ITEM (
							[QC_BATCH_ID]
							,[LENDER_ID]
							,[LENDER_CODE]
							,[LENDER_NAME]
							,[LOAN_ID]
							,[NUMBER_TX]
							,[FIRST_NAME_TX]
							,[MIDDLE_INITIAL_TX]
							,[LAST_NAME_TX]		
							,[LOAN_CREATE_DT]				  
							,[PROPERTY_ID]
							,[PROPERTY_TYPE_CD]
							,[PROPERTY_DESCRIPTION_TX]
							,[LINE_1_TX]
							,[LINE_2_TX]
							,[CITY_TX]
							,[STATE_PROV_TX]
							,[POSTAL_CODE_TX]
							,[YEAR_TX]
							,[MAKE_TX]
							,[MODEL_TX]
							,[BODY_TX]
							,[VIN_TX]						  
							,[REQUIRED_COVERAGE_ID]
							,[REQUIRED_COVERAGE_TYPE_CD]
							,[SUMMARY_STATUS_CD]
							,[SUMMARY_SUB_STATUS_CD]
							,[CREATE_DT]
							,[UPDATE_DT]
							,[UPDATE_USER_TX]
							,[LOCK_ID]
		)
		SELECT @qcBatchId
			, LENDER_ID, LENDER_CODE, LENDER_NAME
			, LOAN_ID, NUMBER_TX
			, FIRST_NAME_TX, MIDDLE_INITIAL_TX, LAST_NAME_TX
			, LOAN_CREATE_DT
			, PROPERTY_ID, PROPERTY_TYPE_CD, PROPERTY_DESCRIPTION_TX
			, LINE_1_TX, LINE_2_TX, CITY_TX, STATE_PROV_TX, POSTAL_CODE_TX
			, YEAR_TX, MAKE_TX, MODEL_TX, BODY_TX, VIN_TX
			, REQUIRED_COVERAGE_ID, REQUIRED_COVERAGE_TYPE_CD
			, SUMMARY_STATUS_CD, SUMMARY_SUB_STATUS_CD 
			, GETDATE(), GETDATE(), @updateUser, 1
		FROM #tmpData tmp
	END

END

GO

