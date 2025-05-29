use RepoPlusAnalytics 

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsoInsuranceData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IsoInsuranceData](
[id] [bigint] IDENTITY(1,1) NOT NULL,
[iso_id] [bigint] NULL,
[Parent_ClaimSearchIdentifier] varchar NULL,
[RecordKey] varchar NULL,
[ClaimSearchIdentifier] varchar NULL,
[InsuringCompanyName] varchar NULL,
[InsuringCompanyAddress] varchar NULL,
[InsuringCompanyAddress2] varchar NULL,
[InsuringCompanyCity] varchar NULL,
[InsuringCompanyStateProvince] varchar NULL,
[InsuringCompanyPostalCode] varchar NULL,
[InsuringCompanyCountry] varchar NULL,
[InsuringCompanyPhone] varchar NULL,
[PolicyNumber] varchar NULL,
[PolicyType] varchar NULL,
[PolicyInceptionDate] [datetime] NULL,
[PolicyExpirationDate] [datetime] NULL,
[PolicyRenewalIndicatorYN] varchar NULL,
[AssignedRiskPolicyIndicator] varchar NULL,
[ClaimNumber] varchar NULL,
[DateofLoss] [datetime] NULL,
[TimeOfLoss] varchar NULL,
[CATIndicator] varchar NULL,
[CAT] varchar NULL,
[CompanyReceivedDate] [datetime] NULL,
[AgencyNotifiedofLossPoliceFire] varchar NULL,
[PoliceFireReportCaseNumber] varchar NULL,
[LossDescription] varchar NULL,
[HitandRunIndicator] varchar NULL,
[8FFundClaim] varchar NULL,
[VesselCallNumber] varchar NULL,
[MoldIndicator] varchar NULL,
[StatementofDisputeIndicator] varchar NULL,
[ClaimReferredtoNICBIndicator] varchar NULL,
[MassTortIndicator] varchar NULL,
[Created] [datetime] NULL,
[Modified] [datetime] NULL,
[User_Name] varchar NULL
) ON [PRIMARY]

	END
ELSE
	BEGIN
		PRINT 'TABLE EXISTS - Stop work'
	END