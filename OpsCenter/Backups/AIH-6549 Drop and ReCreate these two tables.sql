USE [RepoPlusAnalytics]




IF EXISTS(SELECT * from sys.tables where name ='IsoClaimData')
BEGIN
DROP TABLE [dbo].[IsoClaimData]
END
ELSE 
BEGIN 
PRINT 'No Table named IsoClaimData'
END



CREATE TABLE [dbo].[IsoClaimData](
	[iso_id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProcessDate] [datetime] NULL,
	[ISO_FileName] [varchar](200) NULL,
	[RecordKey] [varchar](50) NULL,
	[ClaimSearchIdentifier] [varchar](11) NOT NULL,
	[InsuringCompanyCode] [nvarchar](9) NULL,
	[PolicyNumber] [nvarchar](30) NULL,
	[PolicyType] [nvarchar](4) NULL,
	[PolicyInceptionDate] [datetime] NULL,
	[PolicyExpirationDate] [datetime] NULL,
	[ClaimNumber] [nvarchar](30) NULL,
	[LossDescription] [nvarchar](50) NULL,
	[LocationofLossCity] [nvarchar](50) NULL,
	[InsuredRoleintheClaim] [varchar](2) NULL,
	[InsuredIndividualBusinessIndicator] [nvarchar](1) NULL,
	[InsuredBusinessNameOR] [varchar](70) NULL,
	[InsuredLastName] [varchar](30) NULL,
	[InsuredFirstName] [varchar](20) NULL,
	[InsuredMiddleName] [varchar](20) NULL,
	[ClaimantRoleintheClaim] [varchar](2) NULL,
	[ClaimantIndividualBusinessIndicator] [nvarchar](1) NULL,
	[ClaimantBusinessNameOR] [varchar](70) NULL,
	[ClaimantLastName] [varchar](30) NULL,
	[ClaimantFirstName] [varchar](20) NULL,
	[ClaimantMiddleName] [varchar](20) NULL,
	[AdjustingCompanyName] [nvarchar](55) NULL,
	[LossType] [nvarchar](4) NULL,
	[CoverageType] [nvarchar](4) NULL,
	[VehicleYear] [nvarchar](4) NULL,
	[VehicleMake] [nvarchar](35) NULL,
	[VehicleModel] [nvarchar](35) NULL,
	[VehicleColor] [nvarchar](6) NULL,
	[VIN] [nvarchar](20) NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[User_Name] [varchar](50) NULL
) ON [PRIMARY]
PRINT 'IsoClaimData Table Created Successfully'






IF EXISTS(SELECT * from sys.tables where name ='IsoInsuranceData')
BEGIN
DROP TABLE [dbo].[IsoInsuranceData]
END
ELSE 
BEGIN 
PRINT 'No Table named IsoInsuranceData'
END


CREATE TABLE [dbo].[IsoInsuranceData](
	[InsuranceData_id] [bigint] IDENTITY(1,1) NOT NULL,
	[iso_id] [bigint] NULL,
	[Parent_ClaimSearchIdentifier] [varchar](11) NULL,
	[RecordKey] [varchar](50) NULL,
	[ClaimSearchIdentifier] [varchar](50) NULL,
	[InsuringCompanyName] [varchar](50) NULL,
	[InsuringCompanyAddress] [varchar](50) NULL,
	[InsuringCompanyAddress2] [varchar](50) NULL,
	[InsuringCompanyCity] [varchar](50) NULL,
	[InsuringCompanyStateProvince] [varchar](50) NULL,
	[InsuringCompanyPostalCode] [varchar](50) NULL,
	[InsuringCompanyCountry] [varchar](50) NULL,
	[InsuringCompanyPhone] [varchar](50) NULL,
	[PolicyNumber] [varchar](50) NULL,
	[PolicyType] [varchar](50) NULL,
	[PolicyInceptionDate] [datetime] NULL,
	[PolicyExpirationDate] [datetime] NULL,
	[PolicyRenewalIndicatorYN] [varchar](50) NULL,
	[AssignedRiskPolicyIndicator] [varchar](50) NULL,
	[ClaimNumber] [varchar](50) NULL,
	[DateofLoss] [datetime] NULL,
	[TimeOfLoss] [varchar](50) NULL,
	[CATIndicator] [varchar](50) NULL,
	[CAT] [varchar](50) NULL,
	[CompanyReceivedDate] [datetime] NULL,
	[AgencyNotifiedofLossPoliceFire] [varchar](50) NULL,
	[PoliceFireReportCaseNumber] [varchar](50) NULL,
	[LossDescription] [varchar](50) NULL,
	[HitandRunIndicator] [varchar](50) NULL,
	[8FFundClaim] [varchar](50) NULL,
	[VesselCallNumber] [varchar](50) NULL,
	[MoldIndicator] [varchar](50) NULL,
	[StatementofDisputeIndicator] [varchar](50) NULL,
	[ClaimReferredtoNICBIndicator] [varchar](50) NULL,
	[MassTortIndicator] [varchar](50) NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[User_Name] [varchar](50) NULL,
	[LossLocationAddressLine1] [varchar](50) NULL,
	[LossLocationAddressLine2] [varchar](50) NULL,
	[LossLocationCity] [varchar](25) NULL,
	[LossLocationState] [varchar](2) NULL,
	[LossLocationCountry] [varchar](3) NULL,
	[LossLocationPostalCode] [varchar](9) NULL
) ON [PRIMARY]
PRINT 'IsoInsuranceData Table Created Successfully'

