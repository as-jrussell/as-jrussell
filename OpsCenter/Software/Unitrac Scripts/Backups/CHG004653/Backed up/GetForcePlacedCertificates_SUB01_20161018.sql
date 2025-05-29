USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetForcePlacedCertificates]    Script Date: 10/18/2016 12:18:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Changes to Force_Placed_Certificate columns also have to be made to GetForcePlacedCertificatesForBilling


CREATE PROCEDURE [dbo].[GetForcePlacedCertificates]
(
   @id   bigint = null,
   @lenderCode nvarchar(10) = null,
   @startDate datetime2 = null,
   @endDate datetime2 = null,
   @fpcNumber nvarchar(18) = null,
   @requiredCoverageId bigint = null,
   @loanId bigint = null,
   @lenderFinTxnId bigint = null,
   @billingGroupId bigint = null,
   @lCGCTId bigint = null,
   @onlyBLIT int = 0,
   @lenderId bigint = null,
   @openFunding char(1) = null, 
   @agencyId bigint = null,
   @loanIdviaRC bigint = null,
   @masterPolicyId bigint = null,
   @isServiceFeeInvoiceCall varchar(1) = null
)
AS
BEGIN
   SET NOCOUNT ON
   
   if @id = 0
      set @id = null
      
   if @lCGCTId = 0
      set @lCGCTId = null
      
   IF @billingGroupId = 0
	  set @billingGroupId = NULL
	  
   IF @lenderFinTxnId = 0
	  set @lenderFinTxnId = NULL

   IF @agencyId = 0
	  set @agencyId = NULL

   IF @masterPolicyId = 0
      set @masterPolicyId = NULL

   IF (@openFunding = 'Y') BEGIN
     IF (@billingGroupId is not null) BEGIN
	   SELECT TOP 1000
			0 as ID,
			@lenderFinTxnId as LFT_ID,
			OFU.FPC_ID,
			null as TXN_TYPE_CD,
			0 as AMOUNT_NO,
			OFU.AMOUNT_NO AS AP_AR_AMOUNT_NO,
			@billingGroupId as BILLING_GROUP_ID,
			0 as LOCK_ID,
			dbo.GetFPCOutstandingAmount(ofu.FPC_ID),
			dbo.GetFPCTotalFundAmount(ofu.FPC_ID),
			dbo.GetFPCTotalRefundAmount(ofu.FPC_ID),
			dbo.GetFPCIssueAmount(ofu.FPC_ID),
			dbo.GetFPCIsBilled(ofu.FPC_ID),
			 F.ID,
			 F.LOAN_ID,
			 F.CPI_QUOTE_ID,
			 F.NUMBER_TX,
			 F.PRODUCER_NUMBER_TX,
			 F.LOAN_NUMBER_TX,
			 F.ACTIVE_IN,
			 F.MONTHLY_BILLING_IN,
			 F.HOLD_IN,
			 F.CLAIM_PENDING_IN,
			 F.CURRENT_PAYMENT_AMOUNT_NO,
			 F.PREVIOUS_PAYMENT_AMOUNT_NO,
			 F.CREATED_BY_TX,
			 F.STATUS_CD,
			 F.LOCK_ID,
			 F.CAPTURED_DATA_XML,
			 F.GENERATION_SOURCE_CD,
			 F.EXPECTED_ISSUE_DT,
			 F.ISSUE_DT,
			 F.EFFECTIVE_DT,
			 F.EXPIRATION_DT,
			 F.CANCELLATION_DT,
			 F.TEMPLATE_ID,
			 F.COVER_LETTER_TEMPLATE_ID,
			 F.PDF_GENERATE_CD,
			 F.MSG_LOG_TX, ---added by AD-01/25/12 - Bug11392
			 F.CARRIER_ID,
			 F.MASTER_POLICY_ID,
			 F.MASTER_POLICY_ASSIGNMENT_ID,
			 F.AUTH_REQ_DT,
			 F.QUICK_ISSUE_IN,
			 F.BILL_CD,
			 F.BILLING_STATUS_CD,
			 F.EARNED_PAYMENT_NO,
			 F.AUTHORIZED_BY_TX,
			 F.LENDER_INTENT,
			 F.PAYMENT_REPORT_CD,
			 F.PAYMENT_REPORT_DT,
			 F.PIR_DT
      
	   from FORCE_PLACED_CERTIFICATE F
           inner join
             (select ft.FPC_ID, SUM(ft.AMOUNT_NO) as 'AMOUNT_NO'
              from FINANCIAL_TXN_APPLY A
                inner join FINANCIAL_TXN FT on a.FINANCIAL_TXN_ID = FT.ID and FT.PURGE_DT is null
              where A.BILLING_GROUP_ID = @billingGroupId and A.PURGE_DT is null
              group by ft.FPC_ID) OFU on F.ID = OFU.FPC_ID
            OUTER APPLY
              (
                SELECT SUM(AMOUNT_NO) AS FT_AMOUNT_NO 
                FROM FINANCIAL_TXN FT
                WHERE FT.PURGE_DT IS NULL 
                AND FT.FPC_ID = F.ID
              ) AS FT
       where F.PURGE_DT is null
       AND FT.FT_AMOUNT_NO <> 0
       ORDER BY FT.FT_AMOUNT_NO
	 END ELSE IF (@id is not null) BEGIN
		  SELECT 
			0 as ID,
			@lenderFinTxnId as LFT_ID,
			@id AS FPC_ID,
			null as TXN_TYPE_CD,
			0 as AMOUNT_NO,
			(SELECT sum(ft.AMOUNT_NO) FROM FINANCIAL_TXN ft 
			 WHERE ft.FPC_ID = @id AND ft.PURGE_DT IS NULL) AS AP_AR_AMOUNT_NO,
			NULL AS BILLING_GROUP_ID,
			0 as LOCK_ID,
			dbo.GetFPCOutstandingAmount(@id),
			dbo.GetFPCTotalFundAmount(@id),
			  dbo.GetFPCTotalRefundAmount(@id),
			  dbo.GetFPCIssueAmount(@id),
			  dbo.GetFPCIsBilled(@id)
	 END ELSE IF (@lenderFinTxnId IS NOT NULL)  BEGIN  
		  SELECT
			 OPF.ID,
			 OPF.LFT_ID,
			 OPF.FPC_ID,
			 OPF.TXN_TYPE_CD,
			 OPF.AMOUNT_NO,
			 
			 CASE
				WHEN 0 = OPF.BILLING_GROUP_ID THEN
				 (SELECT sum(ft.AMOUNT_NO)
				  FROM FINANCIAL_TXN ft 
				  WHERE ft.FPC_ID = OPF.FPC_ID and ft.PURGE_DT IS NULL)
				ELSE
				 (SELECT sum(ft.AMOUNT_NO)
				  FROM FINANCIAL_TXN ft 
					inner join FINANCIAL_TXN_APPLY fta on ft.ID = fta.FINANCIAL_TXN_ID and fta.BILLING_GROUP_ID = OPF.BILLING_GROUP_ID
				  WHERE ft.FPC_ID = OPF.FPC_ID and ft.PURGE_DT IS NULL)
			 END as AP_AR_AMOUNT_NO,
			  
			 OPF.BILLING_GROUP_ID,
			 OPF.LOCK_ID, 
			 dbo.GetFPCOutstandingAmount(OPF.FPC_ID),
			 dbo.GetFPCTotalFundAmount(OPF.FPC_ID),
			dbo.GetFPCTotalRefundAmount(OPF.FPC_ID),
			dbo.GetFPCIssueAmount(OPF.FPC_ID),
			dbo.GetFPCIsBilled(OPF.FPC_ID),
			 FPC.ID,
			 FPC.LOAN_ID,
			 FPC.CPI_QUOTE_ID,
			 FPC.NUMBER_TX,
			 FPC.PRODUCER_NUMBER_TX,
			 FPC.LOAN_NUMBER_TX,
			 FPC.ACTIVE_IN,
			 MONTHLY_BILLING_IN,
			 FPC.HOLD_IN,
			 FPC.CLAIM_PENDING_IN,
			 FPC.CURRENT_PAYMENT_AMOUNT_NO,
			 FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
			 FPC.CREATED_BY_TX,
			 FPC.STATUS_CD,
			 FPC.LOCK_ID,
			 FPC.CAPTURED_DATA_XML,
			 FPC.GENERATION_SOURCE_CD,
			 FPC.EXPECTED_ISSUE_DT,
			 FPC.ISSUE_DT,
			 FPC.EFFECTIVE_DT,
			 FPC.EXPIRATION_DT,
			 FPC.CANCELLATION_DT,
			 FPC.TEMPLATE_ID,
			 FPC.COVER_LETTER_TEMPLATE_ID,
			 FPC.PDF_GENERATE_CD,
			 FPC.MSG_LOG_TX, 
			 FPC.CARRIER_ID,
			 FPC.MASTER_POLICY_ID,
			 FPC.MASTER_POLICY_ASSIGNMENT_ID,
			 FPC.AUTH_REQ_DT,
			 FPC.QUICK_ISSUE_IN,
			 FPC.BILL_CD,
			 FPC.BILLING_STATUS_CD,
			 FPC.EARNED_PAYMENT_NO,
			 FPC.AUTHORIZED_BY_TX,
			 FPC.LENDER_INTENT,
			 FPC.PAYMENT_REPORT_CD,
			 FPC.PAYMENT_REPORT_DT,
			 FPC.PIR_DT
		  FROM FORCE_PLACED_CERTIFICATE FPC
		    INNER JOIN OPEN_FUNDING OPF ON FPC.ID = OPF.FPC_ID and OPF.LFT_ID = @lenderFinTxnId AND OPF.PURGE_DT IS NULL
		           and OPF.BILLING_GROUP_ID is not null
		  where FPC.PURGE_DT is null
	   END
   END ELSE
   if @id > 0
   BEGIN
	IF ((ISNULL(@lCGCTId, 0 ) > 0) and (@onlyBLIT = 0))
	BEGIN
      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT,
		 FPC.PAYMENT_REPORT_CD,
		 FPC.PAYMENT_REPORT_DT,
		 FPC.PIR_DT
         FROM FORCE_PLACED_CERTIFICATE FPC
         INNER JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPR ON
         FPR.FPC_ID = FPC.ID 
         INNER JOIN REQUIRED_COVERAGE RC ON RC.ID = FPR.REQUIRED_COVERAGE_ID
         WHERE ((RC.LCGCT_ID = @lCGCTId) AND(FPC.ID = @id) AND (FPC.STATUS_CD ! = 'UH') AND (FPC.HOLD_IN != 'Y') AND (FPC.PURGE_DT is null))
         AND FPR.PURGE_DT IS NULL
	END else IF ((ISNULL(@lCGCTId, 0 ) > 0) and (@onlyBLIT != 0))
    BEGIN
      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT,
		 FPC.PAYMENT_REPORT_CD,
		 FPC.PAYMENT_REPORT_DT,
		 FPC.PIR_DT
      FROM FORCE_PLACED_CERTIFICATE FPC
         INNER JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPR ON FPR.FPC_ID = FPC.ID 
         INNER JOIN REQUIRED_COVERAGE RC ON RC.ID = FPR.REQUIRED_COVERAGE_ID
      WHERE ((RC.LCGCT_ID = @lCGCTId) AND(FPC.ID = @id) and (FPC.BILLING_STATUS_CD = 'BLIT')
        AND (FPC.STATUS_CD ! = 'UH') AND (FPC.HOLD_IN != 'Y') AND (FPC.PURGE_DT is null))
        AND FPR.PURGE_DT IS NULL
	END ELSE BEGIN
      SELECT
         ID,
         LOAN_ID,
         CPI_QUOTE_ID,
         NUMBER_TX,
         PRODUCER_NUMBER_TX,
         LOAN_NUMBER_TX,
         ACTIVE_IN,
         MONTHLY_BILLING_IN,
         HOLD_IN,
         CLAIM_PENDING_IN,
         CURRENT_PAYMENT_AMOUNT_NO,
         PREVIOUS_PAYMENT_AMOUNT_NO,
         CREATED_BY_TX,
         STATUS_CD,
         LOCK_ID,
         CAPTURED_DATA_XML,
         GENERATION_SOURCE_CD,
         EXPECTED_ISSUE_DT,
         ISSUE_DT,
         EFFECTIVE_DT,
         EXPIRATION_DT,
         CANCELLATION_DT,
         TEMPLATE_ID,
         COVER_LETTER_TEMPLATE_ID,
         PDF_GENERATE_CD,
         MSG_LOG_TX, ---added by AD-01/25/12 - Bug11392
         CARRIER_ID,
         MASTER_POLICY_ID,
         MASTER_POLICY_ASSIGNMENT_ID,
         AUTH_REQ_DT,
         QUICK_ISSUE_IN,
         BILL_CD,
         BILLING_STATUS_CD,
         EARNED_PAYMENT_NO,
		 AUTHORIZED_BY_TX,
		 LENDER_INTENT,
		 PAYMENT_REPORT_CD,
		 PAYMENT_REPORT_DT,
		 PIR_DT
      FROM FORCE_PLACED_CERTIFICATE F
      WHERE
         ID = @id
    end
   END
   -- merging ...ForBilling sproc
   ELSE IF ((ISNULL(@lCGCTId, 0 ) > 0) AND (@onlyBLIT = 0))
   BEGIN
      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT,
		 FPC.PAYMENT_REPORT_CD,
		 FPC.PAYMENT_REPORT_DT,
		 FPC.PIR_DT
      FROM FORCE_PLACED_CERTIFICATE FPC
        INNER JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPR ON FPR.FPC_ID = FPC.ID 
        INNER JOIN REQUIRED_COVERAGE RC ON RC.ID = FPR.REQUIRED_COVERAGE_ID
      WHERE ((RC.LCGCT_ID = @lCGCTId) AND (FPC.STATUS_CD ! = 'UH') AND (FPC.HOLD_IN != 'Y') AND (FPC.PURGE_DT is null))
      AND FPR.PURGE_DT IS NULL
   END
   ELSE IF ((ISNULL(@lCGCTId, 0 ) > 0) AND (@onlyBLIT != 0))
   BEGIN
      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT,
		 FPC.PAYMENT_REPORT_CD,
		 FPC.PAYMENT_REPORT_DT,
		 FPC.PIR_DT
      FROM FORCE_PLACED_CERTIFICATE FPC
        INNER JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPR ON FPR.FPC_ID = FPC.ID 
        INNER JOIN REQUIRED_COVERAGE RC ON RC.ID = FPR.REQUIRED_COVERAGE_ID
      WHERE ((RC.LCGCT_ID = @lCGCTId) and (FPC.BILLING_STATUS_CD = 'BLIT')AND (FPC.STATUS_CD ! = 'UH')
        AND (FPC.HOLD_IN != 'Y') AND (FPC.PURGE_DT is null))
        AND FPR.PURGE_DT IS NULL
   END
   ELSE IF ISNULL(@billingGroupId, 0) > 0
   BEGIN  
	 SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT
     FROM FORCE_PLACED_CERTIFICATE FPC
	 WHERE  FPC.ID IN (SELECT DISTINCT FT.FPC_ID FROM FINANCIAL_TXN FT INNER JOIN FINANCIAL_TXN_APPLY FTA ON FTA.FINANCIAL_TXN_ID = FT.ID WHERE FTA.BILLING_GROUP_ID = @billingGroupId )
	   and FPC.PURGE_DT is null
   END
   ELSE IF (ISNULL(@lenderCode, '') <> '' and @startDate is not null and @endDate is not null)
	BEGIN 
	   SELECT
         ID,
         LOAN_ID,
         CPI_QUOTE_ID,
         NUMBER_TX,
         PRODUCER_NUMBER_TX,
         LOAN_NUMBER_TX,
         ACTIVE_IN,
         MONTHLY_BILLING_IN,
         HOLD_IN,
         CLAIM_PENDING_IN,
         CURRENT_PAYMENT_AMOUNT_NO,
         PREVIOUS_PAYMENT_AMOUNT_NO,
         CREATED_BY_TX,
         STATUS_CD,
         LOCK_ID,
         CAPTURED_DATA_XML,
         GENERATION_SOURCE_CD,
         EXPECTED_ISSUE_DT,
         ISSUE_DT,
         EFFECTIVE_DT,
         EXPIRATION_DT,
         CANCELLATION_DT,
         TEMPLATE_ID,
         COVER_LETTER_TEMPLATE_ID,
         PDF_GENERATE_CD,
         MSG_LOG_TX, ---added by AD-01/25/12 - Bug11392
         CARRIER_ID,
         MASTER_POLICY_ID,
         MASTER_POLICY_ASSIGNMENT_ID,
         AUTH_REQ_DT,
         QUICK_ISSUE_IN,
         BILL_CD,
         BILLING_STATUS_CD,
         EARNED_PAYMENT_NO,
		 AUTHORIZED_BY_TX,
		 LENDER_INTENT,
		 PAYMENT_REPORT_CD,
		 PAYMENT_REPORT_DT,
		 PIR_DT
      FROM FORCE_PLACED_CERTIFICATE F
	   WHERE
         convert(date, CREATE_DT, 101) >= convert(date, @startDate, 101) 
         and convert(date, CREATE_DT, 101) <= convert(date, @endDate, 101)
         and CAPTURED_DATA_XML.value('(//CapturedData/Lender/@number)[1]', 'varchar(10)') = @lenderCode
         and (@fpcNumber IS NULL OR F.NUMBER_TX LIKE '%' + @fpcNumber + '%')
         AND F.PURGE_DT IS NULL
   END
   --- Added by AD - 04/13/12
   ELSE IF ISNULL(@requiredCoverageId, 0 ) > 0
   BEGIN
      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT,
		 FPC.PAYMENT_REPORT_CD,
		 FPC.PAYMENT_REPORT_DT,
		 FPC.PIR_DT
      FROM FORCE_PLACED_CERTIFICATE FPC
        INNER JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPR ON FPR.FPC_ID = FPC.ID 
      WHERE FPR.REQUIRED_COVERAGE_ID = @requiredCoverageId
        AND FPC.PURGE_DT IS NULL
        AND FPR.PURGE_DT IS NULL
   END
   ---- end added - 04/13/12
   ELSE IF ISNULL(@loanId, 0 ) > 0
   BEGIN
      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT,
		 FPC.PAYMENT_REPORT_CD,
		 FPC.PAYMENT_REPORT_DT,
		 FPC.PIR_DT
      FROM FORCE_PLACED_CERTIFICATE FPC
      where FPC.LOAN_ID = @loanId and FPC.PURGE_DT IS NULL
   END
   -- added by OA - 10/29/12
   ELSE IF (@fpcNumber IS NOT NULL AND @lenderId IS NOT NULL ) BEGIN
   SELECT
         F.ID,
         F.LOAN_ID,
         F.CPI_QUOTE_ID,
         F.NUMBER_TX,
         F.PRODUCER_NUMBER_TX,
         F.LOAN_NUMBER_TX,
         F.ACTIVE_IN,
         F.MONTHLY_BILLING_IN,
         F.HOLD_IN,
         F.CLAIM_PENDING_IN,
         F.CURRENT_PAYMENT_AMOUNT_NO,
         F.PREVIOUS_PAYMENT_AMOUNT_NO,
         F.CREATED_BY_TX,
         F.STATUS_CD,
         F.LOCK_ID,
         F.CAPTURED_DATA_XML,
         F.GENERATION_SOURCE_CD,
         F.EXPECTED_ISSUE_DT,
         F.ISSUE_DT,
         F.EFFECTIVE_DT,
         F.EXPIRATION_DT,
         F.CANCELLATION_DT,
         F.TEMPLATE_ID,
         F.COVER_LETTER_TEMPLATE_ID,
         F.PDF_GENERATE_CD,
         F.MSG_LOG_TX, ---added by AD-01/25/12 - Bug11392
         F.CARRIER_ID,
         F.MASTER_POLICY_ID,
         F.MASTER_POLICY_ASSIGNMENT_ID,
         F.AUTH_REQ_DT,
         F.QUICK_ISSUE_IN,
         F.BILL_CD,
         F.BILLING_STATUS_CD,
         F.EARNED_PAYMENT_NO,
		 F.AUTHORIZED_BY_TX,
		 F.LENDER_INTENT,
		 F.PAYMENT_REPORT_CD,
		 F.PAYMENT_REPORT_DT,
		 F.PIR_DT
	  FROM FORCE_PLACED_CERTIFICATE F
	    INNER JOIN LOAN ON LOAN.ID = F.LOAN_ID AND LOAN.LENDER_ID = @lenderId
	  WHERE F.NUMBER_TX LIKE @fpcNumber + '%' and F.PURGE_DT IS NULL
	END
	 -- end added -10/29/12
	 ELSE IF (@fpcNumber IS NOT NULL AND @lenderId IS NULL AND @agencyId IS NOT NULL ) BEGIN
   SELECT
         F.ID,
         F.LOAN_ID,
         F.CPI_QUOTE_ID,
         F.NUMBER_TX,
         F.PRODUCER_NUMBER_TX,
         F.LOAN_NUMBER_TX,
         F.ACTIVE_IN,
         F.MONTHLY_BILLING_IN,
         F.HOLD_IN,
         F.CLAIM_PENDING_IN,
         F.CURRENT_PAYMENT_AMOUNT_NO,
         F.PREVIOUS_PAYMENT_AMOUNT_NO,
         F.CREATED_BY_TX,
         F.STATUS_CD,
         F.LOCK_ID,
         F.CAPTURED_DATA_XML,
         F.GENERATION_SOURCE_CD,
         F.EXPECTED_ISSUE_DT,
         F.ISSUE_DT,
         F.EFFECTIVE_DT,
         F.EXPIRATION_DT,
         F.CANCELLATION_DT,
         F.TEMPLATE_ID,
         F.COVER_LETTER_TEMPLATE_ID,
         F.PDF_GENERATE_CD,
         F.MSG_LOG_TX, ---added by AD-01/25/12 - Bug11392
         F.CARRIER_ID,
         F.MASTER_POLICY_ID,
         F.MASTER_POLICY_ASSIGNMENT_ID,
         F.AUTH_REQ_DT,
         F.QUICK_ISSUE_IN,
         F.BILL_CD,
         F.BILLING_STATUS_CD,
         F.EARNED_PAYMENT_NO,
		 F.AUTHORIZED_BY_TX,
		 F.LENDER_INTENT,
		 F.PAYMENT_REPORT_CD,
		 F.PAYMENT_REPORT_DT,
		 F.PIR_DT
	  FROM FORCE_PLACED_CERTIFICATE F
		inner join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE fpcrcr on fpcrcr.FPC_ID = F.id
			and fpcrcr.PURGE_DT is null
		inner join REQUIRED_COVERAGE rc on rc.id = fpcrcr.required_coverage_id
			and rc.PURGE_DT is null
		inner join PROPERTY p on p.id = rc.property_id 
			and p.Agency_id = @agencyId
			and p.PURGE_DT is null
	  WHERE F.NUMBER_TX LIKE @fpcNumber + '%' and F.PURGE_DT IS NULL
	END
   ELSE IF (@lenderId IS NOT NULL ) BEGIN
   SELECT
         F.ID,
         F.LOAN_ID,
         F.CPI_QUOTE_ID,
         F.NUMBER_TX,
         F.PRODUCER_NUMBER_TX,
         F.LOAN_NUMBER_TX,
         F.ACTIVE_IN,
         F.MONTHLY_BILLING_IN,
         F.HOLD_IN,
         F.CLAIM_PENDING_IN,
         F.CURRENT_PAYMENT_AMOUNT_NO,
         F.PREVIOUS_PAYMENT_AMOUNT_NO,
         F.CREATED_BY_TX,
         F.STATUS_CD,
         F.LOCK_ID,
         F.CAPTURED_DATA_XML,
         F.GENERATION_SOURCE_CD,
         F.EXPECTED_ISSUE_DT,
         F.ISSUE_DT,
         F.EFFECTIVE_DT,
         F.EXPIRATION_DT,
         F.CANCELLATION_DT,
         F.TEMPLATE_ID,
         F.COVER_LETTER_TEMPLATE_ID,
         F.PDF_GENERATE_CD,
         F.MSG_LOG_TX, ---added by AD-01/25/12 - Bug11392
         F.CARRIER_ID,
         F.MASTER_POLICY_ID,
         F.MASTER_POLICY_ASSIGNMENT_ID,
         F.AUTH_REQ_DT,
         F.QUICK_ISSUE_IN,
         F.BILL_CD,
         F.BILLING_STATUS_CD,
         F.EARNED_PAYMENT_NO,
		 F.AUTHORIZED_BY_TX,
		 F.LENDER_INTENT,
		 F.PAYMENT_REPORT_CD,
		 F.PAYMENT_REPORT_DT,
		 F.PIR_DT
      FROM FORCE_PLACED_CERTIFICATE F
	    INNER JOIN LOAN ON LOAN.ID = F.LOAN_ID AND LOAN.LENDER_ID = @lenderId
      WHERE F.PURGE_DT IS NULL
	END
   ELSE IF (@loanIdviaRC IS NOT NULL ) 
	BEGIN
      SELECT
         F.ID,
         F.LOAN_ID,
         F.CPI_QUOTE_ID,
         F.NUMBER_TX,
         F.PRODUCER_NUMBER_TX,
         F.LOAN_NUMBER_TX,
         F.ACTIVE_IN,
         F.MONTHLY_BILLING_IN,
         F.HOLD_IN,
         F.CLAIM_PENDING_IN,
         F.CURRENT_PAYMENT_AMOUNT_NO,
         F.PREVIOUS_PAYMENT_AMOUNT_NO,
         F.CREATED_BY_TX,
         F.STATUS_CD,
         F.LOCK_ID,
         F.CAPTURED_DATA_XML,
         F.GENERATION_SOURCE_CD,
         F.EXPECTED_ISSUE_DT,
         F.ISSUE_DT,
         F.EFFECTIVE_DT,
         F.EXPIRATION_DT,
         F.CANCELLATION_DT,
         F.TEMPLATE_ID,
         F.COVER_LETTER_TEMPLATE_ID,
         F.PDF_GENERATE_CD,
         F.MSG_LOG_TX, 
         F.CARRIER_ID,
         F.MASTER_POLICY_ID,
         F.MASTER_POLICY_ASSIGNMENT_ID,
         F.AUTH_REQ_DT,
         F.QUICK_ISSUE_IN,
         F.BILL_CD,
         F.BILLING_STATUS_CD,
         F.EARNED_PAYMENT_NO,
		   F.AUTHORIZED_BY_TX,
		   F.LENDER_INTENT,
		   F.PAYMENT_REPORT_CD,
		   F.PAYMENT_REPORT_DT,
		   F.PIR_DT
      FROM LOAN JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
      AND LOAN.PURGE_DT IS NULL AND COLL.PURGE_DT IS NULL
      JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID AND PR.PURGE_DT IS NULL
      JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = PR.ID
      AND RC.PURGE_DT IS NULL
      JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE REL 
      ON REL.REQUIRED_COVERAGE_ID = RC.ID AND REL.PURGE_DT IS NULL
      JOIN FORCE_PLACED_CERTIFICATE F ON F.ID = REL.FPC_ID
	  AND F.PURGE_DT IS NULL
      WHERE LOAN.ID = @loanIdviaRC 
	END
   ELSE IF (@masterPolicyId IS NOT NULL)
   BEGIN
      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
		 FPC.AUTHORIZED_BY_TX,
		 FPC.LENDER_INTENT,
		 FPC.PAYMENT_REPORT_CD,
		 FPC.PAYMENT_REPORT_DT,
		 FPC.PIR_DT
      FROM FORCE_PLACED_CERTIFICATE FPC
      where FPC.MASTER_POLICY_ID = @masterPolicyId AND FPC.PURGE_DT IS NULL

   END
   -- For Service Fee Invoice Calls
   ELSE if @isServiceFeeInvoiceCall is not null 
   BEGIN

      SELECT
         FPC.ID,
         FPC.LOAN_ID,
         FPC.CPI_QUOTE_ID,
         FPC.NUMBER_TX,
         FPC.PRODUCER_NUMBER_TX,
         FPC.LOAN_NUMBER_TX,
         FPC.ACTIVE_IN,
         FPC.MONTHLY_BILLING_IN,
         FPC.HOLD_IN,
         FPC.CLAIM_PENDING_IN,
         FPC.CURRENT_PAYMENT_AMOUNT_NO,
         FPC.PREVIOUS_PAYMENT_AMOUNT_NO,
         FPC.CREATED_BY_TX,
         FPC.STATUS_CD,
         FPC.LOCK_ID,
         FPC.CAPTURED_DATA_XML,
         FPC.GENERATION_SOURCE_CD,
         FPC.EXPECTED_ISSUE_DT,
         FPC.ISSUE_DT,
         FPC.EFFECTIVE_DT,
         FPC.EXPIRATION_DT,
         FPC.CANCELLATION_DT,
         FPC.TEMPLATE_ID,
         FPC.COVER_LETTER_TEMPLATE_ID,
         FPC.PDF_GENERATE_CD,
         FPC.MSG_LOG_TX, 
         FPC.CARRIER_ID,
         FPC.MASTER_POLICY_ID,
         FPC.MASTER_POLICY_ASSIGNMENT_ID,
         FPC.AUTH_REQ_DT,
         FPC.QUICK_ISSUE_IN,
         FPC.BILL_CD,
         FPC.BILLING_STATUS_CD,
         FPC.EARNED_PAYMENT_NO,
         FPC.AUTHORIZED_BY_TX,
         FPC.LENDER_INTENT,
         FPC.PAYMENT_REPORT_CD,
         FPC.PAYMENT_REPORT_DT,
         FPC.PIR_DT
      from [dbo].[FORCE_PLACED_CERTIFICATE] fpc
         inner join LOAN loan with (nolock) on fpc.LOAN_ID = loan.ID and loan.purge_dt is null
         inner join DOCUMENT_CONTAINER dc with (nolock) on fpc.ID = dc.RELATE_ID and dc.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.ForcePlacedCertificate'
      where
         LENDER_ID = @lenderId
         and dc.PRINT_STATUS_CD = 'PRINTED' 
         and fpc.PURGE_DT is null
         and dc.PURGE_DT is null
         and dc.PRINTED_DT between @startDate and @endDate

   END 

END

GO

