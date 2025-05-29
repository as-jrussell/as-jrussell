
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsoClaimData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IsoClaimData](
[iso_id] [bigint] IDENTITY(1,1) NOT NULL,
[RecordKey] varchar NULL,
[ClaimSearchIdentifier] varchar NOT NULL,
[InsuringCompanyCode] nvarchar NULL,
[PolicyNumber] nvarchar NULL,
[PolicyType] nvarchar NULL,
[PolicyInceptionDate] [datetime] NULL,
[PolicyExpirationDate] [datetime] NULL,
[ClaimNumber] nvarchar NULL,
[LossDescription] nvarchar NULL,
[LocationofLossCity] nvarchar NULL,
[RoleintheClaim] nvarchar NULL,
[IndividualBusinessIndicator] nvarchar NULL,
[AdjustingCompanyName] nvarchar NULL,
[LossType] nvarchar NULL,
[CoverageType] nvarchar NULL,
[VehicleYear] nvarchar NULL,
[VehicleMake] nvarchar NULL,
[VehicleModel] nvarchar NULL,
[VehicleColor] nvarchar NULL,
[VIN] nvarchar NULL,
[Created] [datetime] NULL,
[Modified] [datetime] NULL,
[User_Name] varchar NULL
) ON [PRIMARY]

	END
ELSE
	BEGIN
		PRINT 'TABLE EXISTS - Stop work'
	END