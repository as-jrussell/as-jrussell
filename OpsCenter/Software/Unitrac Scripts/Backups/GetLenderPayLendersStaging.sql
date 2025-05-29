USE UniTrac


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetLenderPayLenders]
(
	@agencyId bigint,
    @billingFrequency varchar(20)
)
AS
BEGIN
   SET NOCOUNT ON;

   declare @curDate datetime = GetDate()

   select distinct mp.LENDER_ID
   from MASTER_POLICY mp
      join MASTER_POLICY_ASSIGNMENT mpa on mpa.MASTER_POLICY_ID = mp.ID and mpa.PURGE_DT is null
      join MASTER_POLICY_ENDORSEMENT mpe on mpe.MASTER_POLICY_ASSIGNMENT_ID = mpa.ID and mpe.PURGE_DT is null 
	  JOIN POLICY_ENDORSEMENT pe ON pe.ID = mpe.POLICY_ENDORSEMENT_ID and pe.LENDER_PAY_IN = 'Y' AND pe.PURGE_DT IS NULL
      join LENDER ldr on ldr.ID = mp.LENDER_ID and ldr.PURGE_DT is null
   where ldr.AGENCY_ID = @agencyId
	  and ldr.TEST_IN = 'N'
      and mp.LENDER_PAY_ENDORSEMENT_ACTIVE_IN = 'Y'
      and mp.POLICY_ENDORSEMENT_BILLING_FREQ_CD = @billingFrequency
      and mp.PURGE_DT is null
      and @curDate between mp.START_DT and mp.END_DT
      and @curDate between mpa.START_DT and mpa.END_DT
      and @curDate between mpe.START_DT and mpe.END_DT
END
GO
