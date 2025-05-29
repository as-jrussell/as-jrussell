USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetEscrowContainers]    Script Date: 6/27/2019 1:05:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetEscrowContainers] 
(
	@processLogId BIGINT = NULL,
	@tranStatusCode VARCHAR(10) = NULL,
	@lenderId BIGINT = NULL,
	@tradingPartnerId BIGINT = NULL,
	@controlNumber NVARCHAR(50) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	declare @moreinteractions bit = 0

	CREATE TABLE #TMP_FINAL
	(
		EscrowId BIGINT,
		InteractionHistoryId BIGINT
	)

	IF @controlNumber = ''
		SET @controlNumber = NULL

	IF @processLogId IS NOT NULL
		AND @tranStatusCode IS NOT NULL
	BEGIN
	        
		SELECT
			esc.Id AS EscrowId 
		INTO #TMP_ESCROW1
		FROM ESCROW esc
			JOIN PROCESS_LOG_ITEM PLI ON PLI.RELATE_ID = esc.ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Escrow' AND PLI.PURGE_DT IS NULL
		WHERE PLI.PROCESS_LOG_ID = @processLogId
		AND esc.TRAN_STATUS_CD = @tranStatusCode AND
		esc.PURGE_DT IS NULL
		AND PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(10)') = @tranStatusCode
		AND (@controlNumber IS NULL OR (@controlNumber IS NOT NULL AND esc.CONTROL_NUMBER_TX = @controlNumber))

		SELECT
			ih.RELATE_ID															AS EscrowId
			,ih.Id																	AS InteractionHistoryId
			,ih.SPECIAL_HANDLING_XML.value('(SH/TradingPartnerId)[1]', 'BigInt')	AS TradingPartnerId
			,ih.SPECIAL_HANDLING_XML.value('(SH/TransactionId)[1]', 'BigInt')		AS TransactionId 
		INTO #TMP_IH1
		FROM dbo.INTERACTION_HISTORY ih
			JOIN #TMP_ESCROW1 tmpEscrow ON ih.RELATE_ID = tmpEscrow.EscrowId AND ih.RELATE_CLASS_TX = 'Allied.Unitrac.Escrow'
				AND ih.TYPE_CD = 'ESCROW' AND ih.PURGE_DT IS NULL

		INSERT INTO #TMP_FINAL (EscrowId, InteractionHistoryId)
		SELECT
			ti.EscrowId
			,MIN(ti.InteractionHistoryId) AS InteractionHistoryId 
		FROM #TMP_IH1 ti
		WHERE ti.TradingPartnerId IS NOT NULL
		AND	ti.TransactionId IS NOT NULL
		GROUP BY ti.EscrowId
	END
	ELSE IF @lenderId IS NOT NULL
		AND @tradingPartnerId IS NOT NULL
	BEGIN
		SELECT
			esc.Id AS EscrowId 
		INTO #TMP_ESCROW2
		FROM ESCROW esc
			JOIN LOAN ln ON ln.ID = esc.LOAN_ID AND ln.PURGE_DT IS NULL
			JOIN REF_CODE_ATTRIBUTE attr ON attr.REF_CD = esc.SUB_STATUS_CD AND attr.DOMAIN_CD = 'EscrowSubStatus' AND attr.ATTRIBUTE_CD = 'AdjReasonCode'
				AND attr.PURGE_DT IS NULL
		WHERE ln.LENDER_ID = @lenderId
		AND ln.RECORD_TYPE_CD = 'G'
		AND esc.TRAN_STATUS_CD = @tranStatusCode
		AND esc.PURGE_DT IS NULL
		AND (@controlNumber IS NULL OR (@controlNumber IS NOT NULL AND esc.CONTROL_NUMBER_TX = @controlNumber))

		SELECT
			ih.RELATE_ID															AS EscrowId
			,ih.Id																	AS InteractionHistoryId
			,ih.SPECIAL_HANDLING_XML.value('(SH/TradingPartnerId)[1]', 'BigInt')	AS TradingPartnerId
			,ih.SPECIAL_HANDLING_XML.value('(SH/TransactionId)[1]', 'BigInt')		AS TransactionId 
		INTO #TMP_IH2
		FROM dbo.INTERACTION_HISTORY ih
			JOIN #TMP_ESCROW2 tmpEscrow ON ih.RELATE_ID = tmpEscrow.EscrowId AND ih.RELATE_CLASS_TX = 'Allied.Unitrac.Escrow'
				AND ih.TYPE_CD = 'ESCROW' AND ih.PURGE_DT IS NULL
		WHERE ih.SPECIAL_HANDLING_XML.value('(SH/TradingPartnerId)[1]', 'BigInt') = @tradingPartnerId

		INSERT INTO #TMP_FINAL (EscrowId, InteractionHistoryId)
		SELECT
			ti.EscrowId
			,MIN(ti.InteractionHistoryId) AS InteractionHistoryId 
		FROM #TMP_IH2 ti
		WHERE ti.TradingPartnerId IS NOT NULL
		AND	ti.TransactionId IS NOT NULL
		GROUP BY ti.EscrowId
	END


	SELECT
		--Escrow
		ESC.Id
		,ESC.LOAN_ID
		,ESC.PROPERTY_ID
		,ESC.TYPE_CD
		,ESC.STATUS_CD
		,ESC.SUB_STATUS_CD
		,ESC.STATUS_DT
		,ESC.RECORD_TYPE_CD
		,ESC.POLICY_NUMBER_TX
		,ESC.RECONCILLED_STATUS_CD
		,ESC.RECONCILLED_STATUS_DT
		,ESC.AMOUNT_TYPE_CD
		,ESC.TOTAL_AMOUNT_NO
		,ESC.PREMIUM_NO
		,ESC.OTHER_NO
		,ESC.FEE_NO
		,ESC.TOTAL_POLICY_PREMIUM_NO
		,ESC.DUE_DT
		,ESC.EFFECTIVE_DT
		,ESC.REPORTED_DT
		,ESC.TOTAL_PAID_AMOUNT_NO
		,ESC.REMITTANCE_TYPE_CD
		,ESC.BIC_ID
		,ESC.REMITTANCE_ADDR_ID
		,ESC.END_DT
		,ESC.CREATE_USER_TX
		,ESC.LOCK_ID
		,ESC.COMMENTS_TX
		,ESC.CREATE_DT
		,ESC.MAIL_DT
		,ESC.ORIGINAL_TOTAL_AMT_NO
		,ESC.TOTAL_AMT_CHG_DT
		,ESC.SUB_TYPE_CD
		,ESC.EXCESS_IN
		,ESC.QUICK_PAY_IN
		,ESC.PAYEE_CODE_TX
		,ESC.OVERNIGHT_ADDR_ID
		,ESC.CHECK_NUMBER_TX
		,ESC.CHECK_NAME_TX
		,ESC.CHECK_DT
		,ESC.CHECK_AMOUNT_NO
		,ESC.DOCUMENT_ID_TX
		,ESC.TRAN_STATUS_CD
		,ESC.LOCKOUT_OVERRIDE_IN
		,ESC.LAST_UPDATED_FROM_LENDER_FILE_IN
		,ESC.LAST_UPDATE_FROM_LENDER_FILE_DT
		,ESC.UPDATE_DT
		,ESC.CONTROL_NUMBER_TX

		--INTERACTION_HISTORY
		,IH.Id
		,IH.TYPE_CD
		,IH.ALERT_IN
		,IH.PENDING_IN
		,IH.IN_HOUSE_ONLY_IN
		,IH.DELETE_ID
		,IH.RELATE_CLASS_TX
		,IH.RELATE_ID
		,IH.CREATE_USER_TX
		,IH.LOCK_ID
		,IH.LOAN_ID
		,IH.PROPERTY_ID
		,IH.DOCUMENT_ID
		,IH.EFFECTIVE_DT
		,IH.EFFECTIVE_ORDER_NO
		,IH.ISSUE_DT
		,IH.NOTE_TX
		,IH.SPECIAL_HANDLING_XML
		,IH.ARCHIVED_IN
		,IH.UPDATE_USER_TX
        ,IH.CREATE_DT
        ,@moreinteractions as MORE_INTERACTIONS
		,ln.LENDER_ID
		,ln.AGENCY_ID

		--Additional data
		,ln.LENDER_ID
	FROM #TMP_FINAL tmpFinal
		JOIN ESCROW ESC ON ESC.Id = tmpFinal.EscrowId
		JOIN dbo.INTERACTION_HISTORY IH ON IH.Id = tmpFinal.InteractionHistoryId
		JOIN LOAN ln ON ln.Id = ESC.LOAN_ID AND ln.RECORD_TYPE_CD = 'G' AND ln.PURGE_DT IS NULL
	
END

GO

