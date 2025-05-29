USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[fnGetInteractionHistory]    Script Date: 8/25/2021 12:17:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[fnGetInteractionHistory] (
	@Id BIGINT = NULL
	,@loanId BIGINT = NULL
	,@propertyId BIGINT = NULL
	,@typeCd NVARCHAR(100) = NULL
	,@relateClassNm NVARCHAR(100) = NULL
	,@relateId BIGINT = NULL
	,@documentId BIGINT = NULL
	,@rcId BIGINT = NULL
	,@isServiceFeeInvoiceCall VARCHAR(1) = NULL
	,@lenderId BIGINT = NULL
	,@startDate DATETIME = NULL
	,@endDate DATETIME = NULL
	,@loanIdForPropertyIdList BIGINT = NULL
	,@isLenderUnitracTxnProcessCall VARCHAR(1) = NULL
	)
RETURNS @InteractionHistory TABLE (
	[ID] [BIGINT]
	,[TYPE_CD] [NVARCHAR](15) NOT NULL
	,[ALERT_IN] [CHAR](1) NOT NULL
	,[PENDING_IN] [CHAR](1) NOT NULL
	,[IN_HOUSE_ONLY_IN] [CHAR](1) NOT NULL
	,[DELETE_ID] [BIGINT] NULL
	,[RELATE_CLASS_TX] [VARCHAR](100) NULL
	,[RELATE_ID] [BIGINT] NULL
	,[CREATE_USER_TX] [NVARCHAR](50) NOT NULL
	,[LOCK_ID] [TINYINT] NOT NULL
	,[LOAN_ID] [BIGINT] NULL
	,[PROPERTY_ID] [BIGINT] NULL
	,[TRANSACTION_ID] [BIGINT] NULL
	,[DOCUMENT_ID] [BIGINT] NULL
	,[EFFECTIVE_DT] [DATETIME] NULL
	,[EFFECTIVE_ORDER_NO] [DECIMAL](18, 2) NULL
	,[ISSUE_DT] [DATETIME] NULL
	,[NOTE_TX] [NVARCHAR](MAX) NULL
	,[SPECIAL_HANDLING_XML] [XML] NULL
	,[ARCHIVED_IN] [CHAR](1) NOT NULL
	,[UPDATE_USER_TX] [NVARCHAR](50) NOT NULL
	,[CREATE_DT] [DATETIME] NOT NULL
	,[MORE_INTERACTIONS] BIT NULL
	)
