USE [UniTrac_DW]
GO

/****** Object:  StoredProcedure [dbo].[GetServiceSummaryReport]    Script Date: 10/19/2017 8:12:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:        p turner
-- Create date: 11/30/9
-- Description:   GetServiceSummaryReport
-- Example:       GetServiceSummaryReport '11/1/2009', '1832', NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetServiceSummaryReport](
      @date AS DATETIME,
      @lenderCode AS NVARCHAR(10),
      @userId AS BIGINT)
AS
BEGIN
SET NOCOUNT ON;

DECLARE
      @MONTH AS INT,
      @YEAR AS INT

Declare @Date_DIM_ID as int
Select @Date_DIM_ID = ID from Date_DIM where date_dt = @date
SET @MONTH = DATEPART (MONTH, @date)
SET @YEAR = DATEPART (YEAR, @date)

SELECT
      --Header
      'Service Summary Report' AS [title],
      DATENAME(MONTH, @date) + ', ' + CONVERT(NVARCHAR, DATEPART(YEAR, @date)) + ' for ' + LD.NAME_TX AS [lenderName],
      --Portfolio Statistics
      lda.TRACK_ONLY_IN [TRACK_ONLY_IN],
      lda.CLAIM_SERVICE_IN [CLAIM_SERVICE_IN],
      LS.TOTAL_LOANS_NO AS [Tracked Loans Count],
      LS.TOTAL_LOANS_BALANCE_NO AS [Tracked Loans Balance],
      LS.ACTIVE_LOANS_NO AS [Active Loans Count],
      LS.[ACTIVE_LOANS_BALANCE_NO] AS [Active Loans Balance],
      LS.EXPOSED_LOANS_NO AS [Exposure Loans Count],
      LS.[EXPOSED_LOANS_BALANCE_NO] AS [Exposure Loans Balance],
      CASE WHEN (LS.ACTIVE_LOANS_NO = 0) THEN NULL ELSE
      LS.EXPOSED_LOANS_NO / convert(float, LS.ACTIVE_LOANS_NO) END
      AS [Percentage of Exposure Loans Count],
      CASE WHEN (LS.[ACTIVE_LOANS_BALANCE_NO] = 0) THEN NULL ELSE
      LS.[EXPOSED_LOANS_BALANCE_NO] / convert(float, LS.[ACTIVE_LOANS_BALANCE_NO]) END
      AS [Percentage of Exposure Loans Balance],
      LS.WAIVED_LOANS_NO AS [Waived Loans Count],
      LS.[WAIVED_LOANS_BALANCE_NO] AS [Waived Loans Balance],
      CASE WHEN (LS.ACTIVE_LOANS_NO = 0) THEN NULL ELSE
      LS.WAIVED_LOANS_NO / convert(float, LS.ACTIVE_LOANS_NO) END
      AS [Percentage of Waived Loans Count],
      CASE WHEN (LS.[ACTIVE_LOANS_BALANCE_NO] = 0) THEN NULL ELSE
      LS.[WAIVED_LOANS_BALANCE_NO] / convert(float, LS.[ACTIVE_LOANS_BALANCE_NO]) END
      AS [Percentage of Waived Loans Balance],
      LS.CPI_COVERED_LOANS_NO AS [CPI Covered Loans Count],
      LS.[CPI_COVERED_LOANS_BALANCE_NO] AS [CPI Covered Loans Balance],
      CASE WHEN (LS.TOTAL_LOANS_NO = 0) THEN NULL ELSE
      LS.CPI_COVERED_LOANS_NO / convert(float, LS.TOTAL_LOANS_NO) END
      AS [Penetration Count],
      CASE WHEN (LS.TOTAL_LOANS_BALANCE_NO = 0) THEN NULL ELSE
      LS.[CPI_COVERED_LOANS_BALANCE_NO] / convert(float, LS.TOTAL_LOANS_BALANCE_NO) END
      AS [Penetration Balance],
      --Financial Statistics
      LS.WRITTEN_PREMIUM_AM_NO AS [Written Premium Current],
      LS.YTD_WRITTEN_PREMIUM_AM_NO AS [Written Premium ytd],
      LS.[12MO_WRITTEN_PREMIUM_AM_NO] AS [Written Premium 12mo],
      LS.EARNED_PREMIUM_AM_NO AS [Earned Premium Current],
      LS.YTD_EARNED_PREMIUM_AM_NO AS [Earned Premium ytd],
      LS.[12MO_EARNED_PREMIUM_AM_NO] AS [Earned Premium 12mo],
      LS.EXCEPTION_AM_NO AS [Exception],
      LS.YTD_EXCEPTION_AM_NO AS [Exception ytd],
      LS.[12MO_EXCEPTION_AM_NO] AS [Exception 12mo],
      LS.INCURRED_PREMIUM_LOSS_AM_NO AS [Incurred Loss Current],
      LS.YTD_INCURRED_PREMIUM_LOSS_AM_NO AS [Incurred Loss ytd],
      LS.[12MO_INCURRED_PREMIUM_LOSS_AM_NO] AS [Incurred Loss 12mo],
      CASE WHEN (LS.EARNED_PREMIUM_AM_NO = 0) THEN NULL ELSE
      LS.INCURRED_PREMIUM_LOSS_AM_NO / convert(float, LS.EARNED_PREMIUM_AM_NO) END
      AS [Loss Ratio Current],
      CASE WHEN (LS.YTD_EARNED_PREMIUM_AM_NO = 0) THEN NULL ELSE
      LS.YTD_INCURRED_PREMIUM_LOSS_AM_NO / convert(float, LS.YTD_EARNED_PREMIUM_AM_NO) END
      AS [Loss Ratio ytd],
      CASE WHEN (LS.[12MO_EARNED_PREMIUM_AM_NO] = 0) THEN NULL ELSE
      LS.[12MO_INCURRED_PREMIUM_LOSS_AM_NO] / convert(float, LS.[12MO_EARNED_PREMIUM_AM_NO]) END
      AS [Loss Ratio 12mo],
      LS.CPI_COVERED_LOANS_NO AS [Inforce Policies Current],
      NULL AS [Inforce Policies ytd],
      LS.[12MO_INFORCE_POLICIES_NO] AS [Inforce Policies 12mo],
      LS.INFORCE_AM_NO AS [Inforce Premium Current],
      NULL AS [Inforce Premium ytd],
      LS.[12MO_INFORCE_AM_NO] AS [Inforce Premium 12mo],
      CASE WHEN (LS.PENDING_CLAIMS_COUNT_NO IS NULL OR LS.SUBMIT_CLAIMS_COUNT_NO IS NULL) THEN NULL ELSE
      LS.PENDING_CLAIMS_COUNT_NO + LS.SUBMIT_CLAIMS_COUNT_NO END AS [Count tot Current],
      CASE WHEN (LS.YTD_PENDING_CLAIMS_COUNT_NO IS NULL OR LS.YTD_SUBMIT_CLAIMS_COUNT_NO IS NULL) THEN NULL ELSE
      LS.YTD_PENDING_CLAIMS_COUNT_NO + LS.YTD_SUBMIT_CLAIMS_COUNT_NO END AS [Count tot ytd],
      CASE WHEN (LS.[12MO_PENDING_CLAIMS_COUNT_NO] IS NULL OR LS.[12MO_SUBMIT_CLAIMS_COUNT_NO] IS NULL) THEN NULL ELSE
      LS.[12MO_PENDING_CLAIMS_COUNT_NO] + LS.[12MO_SUBMIT_CLAIMS_COUNT_NO] END AS [Count tot 12mo],
      LS.PENDING_CLAIMS_COUNT_NO AS [Count Pending Current],
      LS.YTD_PENDING_CLAIMS_COUNT_NO AS [Count Pending ytd],
      LS.[12MO_PENDING_CLAIMS_COUNT_NO] AS [Count Pending 12mo],
      LS.SUBMIT_CLAIMS_COUNT_NO AS [Count Submitted Current],
      LS.YTD_SUBMIT_CLAIMS_COUNT_NO AS [Count Submitted ytd],
      LS.[12MO_SUBMIT_CLAIMS_COUNT_NO] AS [Count Submitted 12mo],
      CASE WHEN (LS.PENDING_CLAIMS_AMOUNT_NO IS NULL OR LS.SUBMIT_CLAIMS_AMOUNT_NO IS NULL) THEN NULL ELSE
      LS.PENDING_CLAIMS_AMOUNT_NO + LS.SUBMIT_CLAIMS_AMOUNT_NO END AS [Balance tot Current],
      CASE WHEN (LS.YTD_PENDING_CLAIMS_AMOUNT_NO IS NULL OR LS.YTD_SUBMIT_CLAIMS_AMOUNT_NO IS NULL) THEN NULL ELSE
      LS.YTD_PENDING_CLAIMS_AMOUNT_NO + LS.YTD_SUBMIT_CLAIMS_AMOUNT_NO END AS [Balance tot ytd],
      CASE WHEN (LS.[12MO_PENDING_CLAIMS_AMOUNT_NO] IS NULL OR LS.[12MO_SUBMIT_CLAIMS_AMOUNT_NO] IS NULL) THEN NULL ELSE
      LS.[12MO_PENDING_CLAIMS_AMOUNT_NO] + LS.[12MO_SUBMIT_CLAIMS_AMOUNT_NO] END AS [Balance tot 12mo],
      LS.PENDING_CLAIMS_AMOUNT_NO AS [Balance Pending Current],
      LS.YTD_PENDING_CLAIMS_AMOUNT_NO AS [Balance Pending ytd],
      LS.[12MO_PENDING_CLAIMS_AMOUNT_NO] AS [Balance Pending 12mo],
      LS.SUBMIT_CLAIMS_AMOUNT_NO AS [Balance Submitted Current],
      LS.YTD_SUBMIT_CLAIMS_AMOUNT_NO AS [Balance Submitted ytd],
      LS.[12MO_SUBMIT_CLAIMS_AMOUNT_NO] AS [Balance Submitted 12mo],
      LS.EXGRATIA_CLAIMS_AM_NO AS [Exgratia Claims Payment],
      LS.YTD_EXGRATIA_CLAIMS_AM_NO AS [Exgratia Claims Payment ytd],
      LS.[12MO_EXGRATIA_CLAIMS_AM_NO] AS [Exgratia Claims Payment 12mo],
      --Service Values
      LS.DOCUMENTS_VEHICLE_NO AS [Vehicle Scanned Keyed],
      LS.DOCUMENTS_MORTGAGE_NO AS [Mortgage Scanned Keyed],
      LS.DOCUMENTS_NO AS [Scanned Keyed],
      LS.EDI_VEHICLE_NO AS [EDI Vehicle],
      LS.EDI_MORTGAGE_NO AS [EDI Mortgage],
      LS.EDI_RECORDS_NO AS [EDI Records Processed],
      CASE WHEN (LS.DOCUMENTS_NO IS NULL OR LS.EDI_RECORDS_NO IS NULL) THEN NULL ELSE
      LS.DOCUMENTS_NO + LS.EDI_RECORDS_NO END AS [Doc Tot],

      LS.[NOTICES_VEHICLE_NO] AS [nVehicle],
      LS.[NOTICES_MORTGAGE_NO] AS [nMortgage],
      LS.[NOTICES_EQUIPMENT_NO] AS [nEquipment],
      LS.[CERTIFICATES_VEHICLE_NO] AS [cVehicle],
      LS.[CERTIFICATES_MORTGAGE_NO] AS [cMortgage],
      LS.[CERTIFICATES_EQUIPMENT_NO] AS [cEquipment],
      CASE WHEN (LS.[NOTICES_VEHICLE_NO] IS NULL OR LS.[NOTICES_MORTGAGE_NO] IS NULL OR LS.[NOTICES_EQUIPMENT_NO] IS NULL) THEN NULL ELSE
      LS.[NOTICES_VEHICLE_NO] + LS.[NOTICES_MORTGAGE_NO] + LS.[NOTICES_EQUIPMENT_NO] END AS [nTot],
      CASE WHEN (LS.[CERTIFICATES_VEHICLE_NO] IS NULL OR LS.[CERTIFICATES_MORTGAGE_NO] IS NULL OR LS.[CERTIFICATES_EQUIPMENT_NO] IS NULL) THEN NULL ELSE
      LS.[CERTIFICATES_VEHICLE_NO] + LS.[CERTIFICATES_MORTGAGE_NO] + LS.[CERTIFICATES_EQUIPMENT_NO] END AS [cTot],
      LS.INBOUND_CALL_NO AS [Calls Answered],
      LS.AVG_CALL_WAIT_NO AS [Average Speed of Answer],
      LS.OUTBOUND_CALL_NO AS [Calls Made],
      LS.AVG_CALL_DURATION_NO AS [Average Duration of Call],
      LS.WEB_VERIFICATION_NO AS [Web Verifications],
      LS.CHAT_NO AS [Chats],
      LS.CALL_SATISFACTION_NO AS [Calls Satisfaction Rate],
      --QuickPoint Usage data
      LS.QP_INQUIRIES_NO AS [QP Inquiries],
      LS.QP_VEH_INS_SBMT_NO AS [QP Veh Ins Submissions],
      LS.QP_MORT_INS_SBMT_NO AS [QP Mort Ins Submissions],
      LS.QP_INS_SBMT_NO AS [QP Ins Submissions],
      LS.QP_UTL_SBMT_NO AS [QP UTL Submissions],
      LS.QP_INS_INFO_NO AS [QP Ins Info Displayed],
      LS.QP_ADD_NOTE_NO AS [QP Notes Added],
      --Myinsuranceinfo Usage data
      LS.BSS_AGNT_SBMT_NO,
      LS.BSS_BRWR_SBMT_NO,
      LS.BSS_VEH_INS_SBMT_NO,
      LS.BSS_MORT_INS_SBMT_NO
FROM DBO.LENDER_DIM LD
   INNER JOIN DBO.MONTH_DIM MD (NOLOCK) ON MD.MONTH_NO = @MONTH AND MD.YEAR_NO = @YEAR
   INNER JOIN DBO.LENDER_DIM_ATTRIBUTE lda on ld.id = lda.lender_id 
      and datediff(d, lda.START_DT, @date) >= 0  and datediff(d, @date, ISNULL(lda.END_DT, GETDATE())) > 0
      and lda.TEST_ACCT_IN = 'N' and lda.ACTIVE_IN = 'Y' 
LEFT JOIN DBO.LENDER_SUMMARY_FACT LS (NOLOCK) ON ls.LENDER_ID = LD.ID and LS.MONTH_ID = MD.ID
WHERE LD.CODE_TX = @lenderCode
END

GO

