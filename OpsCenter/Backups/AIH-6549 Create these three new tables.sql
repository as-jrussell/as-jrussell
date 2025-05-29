USE [RepoPlusAnalytics]

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsoVehicleData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IsoVehicleData](
	[Vehicle_id] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyToTheLoss_id] [bigint] NULL,
	[RecordKey] [varchar](10) NULL,
	[AdjustingCompanyName] [varchar](55) NULL,
	[AdjusterLastName] [varchar](30) NULL,
	[AdjusterFirstName] [varchar](20) NULL,
	[AdjusterMiddleInitialName] [varchar](20) NULL,
	[AdjusterTelephoneNumber] [varchar](10) NULL,
	[LossType] [varchar](4) NULL,
	[CoverageType] [varchar](4) NULL,
	[VehicleYear] [varchar](4) NULL,
	[VehicleMake] [varchar](35) NULL,
	[VehicleModel] [varchar](35) NULL,
	[VehicleStyle] [varchar](2) NULL,
	[VehicleType] [varchar](2) NULL,
	[VehicleColor] [varchar](6) NULL,
	[VIN] [varchar](20) NULL,
	[VINValidation] [varchar](1) NULL,
	[MoreMatchIndicator1] [varchar](1) NULL,
	[EngineSerialNo] [varchar](14) NULL,
	[TransmissionSerialNo] [varchar](14) NULL,
	[ChassisSerialNo] [varchar](14) NULL,
	[VehicleOdometerReading] [varchar](10) NULL,
	[LicenseType] [varchar](2) NULL,
	[LicensePlate] [varchar](10) NULL,
	[LicensePlateState] [varchar](2) NULL,
	[LastYearRegistered] [varchar](4) NULL,
	[MoreMatchIndicator2] [varchar](1) NULL,
	[AntiTheftDeviceType] [varchar](2) NULL,
	[PointOfImpact] [varchar](2) NULL,
	[DriverAirbagStatus] [varchar](1) NULL,
	[PassengerAirbagStatus] [varchar](1) NULL,
	[LeftSideAirbagStatus] [varchar](1) NULL,
	[RightSideAirbagStatus] [varchar](1) NULL,
	[TheftTypeIndicator] [varchar](1) NULL,
	[ClaimStatus] [varchar](3) NULL,
	[SuitIndicator] [varchar](1) NULL,
	[ReserveAmount] [varchar](11) NULL,
	[SettlementAmount] [varchar](11) NULL,
	[DateClaimClosed] [datetime] NULL,
	[FailedVIN] [varchar](20) NULL,
	[VehicleDisposition] [varchar](1) NULL,
	[EstimateAmount] [varchar](11) NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[User_Name] [varchar](50) NULL
) ON [PRIMARY]
PRINT 'IsoVehicleData Table Created Successfully'
END
ELSE
	BEGIN
		PRINT 'TABLE EXISTS - Stop work'
	END

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsoCasualtyData]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[IsoCasualtyData](
	[Casualty_id] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyToTheLoss_id] [bigint] NULL,
	[RecordKey] [varchar](10) NULL,
	[AdjustingCompanyName] [varchar](55) NULL,
	[AdjusterLastName] [varchar](30) NULL,
	[AdjusterFirstName] [varchar](20) NULL,
	[AdjusterMiddleInitialName] [varchar](20) NULL,
	[AdjusterTelephoneNumber] [varchar](10) NULL,
	[LossType] [varchar](4) NULL,
	[CoverageType] [varchar](4) NULL,
	[AllegedInjuriesPropertyDamage] [varchar](50) NULL,
	[ClaimStatus] [varchar](3) NULL,
	[TortThresholdType] [varchar](2) NULL,
	[TortThresholdState] [varchar](2) NULL,
	[SuitIndicator] [varchar](1) NULL,
	[EstimatedLossAmount] [varchar](11) NULL,
	[ReserveAmount] [varchar](11) NULL,
	[SettlementAmount] [varchar](11) NULL,
	[DateClaimClosed] [datetime] NULL,
	[LossTimeStartDate] [datetime] NULL,
	[LossTimeEndDate] [datetime] NULL,
	[TotalLostDays] [varchar](5) NULL,
	[CourtFiled] [varchar](10) NULL,
	[CourtFileDate] [datetime] NULL,
	[CourtCounty] [varchar](25) NULL,
	[CourtState] [varchar](2) NULL,
	[DocketNumber] [varchar](22) NULL,
	[AdjusterEmailAddress] [varchar](50) NULL,
	[ERISAClaimIndicator] [varchar](1) NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[User_Name] [varchar](50) NULL
) ON [PRIMARY]
PRINT 'IsoCasualtyData Table Created Successfully'
END
ELSE
	BEGIN
		PRINT 'TABLE EXISTS - Stop work'
	END


/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsoPartyToTheLoss]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IsoPartyToTheLoss](
	[PartyToTheLoss_id] [bigint] IDENTITY(1,1) NOT NULL,
	[InsuranceData_id] [bigint] NULL,
	[RecordKey] [varchar](10) NULL,
	[RoleintheClaim] [varchar](2) NULL,
	[IndividualBusinessIndicator] [varchar](1) NULL,
	[BusinessNameOR] [varchar](70) NULL,
	[LastName] [varchar](70) NULL,
	[FirstName] [varchar](20) NULL,
	[MiddleName] [varchar](20) NULL,
	[DateofBirth] [varchar](10) NULL,
	[Gender] [varchar](1) NULL,
	[SocialSecurityNumber] [varchar](9) NULL,
	[MoreMatchIndicator] [varchar](1) NULL,
	[SSNCode] [varchar](1) NULL,
	[SSNIssuedFromDate] [varchar](4) NULL,
	[SSNIssuedToDate] [varchar](4) NULL,
	[SSNIssuingState] [varchar](2) NULL,
	[DeathMasterLastName] [varchar](30) NULL,
	[DeathMasterFirstName] [varchar](20) NULL,
	[DateofDeath] [datetime] NULL,
	[CityofDeath] [varchar](25) NULL,
	[StateofDeath] [varchar](2) NULL,
	[TaxIdentificationNumber] [varchar](9) NULL,
	[TINCode] [varchar](1) NULL,
	[TINIssuingCity] [varchar](25) NULL,
	[TINIssuingState] [varchar](2) NULL,
	[DriversLicenseNumber] [varchar](20) NULL,
	[DriversLicenseState] [varchar](2) NULL,
	[Occupation] [varchar](50) NULL,
	[MedicalProfessionalLicense] [varchar](15) NULL,
	[AddressInformationLine1] [varchar](50) NULL,
	[AddressInformationLine2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](2) NULL,
	[PostalCode] [varchar](9) NULL,
	[CountryCode] [varchar](3) NULL,
	[HomeTelephone] [varchar](10) NULL,
	[MoreMatchIndicator1] [varchar](1) NULL,
	[BusinessTelephone] [varchar](10) NULL,
	[CellularTelephone] [varchar](10) NULL,
	[MoreMatchIndicator2] [varchar](1) NULL,
	[PagerNumber] [varchar](10) NULL,
	[PagerPIN] [varchar](7) NULL,
	[Filler] [nvarchar](MAX) NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[User_Name] [varchar](50) NULL
) ON [PRIMARY]
PRINT 'IsoPartyToTheLoss Table Created Successfully'
END
ELSE
	BEGIN
		PRINT 'TABLE EXISTS - Stop work'
	END







