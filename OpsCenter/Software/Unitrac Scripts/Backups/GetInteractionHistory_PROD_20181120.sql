USE [UniTracArchive]
GO

/****** Object:  StoredProcedure [dbo].[GetInteractionHistory]    Script Date: 11/20/2018 1:44:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetInteractionHistory] (@Id BIGINT = NULL,
@loanId BIGINT = NULL,
@propertyId BIGINT = NULL,
@typeCd NVARCHAR(100) = NULL,
@relateClassNm NVARCHAR(100) = NULL,
@relateId BIGINT = NULL,
@documentId BIGINT = NULL,
@rcId BIGINT = NULL,
@isServiceFeeInvoiceCall VARCHAR(1) = NULL,
@lenderId BIGINT = NULL,
@startDate DATETIME = NULL,
@endDate DATETIME = NULL,
@loanIdForPropertyIdList bigint = NULL)
AS
BEGIN


	SET NOCOUNT ON


	CREATE TABLE #IH_HISTORY (
		[ID] [BIGINT]
	,	[TYPE_CD] [NVARCHAR](15) NOT NULL
	,	[ALERT_IN] [CHAR](1) NOT NULL
	,	[PENDING_IN] [CHAR](1) NOT NULL
	,	[IN_HOUSE_ONLY_IN] [CHAR](1) NOT NULL
	,	[DELETE_ID] [BIGINT] NULL
	,	[RELATE_CLASS_TX] [VARCHAR](100) NULL
	,	[RELATE_ID] [BIGINT] NULL
	,	[CREATE_USER_TX] [NVARCHAR](50) NOT NULL
	,	[LOCK_ID] [TINYINT] NOT NULL
	,	[LOAN_ID] [BIGINT] NULL
	,	[PROPERTY_ID] [BIGINT] NULL
	,	[DOCUMENT_ID] [BIGINT] NULL
	,	[EFFECTIVE_DT] [DATETIME] NULL
	,	[EFFECTIVE_ORDER_NO] [DECIMAL](18, 2) NULL
	,	[ISSUE_DT] [DATETIME] NULL
	,	[NOTE_TX] [NVARCHAR](MAX) NULL
	,	[SPECIAL_HANDLING_XML] [XML] NULL
	,	[ARCHIVED_IN] [CHAR](1) NOT NULL
	,	[UPDATE_USER_TX] [NVARCHAR](50) NOT NULL
	,	[CREATE_DT] [DATETIME] NOT NULL
	,	[MORE_INTERACTIONS] BIT NULL
	);

	IF @startDate IS NULL
		AND @endDate IS NULL
	BEGIN

		INSERT INTO #IH_HISTORY
			SELECT
				ID
			,	TYPE_CD
			,	ALERT_IN
			,	PENDING_IN
			,	IN_HOUSE_ONLY_IN
			,	DELETE_ID
			,	RELATE_CLASS_TX
			,	RELATE_ID
			,	CREATE_USER_TX
			,	LOCK_ID
			,	LOAN_ID
			,	PROPERTY_ID
			,	DOCUMENT_ID
			,	EFFECTIVE_DT
			,	EFFECTIVE_ORDER_NO
			,	ISSUE_DT
			,	NOTE_TX
			,	SPECIAL_HANDLING_XML
			,	ARCHIVED_IN
			,	UPDATE_USER_TX
			,	CREATE_DT
			,	MORE_INTERACTIONS
			FROM dbo.fnGetInteractionHistory(@Id,
				@loanId,
				@propertyId,
				@typeCd,
				@relateClassNm,
				@relateId,
				@documentId,
				@rcId,
				@isServiceFeeInvoiceCall,
				@lenderId,
				NULL,
				NULL,
            @loanIdForPropertyIdList)

	END
	ELSE
	BEGIN

		WHILE @startDate >= '2005-01-01'
		BEGIN
			
			INSERT INTO #IH_HISTORY
				SELECT
					ID
				,	TYPE_CD
				,	ALERT_IN
				,	PENDING_IN
				,	IN_HOUSE_ONLY_IN
				,	DELETE_ID
				,	RELATE_CLASS_TX
				,	RELATE_ID
				,	CREATE_USER_TX
				,	LOCK_ID
				,	LOAN_ID
				,	PROPERTY_ID
				,	DOCUMENT_ID
				,	EFFECTIVE_DT
				,	EFFECTIVE_ORDER_NO
				,	ISSUE_DT
				,	NOTE_TX
				,	SPECIAL_HANDLING_XML
				,	ARCHIVED_IN
				,	UPDATE_USER_TX
				,	CREATE_DT
				,	MORE_INTERACTIONS
				FROM dbo.fnGetInteractionHistory(@Id,
					@loanId,
					@propertyId,
					@typeCd,
					@relateClassNm,
					@relateId,
					@documentId,
					@rcId,
					@isServiceFeeInvoiceCall,
					@lenderId,
					@startDate,
					@endDate,
               @loanIdForPropertyIdList)

			IF EXISTS (SELECT
						*
					FROM #IH_HISTORY ih)
			BEGIN
				BREAK;
			END
			ELSE
			BEGIN
				SET @startDate = DATEADD(yy, -1, @startDate);
			END
		END
	END


	SELECT
		ih.ID
	,	ih.TYPE_CD
	,	ih.ALERT_IN
	,	ih.PENDING_IN
	,	ih.IN_HOUSE_ONLY_IN
	,	ih.DELETE_ID
	,	ih.RELATE_CLASS_TX
	,	ih.RELATE_ID
	,	ih.CREATE_USER_TX
	,	ih.LOCK_ID
	,	ih.LOAN_ID
	,	ih.PROPERTY_ID
	,	ih.DOCUMENT_ID
	,	ih.EFFECTIVE_DT
	,	ih.EFFECTIVE_ORDER_NO
	,	ih.ISSUE_DT
	,	ih.NOTE_TX
	,	ih.SPECIAL_HANDLING_XML
	,	ih.ARCHIVED_IN
	,	ih.UPDATE_USER_TX
	,	ih.CREATE_DT
	,	ih.MORE_INTERACTIONS
	FROM #IH_HISTORY ih

END






GO

