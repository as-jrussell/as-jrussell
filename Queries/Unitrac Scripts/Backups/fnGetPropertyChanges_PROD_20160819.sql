USE [UniTracArchive]
GO

/****** Object:  StoredProcedure [dbo].[GetPropertyChanges]    Script Date: 8/19/2016 3:24:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetPropertyChanges] (@PARENT_NAME_TX NVARCHAR(50) = NULL,
@PARENT_ID BIGINT = NULL,
@ENTITY_NAME_TX NVARCHAR(50) = NULL,
@ENTITY_ID BIGINT = NULL,
@USER_TX NVARCHAR(15) = NULL,
@FROM_DT DATETIME = NULL,
@TO_DT DATETIME = NULL,
@TRANS_STATUS_CD NVARCHAR(4) = NULL,
@FORMATTED_IN CHAR(1) = NULL)
AS
BEGIN
	SET NOCOUNT ON

	SET NOCOUNT ON


	CREATE TABLE #TMP_CHANGE (
		[ID] [BIGINT] NOT NULL
	,	[PARENT_NAME_TX] [VARCHAR](100) NULL
	,	[PARENT_ID] [BIGINT] NULL
	,	[ENTITY_NAME_TX] [VARCHAR](100) NULL
	,	[ENTITY_ID] [BIGINT] NULL
	,	[NOTE_TX] [NVARCHAR](MAX) NULL
	,	[DESCRIPTION_TX] [NVARCHAR](MAX) NULL
	,	[TICKET_TX] [NVARCHAR](20) NULL
	,	[USER_TX] [NVARCHAR](15) NULL
	,	[ATTACHMENT_IN] [CHAR](1) NULL
	,	[DETAILS_IN] [CHAR](1) NOT NULL
	,	[FORMATTED_IN] [CHAR](1) NOT NULL
	,	[CREATE_DT] [DATETIME] NULL
	,	[TRANS_STATUS_CD] [VARCHAR](4) NULL
	,	[TRANS_STATUS_DT] [DATETIME] NULL
	,	[LOCK_ID] [TINYINT] NOT NULL
	,	[UTL_IN] CHAR(1)
	)

	DECLARE @MIN_DATE DATETIME;

	EXEC @MIN_DATE = dbo.fnGetPropertyChangesMinDT @PARENT_NAME_TX, 
										   @PARENT_ID,
										   @ENTITY_NAME_TX, 
										   @ENTITY_ID, 
										   @USER_TX, 
										   @TRANS_STATUS_CD, 
										   @FORMATTED_IN
	
	DECLARE @PAGE_MONTH INT = NULL;
	
	SET @PAGE_MONTH = (SELECT CONVERT(INT,MEANING_TX) FROM Unitrac.dbo.REF_CODE WHERE CODE_CD = 'HistoryPageMonths' AND DOMAIN_CD = 'System')

	IF @MIN_DATE IS NOT NULL
	BEGIN
		IF @FROM_DT IS NULL
			AND @TO_DT IS NULL
		BEGIN
			INSERT INTO #TMP_CHANGE (	ID
									,	PARENT_NAME_TX
									,	PARENT_ID
									,	ENTITY_NAME_TX
									,	ENTITY_ID
									,	NOTE_TX
									,	DESCRIPTION_TX
									,	TICKET_TX
									,	USER_TX
									,	ATTACHMENT_IN
									,	DETAILS_IN
									,	FORMATTED_IN
									,	CREATE_DT
									,	TRANS_STATUS_CD
									,	TRANS_STATUS_DT
									,	LOCK_ID
									,	UTL_IN)
				SELECT
					ID
				,	PARENT_NAME_TX
				,	PARENT_ID
				,	ENTITY_NAME_TX
				,	ENTITY_ID
				,	NOTE_TX
				,	DESCRIPTION_TX
				,	TICKET_TX
				,	USER_TX
				,	ATTACHMENT_IN
				,	DETAILS_IN
				,	FORMATTED_IN
				,	CREATE_DT
				,	TRANS_STATUS_CD
				,	TRANS_STATUS_DT
				,	LOCK_ID
				,	UTL_IN
				FROM dbo.fnGetPropertyChanges(@PARENT_NAME_TX,
					@PARENT_ID,
					@ENTITY_NAME_TX,
					@ENTITY_ID,
					@USER_TX,
					@FROM_DT,
					@TO_DT,
					@TRANS_STATUS_CD,
					@FORMATTED_IN)

		END
		ELSE
		BEGIN

			WHILE @TO_DT >= @MIN_DATE
			BEGIN

				INSERT INTO #TMP_CHANGE (	ID
										,	PARENT_NAME_TX
										,	PARENT_ID
										,	ENTITY_NAME_TX
										,	ENTITY_ID
										,	NOTE_TX
										,	DESCRIPTION_TX
										,	TICKET_TX
										,	USER_TX
										,	ATTACHMENT_IN
										,	DETAILS_IN
										,	FORMATTED_IN
										,	CREATE_DT
										,	TRANS_STATUS_CD
										,	TRANS_STATUS_DT
										,	LOCK_ID
										,	UTL_IN)
					SELECT
						ID
					,	PARENT_NAME_TX
					,	PARENT_ID
					,	ENTITY_NAME_TX
					,	ENTITY_ID
					,	NOTE_TX
					,	DESCRIPTION_TX
					,	TICKET_TX
					,	USER_TX
					,	ATTACHMENT_IN
					,	DETAILS_IN
					,	FORMATTED_IN
					,	CREATE_DT
					,	TRANS_STATUS_CD
					,	TRANS_STATUS_DT
					,	LOCK_ID
					,	UTL_IN
					FROM dbo.fnGetPropertyChanges(@PARENT_NAME_TX,
						@PARENT_ID,
						@ENTITY_NAME_TX,
						@ENTITY_ID,
						@USER_TX,
						@FROM_DT,
						@TO_DT,
						@TRANS_STATUS_CD,
						@FORMATTED_IN)

				IF EXISTS (SELECT
							*
						FROM #TMP_CHANGE)
				BEGIN
					BREAK;
				END
				ELSE
				BEGIN
					SET @FROM_DT = DATEADD(MONTH, ISNULL(@PAGE_MONTH, -12), @FROM_DT);
					SET @TO_DT = DATEADD(MONTH, ISNULL(@PAGE_MONTH, -12), @TO_DT);
				END
			END


		END
	END

	
	SELECT
		tc.ID
	,	tc.PARENT_NAME_TX
	,	tc.PARENT_ID
	,	tc.ENTITY_NAME_TX
	,	tc.ENTITY_ID
	,	tc.NOTE_TX
	,	tc.DESCRIPTION_TX
	,	tc.TICKET_TX
	,	tc.USER_TX
	,	tc.ATTACHMENT_IN
	,	tc.DETAILS_IN
	,	tc.FORMATTED_IN
	,	tc.CREATE_DT
	,	tc.TRANS_STATUS_CD
	,	tc.TRANS_STATUS_DT
	,	tc.LOCK_ID
	,	UTL_IN
	FROM #TMP_CHANGE tc
	ORDER BY tc.CREATE_DT DESC

END




GO