AS
BEGIN
	DECLARE @moreinteractions BIT = 0

	--IF @startDate IS NULL
	--	SET @startDate = '1950-01-01 12:39:55.428'
	--IF @endDate IS NULL
	--	SET @endDate = GETDATE()
	IF @Id = 0
		SET @Id = NULL

	IF @loanId = 0
		SET @loanId = NULL

	IF @propertyId = 0
		SET @propertyId = NULL

	IF @relateId = 0
		SET @relateId = NULL

	IF @documentId = 0
		SET @documentId = NULL

	IF @relateClassNm = ''
		SET @relateClassNm = NULL

	IF @typeCd = ''
		SET @typeCd = NULL

	IF @rcId = 0
		SET @rcId = NULL

	IF @isServiceFeeInvoiceCall = ''
		SET @isServiceFeeInvoiceCall = NULL

	IF @isLenderUnitracTxnProcessCall = ''
		SET @isLenderUnitracTxnProcessCall = NULL

	IF @isServiceFeeInvoiceCall IS NULL
		AND @isLenderUnitracTxnProcessCall IS NULL
	BEGIN
		IF @Id IS NOT NULL
			AND @propertyId IS NULL
			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM INTERACTION_HISTORY
			WHERE ID = @Id

		IF @Id IS NOT NULL
			AND @propertyId IS NOT NULL
		BEGIN
			IF @startDate IS NOT NULL
			BEGIN
				SELECT @moreinteractions = 1
				WHERE EXISTS (
						SELECT 1
						FROM dbo.INTERACTION_HISTORY
						WHERE CREATE_DT < @startDate
							AND PROPERTY_ID = @propertyId
							AND ID > @Id
							AND PURGE_DT IS NULL
						)
			END

			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY
			WHERE PROPERTY_ID = @propertyId
				AND ID > @Id
				AND PURGE_DT IS NULL
				AND (
					@startDate IS NULL
					OR (
						CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
		END
		ELSE IF @propertyId IS NOT NULL
			AND @typeCd IS NOT NULL
			AND @rcId IS NOT NULL
		BEGIN
			IF (@startDate IS NOT NULL)
			BEGIN
				SELECT @moreinteractions = 1
				WHERE EXISTS (
						SELECT 1
						FROM dbo.INTERACTION_HISTORY
						WHERE CREATE_DT < @startDate
							AND PROPERTY_ID = @propertyId
							AND PURGE_DT IS NULL
							AND TYPE_CD = @typeCd
							AND SPECIAL_HANDLING_XML.exist('/SH/RC[. eq sql:variable("@rcId")]') = 1
						)
			END

			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY
			WHERE PROPERTY_ID = @propertyId
				AND PURGE_DT IS NULL
				AND TYPE_CD = @typeCd
				AND SPECIAL_HANDLING_XML.exist('/SH/RC[. eq sql:variable("@rcId")]') = 1
				AND (
					@startDate IS NULL
					OR (
						CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
			ORDER BY EFFECTIVE_DT DESC
				,EFFECTIVE_ORDER_NO
		END
		ELSE IF @propertyId IS NOT NULL
		BEGIN
			IF (@startDate IS NOT NULL)
			BEGIN
				SELECT @moreinteractions = 1
				WHERE EXISTS (
						SELECT 1
						FROM INTERACTION_HISTORY
						WHERE CREATE_DT < @startDate
							AND PROPERTY_ID = @propertyId
							AND PURGE_DT IS NULL
						)
			END

			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY
			WHERE PROPERTY_ID = @propertyId
				AND PURGE_DT IS NULL
				AND (
					@startDate IS NULL
					OR (
						CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
			ORDER BY EFFECTIVE_DT DESC
				,EFFECTIVE_ORDER_NO
		END
		ELSE IF @loanIdForPropertyIdList IS NOT NULL
		BEGIN
			-- Get Propertys Table
			DECLARE @props AS TABLE (id BIGINT)

			INSERT INTO @props
			SELECT p.ID
			FROM dbo.COLLATERAL c
			INNER JOIN dbo.PROPERTY p ON c.PROPERTY_ID = p.ID
			WHERE c.LOAN_ID = @loanIdForPropertyIdList
				AND c.PURGE_DT IS NULL
				AND p.PURGE_DT IS NULL

			-- Get More Interactions Table
			DECLARE @moreinteractionstable AS TABLE (
				id BIGINT
				,moreinteractions BIT
				)

			-- If there is a start date, then build the More Interactions Table
			IF (@startDate IS NOT NULL)
			BEGIN
				INSERT INTO @moreinteractionstable
				SELECT P.id
					,CASE 
						WHEN isnull(mycount, 0) > 0
							THEN 1
						ELSE 0
						END AS moreinteractions
				FROM @props P
				LEFT JOIN (
					SELECT PROPERTY_ID
						,COUNT(*) AS 'mycount'
					FROM dbo.INTERACTION_HISTORY IH
					INNER JOIN @props P ON IH.PROPERTY_ID = P.id
					WHERE CREATE_DT < @startDate
						AND PURGE_DT IS NULL
					GROUP BY PROPERTY_ID
					) A ON P.id = A.PROPERTY_ID
			END

			INSERT INTO @InteractionHistory
			SELECT ih.ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,isnull(MIT.moreinteractions, 0) AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY IH
			INNER JOIN @props PROPS ON PROPS.ID = IH.PROPERTY_ID
			LEFT JOIN @moreinteractionstable MIT ON MIT.id = IH.PROPERTY_ID
			WHERE IH.PURGE_DT IS NULL
				AND (
					@startDate IS NULL
					OR (
						IH.CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
			ORDER BY IH.PROPERTY_ID ASC
				,EFFECTIVE_DT DESC
				,EFFECTIVE_ORDER_NO
		END

		IF @loanId IS NOT NULL
		BEGIN
			IF (@startDate IS NOT NULL)
			BEGIN
				SELECT @moreinteractions = 1
				WHERE EXISTS (
						SELECT 1
						FROM dbo.INTERACTION_HISTORY
						WHERE CREATE_DT < @startDate
							AND LOAN_ID = @loanId
							AND PROPERTY_ID IS NULL
							AND PURGE_DT IS NULL
						)
			END

			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY
			WHERE LOAN_ID = @loanId
				AND PROPERTY_ID IS NULL
				AND PURGE_DT IS NULL
				AND (
					@startDate IS NULL
					OR (
						CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
			ORDER BY EFFECTIVE_DT DESC
				,EFFECTIVE_ORDER_NO
		END
		ELSE IF @relateId IS NOT NULL
			AND @relateClassNm IS NOT NULL
			AND @typeCd IS NULL
		BEGIN
			IF (@startDate IS NOT NULL)
			BEGIN
				SELECT @moreinteractions = 1
				WHERE EXISTS (
						SELECT 1
						FROM dbo.INTERACTION_HISTORY
						WHERE CREATE_DT < @startDate
							AND RELATE_ID = @relateId
							AND RELATE_CLASS_TX = @relateClassNm
							AND PURGE_DT IS NULL
						)
			END

			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY
			WHERE RELATE_ID = @relateId
				AND RELATE_CLASS_TX = @relateClassNm
				AND PURGE_DT IS NULL
				AND (
					@startDate IS NULL
					OR (
						CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
			ORDER BY EFFECTIVE_DT DESC
				,EFFECTIVE_ORDER_NO
		END
		ELSE IF @relateId IS NOT NULL
			AND @relateClassNm IS NOT NULL
			AND @typeCd IS NOT NULL
		BEGIN
			IF (@startDate IS NOT NULL)
			BEGIN
				SELECT @moreinteractions = 1
				WHERE EXISTS (
						SELECT 1
						FROM dbo.INTERACTION_HISTORY
						WHERE CREATE_DT < @startDate
							AND RELATE_ID = @relateId
							AND RELATE_CLASS_TX = @relateClassNm
							AND TYPE_CD = @typeCd
							AND PURGE_DT IS NULL
						)
			END

			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY
			WHERE RELATE_ID = @relateId
				AND RELATE_CLASS_TX = @relateClassNm
				AND TYPE_CD = @typeCd
				AND PURGE_DT IS NULL
				AND (
					@startDate IS NULL
					OR (
						CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
			ORDER BY EFFECTIVE_DT DESC
				,EFFECTIVE_ORDER_NO
		END
		ELSE IF @documentId IS NOT NULL
		BEGIN
			IF (@startDate IS NOT NULL)
			BEGIN
				SELECT @moreinteractions = 1
				WHERE EXISTS (
						SELECT 1
						FROM dbo.INTERACTION_HISTORY
						WHERE CREATE_DT < @startDate
							AND DOCUMENT_ID = @documentId
							AND PURGE_DT IS NULL
						)
			END

			INSERT INTO @InteractionHistory
			SELECT ID
				,TYPE_CD
				,ALERT_IN
				,PENDING_IN
				,IN_HOUSE_ONLY_IN
				,DELETE_ID
				,RELATE_CLASS_TX
				,RELATE_ID
				,CREATE_USER_TX
				,LOCK_ID
				,LOAN_ID
				,PROPERTY_ID
				,TRANSACTION_ID
				,DOCUMENT_ID
				,EFFECTIVE_DT
				,EFFECTIVE_ORDER_NO
				,ISSUE_DT
				,NOTE_TX
				,SPECIAL_HANDLING_XML
				,ARCHIVED_IN
				,UPDATE_USER_TX
				,CREATE_DT
				,@moreinteractions AS MORE_INTERACTIONS
			FROM dbo.INTERACTION_HISTORY
			WHERE DOCUMENT_ID = @documentId
				AND PURGE_DT IS NULL
				AND (
					@startDate IS NULL
					OR (
						CREATE_DT BETWEEN @startDate
							AND @endDate
						)
					)
			ORDER BY EFFECTIVE_DT DESC
				,EFFECTIVE_ORDER_NO
		END
	END
	ELSE IF @isServiceFeeInvoiceCall IS NOT NULL
	BEGIN
		IF (@startDate IS NOT NULL)
		BEGIN
			SELECT @moreinteractions = 1
			WHERE EXISTS (
					SELECT 1
					FROM dbo.INTERACTION_HISTORY ih
					JOIN dbo.PROPERTY pr ON pr.ID = ih.PROPERTY_ID
						AND pr.PURGE_DT IS NULL
					WHERE ih.CREATE_DT < @startDate
						AND pr.LENDER_ID = @lenderId
						AND ih.PURGE_DT IS NULL
						AND ih.TYPE_CD = @typeCd
						AND ih.UPDATE_DT BETWEEN @startDate
							AND @endDate
						AND isnull(ih.SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar(10)'), 'Approve') != 'OnHold'
						AND (
							ih.SPECIAL_HANDLING_XML.value('(/SH/WebVerification)[1]', 'varchar(1)') = 'Y'
							OR ih.SPECIAL_HANDLING_XML.value('(/SH/SubResolutionCode)[1]', 'varchar(5)') in ('V', 'PV')
                     OR ih.SPECIAL_HANDLING_XML.value('(/SH/CallAttempts)[1]', 'int') > 0
	                  OR ih.SPECIAL_HANDLING_XML.value('(/SH/OutbndCallsMade)[1]', 'varchar(1)') = '1'
							)
					)
		END

		INSERT INTO @InteractionHistory
		SELECT ih.ID
			,ih.TYPE_CD
			,ih.ALERT_IN
			,ih.PENDING_IN
			,ih.IN_HOUSE_ONLY_IN
			,ih.DELETE_ID
			,ih.RELATE_CLASS_TX
			,ih.RELATE_ID
			,ih.CREATE_USER_TX
			,ih.LOCK_ID
			,ih.LOAN_ID
			,ih.PROPERTY_ID
			,ih.TRANSACTION_ID
			,ih.DOCUMENT_ID
			,ih.EFFECTIVE_DT
			,ih.EFFECTIVE_ORDER_NO
			,ih.ISSUE_DT
			,ih.NOTE_TX
			,ih.SPECIAL_HANDLING_XML
			,ih.ARCHIVED_IN
			,ih.UPDATE_USER_TX
			,ih.CREATE_DT
			,@moreinteractions AS MORE_INTERACTIONS
		FROM dbo.INTERACTION_HISTORY ih
		JOIN dbo.PROPERTY pr ON pr.ID = ih.PROPERTY_ID
			AND pr.PURGE_DT IS NULL
		WHERE pr.LENDER_ID = @lenderId
			AND ih.PURGE_DT IS NULL
			AND ih.TYPE_CD = @typeCd
			AND ih.UPDATE_DT BETWEEN @startDate AND @endDate
			AND isnull(ih.SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar(10)'), 'Approve') != 'OnHold'
			AND (
				ih.SPECIAL_HANDLING_XML.value('(/SH/WebVerification)[1]', 'varchar(1)') = 'Y'
            OR ih.SPECIAL_HANDLING_XML.value('(/SH/SubResolutionCode)[1]', 'varchar(5)') in ('V', 'PV')
            OR ih.SPECIAL_HANDLING_XML.value('(/SH/CallAttempts)[1]', 'int') > 0
            OR ih.SPECIAL_HANDLING_XML.value('(/SH/OutbndCallsMade)[1]', 'varchar(1)') = '1'
				)
			AND (
				@startDate IS NULL
				OR ih.CREATE_DT BETWEEN @startDate AND @endDate
				)
	END
	ELSE IF @isLenderUnitracTxnProcessCall IS NOT NULL
	BEGIN
		INSERT INTO @InteractionHistory
		SELECT ih.ID
			,ih.TYPE_CD
			,ih.ALERT_IN
			,ih.PENDING_IN
			,ih.IN_HOUSE_ONLY_IN
			,ih.DELETE_ID
			,ih.RELATE_CLASS_TX
			,ih.RELATE_ID
			,ih.CREATE_USER_TX
			,ih.LOCK_ID
			,ih.LOAN_ID
			,ih.PROPERTY_ID
			,ih.TRANSACTION_ID
			,ih.DOCUMENT_ID
			,ih.EFFECTIVE_DT
			,ih.EFFECTIVE_ORDER_NO
			,ih.ISSUE_DT
			,ih.NOTE_TX
			,ih.SPECIAL_HANDLING_XML
			,ih.ARCHIVED_IN
			,ih.UPDATE_USER_TX
			,ih.CREATE_DT
			,@moreinteractions AS MORE_INTERACTIONS
		FROM dbo.INTERACTION_HISTORY ih
		JOIN dbo.PROPERTY pr ON pr.ID = ih.PROPERTY_ID
			AND pr.PURGE_DT IS NULL
		LEFT OUTER JOIN dbo.LENDER_UNITRAC_TRANSACTION lut ON lut.TYPE_CD_TX = 'SENDMEMO'
			AND lut.RELATE_CLASS_ID = ih.ID
			AND lut.RELATE_CLASS_NAME_TX IN (
				'Allied.UniTrac.InteractionHistory'
				,'Allied.UniTrac.MemoInteraction'
				)
			AND lut.PURGE_DT is NULL
		WHERE pr.LENDER_ID = @lenderId
			AND ih.IN_HOUSE_ONLY_IN = 'N'
			AND ih.PURGE_DT IS NULL
			AND ih.TYPE_CD = @typeCd
			AND lut.ID IS NULL
			AND rtrim(ltrim(ih.NOTE_TX)) <> ''
			AND (
				@startDate IS NULL
				OR (
					ih.CREATE_DT BETWEEN @startDate
						AND @endDate
					)
				)
	END

	--Emulating the Rule that is in InteractionHistory.GetList
	DELETE FROM @InteractionHistory
	WHERE (TYPE_CD = 'VRFCTNEVT'
		AND LEN(SPECIAL_HANDLING_XML.value('(SH/NoticeIsApproved)[1]', 'VARCHAR(50)')) > 0
		AND SPECIAL_HANDLING_XML.value('(SH/ReviewStatus)[1]', 'VARCHAR(50)') != 'Approve')
		OR (TYPE_CD = 'NOTICE'
		AND LEN(SPECIAL_HANDLING_XML.value('(SH/NoticeIsApproved)[1]', 'VARCHAR(50)')) > 0
		AND SPECIAL_HANDLING_XML.value('(SH/NoticeIsApproved)[1]', 'VARCHAR(50)') != 'true')

	RETURN;
END
GO


