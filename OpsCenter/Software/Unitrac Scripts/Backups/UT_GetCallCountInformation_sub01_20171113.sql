USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[UT_GetCallCountInformation]    Script Date: 11/14/2017 8:22:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE Procedure [dbo].[UT_GetCallCountInformation]
(
	@LastRun AS DATETIME
)
as
BEGIN
	Declare @StartDate as datetime
	Declare @EndDate as datetime

	Set @StartDate = convert(varchar(20),dateadd(d,(day(@LastRun)*-1)+1,@LastRun),101)
	Set @EndDate = DATEADD(m, 1, @StartDate)

   --inbound calls
  Select L.CODE_TX as LENDER_CODE_TX, 'I' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
  Join LENDER L on L.ID = P.LENDER_ID
  where H.TYPE_CD = 'INBNDCALL' and H.PROPERTY_ID IS NOT NULL and H.CREATE_DT > @StartDate and H.CREATE_DT < @EndDate and H.PURGE_DT is NULL
  Group by L.CODE_TX,MONTH(H.CREATE_DT),YEAR(H.CREATE_DT)
   UNION
   Select L.CODE_TX as LENDER_CODE_TX, 'I' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
  Join LENDER L on L.ID = LN.LENDER_ID
  where H.TYPE_CD = 'INBNDCALL' and H.LOAN_ID IS NOT NULL and H.CREATE_DT > @StartDate and H.CREATE_DT < @EndDate and H.PURGE_DT is NULL
  Group by L.CODE_TX,MONTH(H.CREATE_DT),YEAR(H.CREATE_DT)
   UNION
   Select L.CODE_TX as LENDER_CODE_TX, 'C' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
  Join LENDER L on L.ID = LN.LENDER_ID
  where H.TYPE_CD = 'INBNDCALL' and H.LOAN_ID IS NOT NULL and H.CREATE_DT > @StartDate and H.CREATE_DT < @EndDate and H.PURGE_DT is NULL 
        and (H.SPECIAL_HANDLING_XML.value('(//SH/LiveChat)[1]', 'varchar(50)') = 'Y')
  Group by L.CODE_TX,MONTH(H.CREATE_DT),YEAR(H.CREATE_DT)
   UNION
  Select L.CODE_TX as LENDER_CODE_TX, 'S' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
  Join LENDER L on L.ID = P.LENDER_ID
  where H.TYPE_CD = 'INBNDCALL' and H.PROPERTY_ID IS NOT NULL and H.CREATE_DT > @StartDate and H.CREATE_DT < @EndDate and H.PURGE_DT is NULL
        and (H.SPECIAL_HANDLING_XML.value('(//SH/CallerSatisfied)[1]', 'varchar(50)') = 'Y')
  Group by L.CODE_TX,MONTH(H.CREATE_DT),YEAR(H.CREATE_DT)
     UNION
  Select L.CODE_TX as LENDER_CODE_TX, 'S' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
  Join LENDER L on L.ID = LN.LENDER_ID
  where H.TYPE_CD = 'INBNDCALL' and H.LOAN_ID IS NOT NULL and H.CREATE_DT > @StartDate and H.CREATE_DT < @EndDate and H.PURGE_DT is NULL 
        and (H.SPECIAL_HANDLING_XML.value('(//SH/CallerSatisfied)[1]', 'varchar(50)') = 'Y')
  Group by L.CODE_TX,MONTH(H.CREATE_DT),YEAR(H.CREATE_DT)
   UNION
  Select L.CODE_TX as LENDER_CODE_TX, 'O' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
  Join LENDER L on L.ID = P.LENDER_ID
  where H.TYPE_CD = 'VRFCTNEVT' and H.PROPERTY_ID IS NOT NULL and H.UPDATE_DT > @StartDate and H.UPDATE_DT < @EndDate and H.PURGE_DT is NULL 
	AND isnull(H.SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar(10)'), 'Approve') != 'OnHold'
	AND H.SPECIAL_HANDLING_XML.value('(/SH/OutboundCallsMade)[1]', 'int') > 0
	AND H.SPECIAL_HANDLING_XML.value('(//SH/WebVerification)[1]', 'varchar(5)') != 'Y'
	AND H.SPECIAL_HANDLING_XML.value('(/SH/SubResolutionCode)[1]', 'varchar(10)') not in ('V', 'PV')
  Group by L.CODE_TX,MONTH(H.UPDATE_DT),YEAR(H.UPDATE_DT)
   UNION
  Select L.CODE_TX as LENDER_CODE_TX, 'O' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
  Join LENDER L on L.ID = LN.LENDER_ID
  where H.TYPE_CD = 'VRFCTNEVT' and H.LOAN_ID IS NOT NULL and H.UPDATE_DT > @StartDate and H.UPDATE_DT < @EndDate and H.PURGE_DT is NULL 
	AND isnull(H.SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar(10)'), 'Approve') != 'OnHold'
	AND H.SPECIAL_HANDLING_XML.value('(/SH/OutboundCallsMade)[1]', 'int') > 0
	AND H.SPECIAL_HANDLING_XML.value('(//SH/WebVerification)[1]', 'varchar(5)') != 'Y'
	AND H.SPECIAL_HANDLING_XML.value('(/SH/SubResolutionCode)[1]', 'varchar(10)') not in ('V', 'PV')
  Group by L.CODE_TX,MONTH(H.UPDATE_DT),YEAR(H.UPDATE_DT)
   UNION
  Select L.CODE_TX as LENDER_CODE_TX, 'W' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
  Join LENDER L on L.ID = P.LENDER_ID
  where H.TYPE_CD = 'VRFCTNEVT' and H.PROPERTY_ID IS NOT NULL and H.UPDATE_DT > @StartDate and H.UPDATE_DT < @EndDate and H.PURGE_DT is NULL 
  	AND isnull(H.SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar(10)'), 'Approve') != 'OnHold'
	and (H.SPECIAL_HANDLING_XML.value('(//SH/WebVerification)[1]', 'varchar(5)') = 'Y'
		OR H.SPECIAL_HANDLING_XML.value('(/SH/SubResolutionCode)[1]', 'varchar(10)') in ('V', 'PV'))
  Group by L.CODE_TX,MONTH(H.CREATE_DT),YEAR(H.CREATE_DT)
   UNION
  Select L.CODE_TX as LENDER_CODE_TX, 'W' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from UNITRAC.dbo.INTERACTION_HISTORY H
  join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
  Join LENDER L on L.ID = LN.LENDER_ID
  where H.TYPE_CD = 'VRFCTNEVT' and H.LOAN_ID IS NOT NULL and H.UPDATE_DT > @StartDate and H.UPDATE_DT < @EndDate and H.PURGE_DT is NULL 
	AND isnull(H.SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar(10)'), 'Approve') != 'OnHold'
	and (H.SPECIAL_HANDLING_XML.value('(//SH/WebVerification)[1]', 'varchar(5)') = 'Y'
		OR H.SPECIAL_HANDLING_XML.value('(/SH/SubResolutionCode)[1]', 'varchar(10)') in ('V', 'PV'))
  Group by L.CODE_TX,MONTH(H.CREATE_DT),YEAR(H.CREATE_DT)
    UNION
  Select L.CODE_TX as LENDER_CODE_TX, 'W' as TYPE_TX,COUNT(*) as [COUNT_NO],MONTH(@StartDate) as MONTH_NO, YEAR(@StartDate) as YEAR_NO
  from DOCUMENT_CONTAINER D
  Join NOTICE N on N.ID = D.RELATE_ID and D.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'
  Join LOAN LN on LN.ID = N.LOAN_ID
  Join LENDER L on L.ID = LN.LENDER_ID
  where D.CREATE_DT > @StartDate and D.CREATE_DT < @EndDate and D.REJECT_REASON_TX = 'VerifiedCoverageWeb'
  Group by L.CODE_TX,MONTH(D.CREATE_DT),YEAR(D.CREATE_DT)
END


GO

