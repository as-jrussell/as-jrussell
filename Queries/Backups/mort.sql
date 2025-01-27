USE [master]
GO
/****** Object:  Database [UNITRAC_MORTGAGE]    Script Date: 7/14/2021 8:29:47 PM ******/
CREATE DATABASE [UNITRAC_MORTGAGE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'UNITRAC_MORTGAGE', FILENAME = N'C:\Downloads\UNITRAC_MORTGAGE.mdf' , SIZE = 512KB , MAXSIZE = 2048MB, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'UNITRAC_MORTGAGE_log', FILENAME = N'C:\Downloads\UNITRAC_MORTGAGE_log.ldf' , SIZE = 512KB , MAXSIZE = 2048MB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [UNITRAC_MORTGAGE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET ARITHABORT OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET  DISABLE_BROKER 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET RECOVERY FULL 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET  MULTI_USER 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'UNITRAC_MORTGAGE', N'ON'
GO
USE [UNITRAC_MORTGAGE]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_EscrowEx_Duplicates]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CAL -- Coverage amount < 1000
CREATE function [dbo].[fn_EscrowEx_Duplicates]
(
   @EscrowID bigint
)



RETURNS nvarchar(30) 
AS 
BEGIN 

DECLARE @reasonCode nvarchar(30) 
SET @reasonCode = null 

	SELECT top 1 @reasonCode = 'DUPLICATE' 
   
	FROM
   		ESCROW
		JOIN ESCROW_REQUIRED_COVERAGE_RELATE on ESCROW_REQUIRED_COVERAGE_RELATE.ESCROW_ID = ESCROW.ID and ESCROW_REQUIRED_COVERAGE_RELATE.PURGE_DT is null
		JOIN ESCROW_REQUIRED_COVERAGE_RELATE as PRIOR_ESCROW_REQUIRED_COVERAGE_RELATE on PRIOR_ESCROW_REQUIRED_COVERAGE_RELATE.REQUIRED_COVERAGE_ID = ESCROW_REQUIRED_COVERAGE_RELATE.REQUIRED_COVERAGE_ID
				AND PRIOR_ESCROW_REQUIRED_COVERAGE_RELATE.purge_dt IS NULL
		JOIN ESCROW as PRIOR_ESCROW on PRIOR_ESCROW.ID = PRIOR_ESCROW_REQUIRED_COVERAGE_RELATE.ESCROW_ID
				AND PRIOR_ESCROW.purge_dt IS NULL
			
			
	WHERE 1=1
		AND ESCROW.ID = @escrowId 
		AND PRIOR_ESCROW.ID <> ESCROW.ID 
		AND PRIOR_ESCROW.TYPE_CD = ESCROW.TYPE_CD 
		AND PRIOR_ESCROW.SUB_TYPE_CD = ESCROW.SUB_TYPE_CD 
		AND PRIOR_ESCROW.EXCESS_IN = ESCROW.EXCESS_IN 

		AND 
		(
		   PRIOR_ESCROW.Status_cd = 'OPEN' 
		   or 
		   ( 
       			PRIOR_ESCROW.Status_cd = 'CLSE' AND PRIOR_ESCROW.sub_status_cd in ( 'LNDRPAID', 'RPTD', 'INHSPAID', 'BWRPAID' )   
		   ) 
		) 

		AND abs(DATEDIFF(DAY, PRIOR_ESCROW.END_DT, ESCROW.END_DT)) < 60 
		AND ESCROW.PREMIUM_NO > 0 

	RETURN @reasonCode 

END 

GO
/****** Object:  UserDefinedFunction [dbo].[fn_EscrowEx_NewLoan]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CAL -- Coverage amount < 1000
CREATE function [dbo].[fn_EscrowEx_NewLoan]
(
   @EscrowID bigint
)


RETURNS nvarchar(30) 
AS 
BEGIN 

DECLARE @reasonCode nvarchar(30) 
SET @reasonCode = null 

SELECT top 1 @reasonCode = 'NEWLOAN' 
   
FROM
   	ESCROW
	JOIN LOAN on LOAN.ID = ESCROW.LOAN_ID and LOAN.purge_dt IS NULL
			
WHERE 1=1
	AND ESCROW.ID = @escrowId 
	AND ESCROW.PREMIUM_NO > 0 

    AND 
	(
		DATEDIFF(MONTH, LOAN.EFFECTIVE_DT, ESCROW.DUE_DT) < 6
		or
		DATEDIFF(MONTH, LOAN.EFFECTIVE_DT, ESCROW.EFFECTIVE_DT) < 6	
	)

RETURN @reasonCode 

END 

GO
/****** Object:  Table [dbo].[ba_ba_types]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ba_ba_types](
	[ba_map_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ba_ID] [bigint] NOT NULL,
	[ba_type_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ba_types]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ba_types](
	[ba_type_id] [bigint] NOT NULL,
	[ba_type] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BadLoans]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BadLoans](
	[theText] [char](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[banklist]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[banklist](
	[INSTITUTION] [nvarchar](255) NULL,
	[COMPANY_ADDRESS] [nvarchar](255) NULL,
	[COMPANY_CITY] [nvarchar](255) NULL,
	[COMPANY_STATE] [nvarchar](255) NULL,
	[COMPANY_ZIP] [nvarchar](255) NULL,
	[INSTITUTION_TYPE] [nvarchar](255) NULL,
	[STATE] [nvarchar](5) NULL,
	[LOAN_COUNT] [bigint] NULL,
	[DOLLAR_VOLUME] [bigint] NULL,
	[PURCH_LOAN_COUNT] [bigint] NULL,
	[PURCH_DOLLAR_VOLUME] [bigint] NULL,
	[REFI_LOAN_COUNT] [bigint] NULL,
	[REFI_DOLLAR_VOLUME] [bigint] NULL,
	[CONV_LOAN_COUNT] [bigint] NULL,
	[CONV_DOLLAR_VOLUME] [bigint] NULL,
	[JUMBO_LOAN_COUNT] [bigint] NULL,
	[JUMBO_DOLLAR_VOLUME] [bigint] NULL,
	[FHA_LOAN_COUNT] [bigint] NULL,
	[FHA_DOLLAR_VOLUME] [bigint] NULL,
	[VA_LOAN_COUNT] [bigint] NULL,
	[VA_DOLLAR_VOLUME] [bigint] NULL,
	[USDA_LOAN_COUNT] [bigint] NULL,
	[USDA_DOLLAR_VOLUME] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[business_associates]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[business_associates](
	[ba_id] [bigint] NULL,
	[ba_name] [varchar](150) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CoastalHighRisk]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoastalHighRisk](
	[ZipCode] [varchar](5) NULL,
	[Desc_tx] [varchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CVSymitarIns]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CVSymitarIns](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[PURGE_DT] [datetime] NULL,
	[AccountNumber] [char](18) NULL,
	[LoanSuffix] [char](18) NULL,
	[Parcel_No] [char](20) NULL,
	[CoverageType] [char](20) NULL,
	[Action] [char](20) NULL,
	[EscrowIndicator] [char](1) NULL,
	[PayeeCode] [char](100) NULL,
	[CompanyName] [char](100) NULL,
	[PolicyNumber] [char](18) NULL,
	[EffectiveDate] [date] NULL,
	[ExpirationDate] [date] NULL,
	[CoverageAmount] [decimal](19, 8) NOT NULL,
	[PremiumDueDate] [date] NULL,
	[PremiumAmount] [decimal](19, 8) NOT NULL,
	[SupplementalIndicator] [char](1) NULL,
	[AnnualPremiumAmount] [decimal](19, 8) NOT NULL,
	[Term] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DNA_INSIMPORT]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DNA_INSIMPORT](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[LoanNumber] [char](18) NULL,
	[CollateralID] [char](20) NULL,
	[PolicyNumber] [char](20) NULL,
	[CoverageType] [char](20) NULL,
	[LenderPlacedYN] [char](1) NULL,
	[Action] [char](20) NULL,
	[SubAction] [char](20) NULL,
	[EscrowIndicator] [char](1) NULL,
	[PayeeCode] [char](20) NULL,
	[CompanyName] [char](100) NULL,
	[ExternalPolicyNumber] [char](30) NULL,
	[EffectiveDate] [char](10) NULL,
	[ExpirationDate] [char](10) NULL,
	[CoverageAmount] [char](18) NULL,
	[PremiumDueDate] [char](10) NULL,
	[PremiumAmount] [char](18) NULL,
	[SupplementalIndicator] [char](1) NULL,
	[AnnualPremiumAmount] [char](18) NULL,
	[PremiumFrequency] [char](10) NULL,
	[PURGE_DT] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DNAExtractReview]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DNAExtractReview](
	[ACCOUNTNUMBER] [char](18) NULL,
	[MEMBERNUMBER] [char](10) NULL,
	[LASTNAME] [char](20) NULL,
	[LoanTypeCodeCollateralCode] [char](4) NULL,
	[CURRENTLOANBALANCE] [char](12) NULL,
	[LOANBRANCH] [char](4) NULL,
	[INSURANCEAGENTNAME] [char](15) NULL,
	[INSURANCEAGENTPhone] [char](10) NULL,
	[INSURANCECOMPANYName] [char](10) NULL,
	[INSURANCEPOLICYNumber] [char](17) NULL,
	[REALESTATEPROPERTY] [char](45) NULL,
	[FLOODZONE] [char](6) NULL,
	[ESCROW_Y_N] [char](1) NULL,
	[CONDOY_N] [char](1) NULL,
	[PremiumAmount] [char](12) NULL,
	[InsuranceExpirationDate] [char](8) NULL,
	[PayeeCode] [char](30) NULL,
	[CoverageType] [char](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FICS_FS]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICS_FS](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FILE_NAME_TX] [char](100) NULL,
	[HEADER_TX] [char](1200) NULL,
	[HEADER_EXTRA_TX] [char](1200) NULL,
	[FOOTER_TX] [char](1200) NULL,
	[Interchange_dt] [date] NULL,
	[STAGING_AREA_TX] [char](25) NULL,
	[Create_user_tx] [char](140) NOT NULL,
	[Create_dt] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FICSExtract]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICSExtract](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[File_ID] [bigint] NOT NULL,
	[LoanNumber] [varchar](21) NULL,
	[CostCenter] [varchar](30) NULL,
	[GSEIndicator] [varchar](128) NULL,
	[LoanOfficerCodeorInitials] [varchar](128) NULL,
	[InsurableValue] [varchar](128) NULL,
	[FloodRequiredFlag] [varchar](128) NULL,
	[LoanOpenDate] [varchar](128) NULL,
	[LoanMaturityDate] [varchar](128) NULL,
	[PaidOutDate] [varchar](128) NULL,
	[LoanBalance] [varchar](128) NULL,
	[MaxCreditLineAmount] [varchar](128) NULL,
	[OriginalLoanAmount] [varchar](128) NULL,
	[LoanTypeClassCodesCallCodes] [varchar](128) NULL,
	[LoanOriginationSystemTrackingNumber] [varchar](128) NULL,
	[CollateralCode] [varchar](128) NULL,
	[CollateralSequenceIdentifier] [varchar](128) NULL,
	[PropertyStreetAddress] [varchar](128) NULL,
	[PropertyCityStateZip] [varchar](128) NULL,
	[PropertyType] [varchar](128) NULL,
	[FloodZone] [varchar](128) NULL,
	[ConstructionType] [varchar](128) NULL,
	[RoofType] [varchar](128) NULL,
	[NumberofStories] [varchar](128) NULL,
	[BorrowerName] [varchar](128) NULL,
	[BorrowerShortName] [varchar](128) NULL,
	[CommercialorBusinessName] [varchar](128) NULL,
	[CoBorrowerName] [varchar](128) NULL,
	[BorrowerMailing] [varchar](128) NULL,
	[BorrowerphoneNumber] [varchar](128) NULL,
	[CIFNumber] [varchar](128) NULL,
	[SocialSecurityNumber] [varchar](128) NULL,
	[InsuranceTypeCodes] [varchar](128) NULL,
	[LienPosition] [varchar](128) NULL,
	[InsuranceDisbursementTypes] [varchar](128) NULL,
	[EscrowIndicator] [varchar](128) NULL,
	[InsurancePayeeCode] [varchar](128) NULL,
	[InsurancePolicyNumber] [varchar](128) NULL,
	[InsuranceInceptionDate] [varchar](128) NULL,
	[InsuranceExpirationDate] [varchar](128) NULL,
	[InsuranceDisbursementDueDate] [varchar](128) NULL,
	[AmountofCoverage] [varchar](128) NULL,
	[PremiumAmount] [varchar](128) NULL,
	[InsuranceDisbursementDueDate2] [varchar](128) NULL,
	[AgentInfo] [varchar](128) NULL,
	[PayeeName] [varchar](128) NULL,
	[CoBorrowerMailAddressCityStateZip] [varchar](128) NULL,
	[BorrowerMailAddressCityStateZip] [varchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[File_A]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File_A](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[File_dt] [date] NULL,
	[File_name_tx] [char](255) NULL,
	[Transaction_type] [char](1) NULL,
	[Institution_number] [char](3) NULL,
	[Loan_number] [char](10) NULL,
	[Prior_loan_number] [char](20) NULL,
	[Borrower_name1] [char](35) NULL,
	[Mail_line1] [char](35) NULL,
	[Mail_line2] [char](35) NULL,
	[Mail_city] [char](21) NULL,
	[Mail_state] [char](2) NULL,
	[Mail_zip] [char](9) NULL,
	[Dist_mail_code] [char](1) NULL,
	[Borrower_name2] [char](35) NULL,
	[Home_phone] [char](10) NULL,
	[Work_phone] [char](10) NULL,
	[Date_of_loan] [date] NULL,
	[Servicing_date] [date] NULL,
	[Maturity_date] [date] NULL,
	[Drop_loan_code] [char](2) NULL,
	[Paid_in_full_date] [date] NULL,
	[Lock_out_code] [char](1) NULL,
	[Warning_code] [char](1) NULL,
	[Stop_code] [char](3) NULL,
	[Bankrupt_code] [char](1) NULL,
	[Second_mortgage_code] [char](1) NULL,
	[Other_loan_number] [char](10) NULL,
	[Purpose_code] [char](2) NULL,
	[Loan_type] [char](1) NULL,
	[Loan_sub_type] [char](1) NULL,
	[Property_type_code] [char](3) NULL,
	[Occupied_code] [char](1) NULL,
	[Original_balance] [decimal](19, 8) NOT NULL,
	[Remaining_balance] [decimal](19, 8) NOT NULL,
	[Escrow_flag] [char](1) NULL,
	[Investor_code] [char](5) NULL,
	[Prop_line1] [char](40) NULL,
	[Prop_line2] [char](40) NULL,
	[Prop_city] [char](28) NULL,
	[Prop_state] [char](2) NULL,
	[Prop_zip] [char](9) NULL,
	[Prop_county] [char](3) NULL,
	[Prop_year] [char](4) NULL,
	[Flood_required_code] [char](1) NULL,
	[Filler1] [char](3) NULL,
	[Flood_map_panel] [char](11) NULL,
	[Flood_map_panel_date] [date] NULL,
	[Flood_Community_number] [char](7) NULL,
	[Flood_determination_date] [date] NULL,
	[Flood_program_code] [char](1) NULL,
	[Closed_code] [char](1) NULL,
	[Sale_price] [decimal](19, 8) NOT NULL,
	[Org_code1] [char](5) NULL,
	[Org_code2] [char](5) NULL,
	[Org_code3] [char](5) NULL,
	[Org_code4] [char](5) NULL,
	[Borrower_tax_id] [char](9) NULL,
	[Flood_zone] [char](7) NULL,
	[Flood_comm] [char](6) NULL,
	[Outsourcer_code] [char](2) NULL,
	[Entity_number] [char](3) NULL,
	[Filler2] [char](63) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[File_B]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File_B](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[File_dt] [date] NULL,
	[File_name_tx] [char](255) NULL,
	[Transaction_type] [char](1) NULL,
	[Institution_number] [char](3) NULL,
	[Loan_number] [char](10) NULL,
	[Insurance_line_type] [char](2) NULL,
	[Multiple_policy_ind] [char](1) NULL,
	[Escrow_flag] [char](1) NULL,
	[Company_payee_code] [char](4) NULL,
	[Agency_payee_code] [char](5) NULL,
	[Next_remittance_date] [date] NULL,
	[Policy_effective_date] [date] NULL,
	[Policy_expiration_date] [date] NULL,
	[Premium_amount_due] [decimal](19, 8) NOT NULL,
	[Policy_term] [int] NOT NULL,
	[Coverage_amount] [decimal](19, 8) NOT NULL,
	[Policy_number] [varchar](30) NULL,
	[Escrow_line_payee_flag] [char](1) NULL,
	[Coverage_code] [char](1) NULL,
	[Org_code1] [char](5) NULL,
	[Org_code2] [char](5) NULL,
	[Org_code3] [char](5) NULL,
	[Org_code4] [char](5) NULL,
	[Entity_number] [char](3) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[File_C]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File_C](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[File_dt] [date] NULL,
	[File_name_tx] [char](255) NULL,
	[Transaction_type] [int] NOT NULL,
	[Institution_numer] [char](3) NULL,
	[Insurance_line_type] [char](2) NULL,
	[Multiple_policy_ind] [char](1) NULL,
	[Loan_number] [char](12) NULL,
	[Transaction_seq_no] [int] NOT NULL,
	[Escrow_flag] [char](1) NULL,
	[Company_payee_code] [char](4) NULL,
	[Agency_payee_code] [char](5) NULL,
	[Next_remittance_date] [date] NULL,
	[Policy_expiration_date] [date] NULL,
	[Premium_amount_due] [decimal](19, 8) NOT NULL,
	[Policy_term] [int] NOT NULL,
	[Coverage_amount] [decimal](19, 8) NOT NULL,
	[Policy_number] [char](30) NULL,
	[Escrow_line_payee_flag] [char](1) NULL,
	[Coverage_code] [char](1) NULL,
	[Refund_amount] [decimal](19, 8) NOT NULL,
	[Corporate_advance_fee_type] [char](3) NULL,
	[Override] [int] NOT NULL,
	[Disburse_override] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuardianLSAMSBackfeed]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuardianLSAMSBackfeed](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[LoanNumber] [char](18) NULL,
	[EscrowType] [char](20) NULL,
	[Sequence] [char](30) NULL,
	[CoverageType] [char](30) NULL,
	[OwnerIndicator] [char](1) NULL,
	[PolicyTypeIndicator] [char](20) NULL,
	[Action] [char](20) NULL,
	[SubAction] [char](20) NULL,
	[EscrowIndicator] [char](1) NULL,
	[PayeeCode] [char](20) NULL,
	[CompanyName] [char](100) NULL,
	[PolicyNumber] [char](30) NULL,
	[EffectiveDate] [date] NULL,
	[ExpirationDate] [date] NULL,
	[CancelEffectiveDate] [date] NULL,
	[CoverageAmount] [decimal](19, 8) NOT NULL,
	[PremiumDueDate] [date] NULL,
	[Term] [int] NOT NULL,
	[PremiumAmount] [decimal](19, 8) NOT NULL,
	[SupplementalIndicator] [char](1) NULL,
	[AnnualPremiumAmount] [decimal](19, 8) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HSLoanSale]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HSLoanSale](
	[SaleSet] [int] NULL,
	[LoanNumber] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Integration_File]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Integration_File](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Int_Code_TX] [char](30) NULL,
	[FILE_NAME_TX] [char](100) NULL,
	[Lender_code_tx] [char](20) NULL,
	[Lender_name_tx] [char](100) NULL,
	[LENDER_ID] [bigint] NOT NULL,
	[Interchange_dt] [date] NULL,
	[FileType_tx] [char](25) NULL,
	[Sub_FileType_tx] [char](25) NULL,
	[WI_ID] [bigint] NOT NULL,
	[Create_user_tx] [char](140) NOT NULL,
	[Create_dt] [datetime] NOT NULL,
	[Live_IN_tx] [char](1) NULL,
	[Purge_dt] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanServ_Codes]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanServ_Codes](
	[Domain_tx] [varchar](40) NULL,
	[Code_tx] [varchar](20) NULL,
	[Meaning_tx] [varchar](128) NULL,
	[Lender_code_tx] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanServ_File_A]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanServ_File_A](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[Transaction_type] [char](1) NULL,
	[Institution_number] [char](3) NULL,
	[Loan_number] [char](10) NULL,
	[Prior_loan_number] [char](20) NULL,
	[Borrower_name1] [char](35) NULL,
	[Mail_line1] [char](35) NULL,
	[Mail_line2] [char](35) NULL,
	[Mail_city] [char](21) NULL,
	[Mail_state] [char](2) NULL,
	[Mail_zip] [char](9) NULL,
	[Dist_mail_code] [char](1) NULL,
	[Borrower_name2] [char](35) NULL,
	[Home_phone] [char](10) NULL,
	[Work_phone] [char](10) NULL,
	[Date_of_loan] [date] NULL,
	[Servicing_date] [date] NULL,
	[Maturity_date] [date] NULL,
	[Drop_loan_code] [char](2) NULL,
	[Paid_in_full_date] [date] NULL,
	[Lock_out_code] [char](1) NULL,
	[Warning_code] [char](1) NULL,
	[Stop_code] [char](3) NULL,
	[Bankrupt_code] [char](1) NULL,
	[Second_mortgage_code] [char](1) NULL,
	[Other_loan_number] [char](10) NULL,
	[Purpose_code] [char](2) NULL,
	[Loan_type] [char](1) NULL,
	[Loan_sub_type] [char](1) NULL,
	[Property_type_code] [char](3) NULL,
	[Occupied_code] [char](1) NULL,
	[Original_balance] [decimal](19, 8) NOT NULL,
	[Remaining_balance] [decimal](19, 8) NOT NULL,
	[Escrow_flag] [char](1) NULL,
	[Investor_code] [char](5) NULL,
	[Prop_line1] [char](40) NULL,
	[Prop_line2] [char](40) NULL,
	[Prop_city] [char](28) NULL,
	[Prop_state] [char](2) NULL,
	[Prop_zip] [char](9) NULL,
	[Prop_county] [char](3) NULL,
	[Prop_year] [char](4) NULL,
	[Flood_required_code] [char](1) NULL,
	[Filler1] [char](3) NULL,
	[Flood_map_panel] [char](11) NULL,
	[Flood_map_panel_date] [date] NULL,
	[Flood_Community_number] [char](7) NULL,
	[Flood_determination_date] [date] NULL,
	[Flood_program_code] [char](1) NULL,
	[Closed_code] [char](1) NULL,
	[Sale_price] [decimal](19, 8) NOT NULL,
	[Org_code1] [char](5) NULL,
	[Org_code2] [char](5) NULL,
	[Org_code3] [char](5) NULL,
	[Org_code4] [char](5) NULL,
	[Borrower_tax_id] [char](9) NULL,
	[Flood_zone] [char](7) NULL,
	[Flood_comm] [char](6) NULL,
	[Outsourcer_code] [char](2) NULL,
	[Entity_number] [char](3) NULL,
	[Filler2] [char](63) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanServ_File_B]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanServ_File_B](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[Transaction_type] [char](1) NULL,
	[Institution_number] [char](3) NULL,
	[Loan_number] [char](10) NULL,
	[Insurance_line_type] [char](2) NULL,
	[Multiple_policy_ind] [char](1) NULL,
	[Escrow_flag] [char](1) NULL,
	[Company_payee_code] [char](4) NULL,
	[Agency_payee_code] [char](5) NULL,
	[Next_remittance_date] [date] NULL,
	[Policy_effective_date] [date] NULL,
	[Policy_expiration_date] [date] NULL,
	[Premium_amount_due] [decimal](19, 8) NOT NULL,
	[Policy_term] [int] NOT NULL,
	[Coverage_amount] [decimal](19, 8) NOT NULL,
	[Policy_number] [varchar](30) NULL,
	[Escrow_line_payee_flag] [char](1) NULL,
	[Coverage_code] [char](1) NULL,
	[Org_code1] [char](5) NULL,
	[Org_code2] [char](5) NULL,
	[Org_code3] [char](5) NULL,
	[Org_code4] [char](5) NULL,
	[Entity_number] [char](3) NULL,
	[Sufficient_Hazard] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanServ_File_C]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanServ_File_C](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[Transaction_type] [int] NOT NULL,
	[Institution_number] [char](3) NULL,
	[Insurance_line_type] [char](2) NULL,
	[Multiple_policy_ind] [char](1) NULL,
	[Loan_number] [char](12) NULL,
	[Transaction_seq_no] [int] NOT NULL,
	[Escrow_flag] [char](1) NULL,
	[Company_payee_code] [char](4) NULL,
	[Agency_payee_code] [char](5) NULL,
	[Next_remittance_date] [date] NULL,
	[Policy_expiration_date] [date] NULL,
	[Premium_amount_due] [decimal](19, 8) NOT NULL,
	[Policy_term] [int] NOT NULL,
	[Coverage_amount] [decimal](19, 8) NOT NULL,
	[Policy_number] [char](30) NULL,
	[Escrow_line_payee_flag] [char](1) NULL,
	[Coverage_code] [char](1) NULL,
	[Refund_amount] [decimal](19, 8) NOT NULL,
	[Corporate_advance_fee_type] [char](3) NULL,
	[Override] [int] NOT NULL,
	[Disburse_override] [char](1) NULL,
	[Force_place_flag] [char](1) NULL,
	[SufficientHazard_flag] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[midamerica]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[midamerica](
	[LoanNumber] [varchar](50) NULL,
	[DisbType] [varchar](50) NULL,
	[CovType] [varchar](50) NULL,
	[Escrow] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MSPFILESOURCE]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSPFILESOURCE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FILE_NAME_TX] [char](100) NULL,
	[HEADER_TX] [char](1200) NULL,
	[HEADER_EXTRA_TX] [char](1200) NULL,
	[FOOTER_TX] [char](1200) NULL,
	[Interchange_dt] [date] NULL,
	[STAGING_AREA_TX] [char](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MSPIP1477]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSPIP1477](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [bigint] NOT NULL,
	[RECORDTYPE] [char](1) NULL,
	[LOAN_NO_P13] [char](13) NULL,
	[ADV_TYPE] [char](1) NULL,
	[PRIMARY_LOAN_NO_13] [char](13) NULL,
	[NU_BILL_NAME] [char](30) NULL,
	[NU_BILL_LINE2] [char](30) NULL,
	[NU_BILL_LINE3] [char](30) NULL,
	[NU_BILL_LINE4] [char](30) NULL,
	[NU_BILL_LINE5] [char](30) NULL,
	[NU_BILL_CITY] [char](21) NULL,
	[NU_BILL_STATE] [char](2) NULL,
	[NU_ZIP_CODE] [char](5) NULL,
	[NU_ZIP_SUFFIX] [char](4) NULL,
	[NU_CARRIER_ROUTE] [char](4) NULL,
	[BILL_ADDR_FOREIGN] [char](1) NULL,
	[NU_STREET_NO] [char](6) NULL,
	[NU_STREET_DIR] [char](2) NULL,
	[NU_STREET_NAME] [char](20) NULL,
	[NU_CITY_NAME] [char](21) NULL,
	[NU_STATE_ABBR] [char](2) NULL,
	[NU_PROP_ZIP] [char](5) NULL,
	[NU_PROP_SUFFIX] [char](4) NULL,
	[NU_PROP_UNIT_NO] [char](12) NULL,
	[TELEPHONE_NO] [char](10) NULL,
	[MTGR_SS_NO] [decimal](19, 8) NOT NULL,
	[SEC_TELE_NO] [char](10) NULL,
	[CO_MTGR_SS_NO] [decimal](19, 8) NOT NULL,
	[STATE] [char](2) NULL,
	[COUNTY] [char](3) NULL,
	[LOAN_DATE] [char](7) NULL,
	[ORIG_MTG_AMT] [decimal](19, 8) NOT NULL,
	[NEW_LOAN_SETUP_DATE] [char](7) NULL,
	[LOAN_MATURES] [char](5) NULL,
	[LOAN_TERM] [char](3) NULL,
	[TYPE_ACQ] [char](1) NULL,
	[ACQ_DATE] [char](7) NULL,
	[BRH_OFFICE_CODE] [char](4) NULL,
	[HI_TYPE] [char](1) NULL,
	[LO_TYPE] [char](1) NULL,
	[PROP_TYPE] [char](3) NULL,
	[PROPERTY_TYPE] [char](1) NULL,
	[OCCUPY_CODE] [char](1) NULL,
	[CUR_OCC_STATUS] [char](1) NULL,
	[ORGANIZATION_CD] [char](4) NULL,
	[SALE_ID] [char](10) NULL,
	[OLD_LOAN_NO] [char](15) NULL,
	[FIRST_DUE_DATE] [char](5) NULL,
	[DONT_PROCESS] [char](1) NULL,
	[PIF_STOP] [char](1) NULL,
	[FORECLOSURE_STOP] [char](1) NULL,
	[DISB_STOP] [char](1) NULL,
	[NO_NOTICES] [char](1) NULL,
	[ASSUMP_DATE] [char](7) NULL,
	[LOAN_SERV_SOLD_DATE] [char](7) NULL,
	[LOAN_SERV_SOLD_ID] [char](10) NULL,
	[NEW_SERV_LOAN_NO] [char](18) NULL,
	[LOT] [char](6) NULL,
	[BLOCK_X] [char](6) NULL,
	[SECTION_X] [char](12) NULL,
	[SUB_DIVISION] [char](30) NULL,
	[EXTENDED_LEGAL_DESC_IND] [char](1) NULL,
	[MAN] [char](1) NULL,
	[BANK] [char](3) NULL,
	[AGGR] [char](3) NULL,
	[FIRST_PRIN_BAL] [decimal](19, 2) NOT NULL,
	[ESCROW_MTH] [decimal](19, 2) NOT NULL,
	[ESCROW_BAL] [decimal](19, 2) NOT NULL,
	[ESC_ADV_BAL] [decimal](19, 2) NOT NULL,
	[FORE_WKST_CODE] [char](1) NULL,
	[FORECLOSURE_DATE] [char](7) NULL,
	[BANKRUPT_CODE] [char](2) NULL,
	[BANKRUPT_DATE] [char](7) NULL,
	[BANKRUPT_STATUS] [char](1) NULL,
	[BANKRUPT_START_DATE] [char](7) NULL,
	[BANKRUPT_COMPLETE_DATE] [char](7) NULL,
	[PIF_DATE] [char](7) NULL,
	[PAY_OFF_EFF_DATE] [char](7) NULL,
	[REO_STATUS] [char](1) NULL,
	[REO_START_DATE] [char](7) NULL,
	[REO_COMP_DATE] [char](7) NULL,
	[HAZ_PREM] [decimal](19, 2) NOT NULL,
	[LINE1_TYPE_CODE] [char](3) NULL,
	[LINE1_AGENT_CODE] [char](5) NULL,
	[LINE1_INS_CO_CODE] [char](5) NULL,
	[LINE1_PREM_DUE] [char](5) NULL,
	[LINE1_EXP_DATE] [date] NULL,
	[LINE1_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE1_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE1_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE1_TYPE_PAY] [char](1) NULL,
	[LINE1_TYPE_COVERAGE] [char](1) NULL,
	[LINE1_POLICY_NO] [char](20) NULL,
	[LINE2_TYPE_CODE] [char](3) NULL,
	[LINE2_AGENT_CODE] [char](5) NULL,
	[LINE2_INS_CO_CODE] [char](5) NULL,
	[LINE2_PREM_DUE] [char](5) NULL,
	[LINE2_EXP_DATE] [date] NULL,
	[LINE2_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE2_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE2_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE2_TYPE_PAY] [char](1) NULL,
	[LINE2_TYPE_COVERAGE] [char](1) NULL,
	[LINE2_POLICY_NO] [char](20) NULL,
	[LINE3_TYPE_CODE] [char](3) NULL,
	[LINE3_AGENT_CODE] [char](5) NULL,
	[LINE3_INS_CO_CODE] [char](5) NULL,
	[LINE3_PREM_DUE] [char](5) NULL,
	[LINE3_EXP_DATE] [date] NULL,
	[LINE3_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE3_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE3_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE3_TYPE_PAY] [char](1) NULL,
	[LINE3_TYPE_COVERAGE] [char](1) NULL,
	[LINE3_POLICY_NO] [char](20) NULL,
	[LINE4_TYPE_CODE] [char](3) NULL,
	[LINE4_AGENT_CODE] [char](5) NULL,
	[LINE4_INS_CO_CODE] [char](5) NULL,
	[LINE4_PREM_DUE] [char](5) NULL,
	[LINE4_EXP_DATE] [date] NULL,
	[LINE4_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE4_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE4_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE4_TYPE_PAY] [char](1) NULL,
	[LINE4_TYPE_COVERAGE] [char](1) NULL,
	[LINE4_POLICY_NO] [char](20) NULL,
	[LINE5_TYPE_CODE] [char](3) NULL,
	[LINE5_AGENT_CODE] [char](5) NULL,
	[LINE5_INS_CO_CODE] [char](5) NULL,
	[LINE5_PREM_DUE] [char](5) NULL,
	[LINE5_EXP_DATE] [date] NULL,
	[LINE5_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE5_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE5_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE5_TYPE_PAY] [char](1) NULL,
	[LINE5_TYPE_COVERAGE] [char](1) NULL,
	[LINE5_POLICY_NO] [char](20) NULL,
	[FLOOD_PROCESSED_DATE] [char](7) NULL,
	[FLOOD_COMMUNITY_DATE] [char](7) NULL,
	[FLOOD_PROGRAM] [char](1) NULL,
	[FLOOD_LOMA_R] [char](1) NULL,
	[FLOOD_DETERMINE_DATE] [char](7) NULL,
	[FLOOD_CONTRACT_TYPE] [char](1) NULL,
	[FLOOD_COMMUNITY_NO] [char](6) NULL,
	[FLOOD_PANEL_NO] [char](4) NULL,
	[FLOOD_SUFFIX_NO] [char](1) NULL,
	[FLOOD_ZONE] [char](3) NULL,
	[FLOOD_ZONE_IND] [char](1) NULL,
	[FLOOD_FIRM_DATE] [char](7) NULL,
	[FLOOD_MAPPER_INIT] [char](3) NULL,
	[FLOOD_CMPCO] [char](5) NULL,
	[FLOOD_MAPCO] [char](5) NULL,
	[FLOOD_FEE] [decimal](19, 2) NOT NULL,
	[FLOOD_CERT_NO] [char](14) NULL,
	[HAZARD_PAID_DATE] [char](7) NULL,
	[FORCED_COV_IND] [char](1) NULL,
	[FORCED_COV_DATE] [char](5) NULL,
	[LOAN_PURPOSE] [char](1) NULL,
	[REFINANCE_AMT] [decimal](19, 2) NOT NULL,
	[PROPERTY_VALUE] [decimal](19, 8) NOT NULL,
	[FILLER] [char](130) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MSPIP1477LOAN]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSPIP1477LOAN](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[LENDER_CODE] [char](20) NULL,
	[LOAN_NO] [char](20) NULL,
	[STATUS] [char](10) NULL,
	[CREATE_DATE] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MSPIP1477RELATE]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSPIP1477RELATE](
	[LOAN_ID] [bigint] NOT NULL,
	[RECORD_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NAC]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAC](
	[AccountName] [varchar](50) NULL,
	[CoverageType] [varchar](50) NULL,
	[YTDNAC] [decimal](28, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OneMainCPIIssueRefund]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OneMainCPIIssueRefund](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[PURGE_DT] [datetime] NULL,
	[RecordID] [char](1) NULL,
	[Branch] [char](8) NULL,
	[ContractNumber] [char](18) NULL,
	[AssetNumber] [char](3) NULL,
	[LastName] [char](30) NULL,
	[FirstName] [char](30) NULL,
	[MiddleInitial] [char](1) NULL,
	[Address1] [char](40) NULL,
	[Address2] [char](40) NULL,
	[City] [char](15) NULL,
	[State] [char](2) NULL,
	[Zip] [char](9) NULL,
	[VehicleYear] [char](4) NULL,
	[VehicleMake] [char](30) NULL,
	[VehicleModel] [char](30) NULL,
	[VIN] [char](18) NULL,
	[PolicyNumber] [char](10) NULL,
	[PolicyEffectiveDate] [date] NULL,
	[PolicyCancellationDate] [date] NULL,
	[PolicyExpirationDate] [date] NULL,
	[PolicyTerm] [char](3) NULL,
	[PolicyIssuePremium] [decimal](19, 8) NOT NULL,
	[PolicyRefundPremium] [decimal](19, 8) NOT NULL,
	[PolicyCancelReason] [char](30) NULL,
	[PolicyBasis] [decimal](19, 8) NOT NULL,
	[PolicyXYCODE] [char](18) NULL,
	[CategoryCode] [char](1) NULL,
	[PolicyTransactionDate] [date] NULL,
	[PolicyOriginalLoanTerm] [char](4) NULL,
	[PolciyLoanBalance] [decimal](19, 8) NOT NULL,
	[PolicyIssueFee] [decimal](19, 8) NOT NULL,
	[PolicyIssueTax1] [decimal](19, 8) NOT NULL,
	[PolicyIssueTax2] [decimal](19, 8) NOT NULL,
	[PolicyIssueOther] [decimal](19, 8) NOT NULL,
	[PolicyCancelFee] [decimal](19, 8) NOT NULL,
	[PolicyCancelTax1] [decimal](19, 8) NOT NULL,
	[PolicyCancelTax2] [decimal](19, 8) NOT NULL,
	[PolicyCancelOther] [decimal](19, 8) NOT NULL,
	[MaxCPIAct_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OneMainMonthly]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OneMainMonthly](
	[BRANCH] [char](8) NULL,
	[ACCOUNT] [char](8) NULL,
	[NAME_LAST] [char](15) NULL,
	[NAME_FIRST] [char](14) NULL,
	[NAME_MI] [char](1) NULL,
	[ADDRESS_LINE1] [char](40) NULL,
	[ADDRESS_CITY] [char](28) NULL,
	[ADDRESS_STATE] [char](2) NULL,
	[ADDRESS_ZIP] [char](10) NULL,
	[LOAN_EFF_DATE] [char](8) NULL,
	[LOAN_FINAL_DATE] [char](8) NULL,
	[SECURITY_CODE] [char](1) NULL,
	[LOAN_TYPE] [char](2) NULL,
	[DELINQUENT] [char](1) NULL,
	[LOAN_BALANCE] [char](13) NULL,
	[SOLICIT_CODE] [char](2) NULL,
	[FILE_FREQUENCY] [char](1) NULL,
	[MONTHS_PAST] [char](1) NULL,
	[SCORE] [char](4) NULL,
	[CONFIDENTIAL] [char](1) NULL,
	[APR] [char](5) NULL,
	[TRACKING_NUM] [char](5) NULL,
	[PURCHASE] [char](1) NULL,
	[DUE_YEAR] [char](4) NULL,
	[DUE_MONTH] [char](2) NULL,
	[SSNO] [char](9) NULL,
	[PROCESS_DATE] [char](8) NULL,
	[CHARGEOFF] [char](1) NULL,
	[VOLUME_SWITCH] [char](1) NULL,
	[BANKRUPTCY] [char](2) NULL,
	[FIRST_PAYMENT_DATE] [char](8) NULL,
	[RETRACTION_IND] [char](1) NULL,
	[REAL_ESTATE_BAL] [char](9) NULL,
	[DATE_OF_PURCHASE] [char](8) NULL,
	[ALT_BRANCH] [char](8) NULL,
	[LOAN_CATG_CD] [char](1) NULL,
	[ALPHA_TYPE] [char](1) NULL,
	[REPOSSESSION_IND] [char](1) NULL,
	[JUDGE_SETTLE_IND] [char](1) NULL,
	[FORECLOSURE_IND] [char](1) NULL,
	[DATE_STAMP] [char](8) NULL,
	[SEQ_NBR] [char](5) NULL,
	[TRACK_FLAG] [char](1) NULL,
	[TRACK_REASON] [char](10) NULL,
	[TRACK_REASON_CODE] [char](3) NULL,
	[FILLER1] [char](1) NULL,
	[PROCESS_BK] [char](1) NULL,
	[PROCESS_FC] [char](1) NULL,
	[MORTGAGE_TYPE] [char](1) NULL,
	[UAID] [char](17) NULL,
	[LOAN_SEC_FLAG] [char](1) NULL,
	[ADDRESS_LINE2] [char](40) NULL,
	[SOURCE_IND] [char](1) NULL,
	[COB_NAME_LAST] [char](15) NULL,
	[COB_NAME_FIRST] [char](14) NULL,
	[COB_NAME_MI] [char](1) NULL,
	[FILLER2] [char](85) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayeeMapQATool]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayeeMapQATool](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Lender_ID] [bigint] NOT NULL,
	[LENDER_PAYEE_CODE_FILE_ID] [bigint] NOT NULL,
	[Payee_Code] [char](20) NULL,
	[BIC_ID] [bigint] NOT NULL,
	[REMITTANCE_ADDR_ID] [bigint] NOT NULL,
	[Match_Type] [char](20) NULL,
	[Update_user_tx] [char](140) NOT NULL,
	[Update_dt] [datetime] NOT NULL,
	[Primary_ind] [char](1) NULL,
	[CPI_Agency_ind] [char](1) NULL,
	[AutoMatched_TX] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_BKEcho]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_BKEcho](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[I_FILE_ID] [bigint] NOT NULL,
	[Lender_ID] [bigint] NOT NULL,
	[RecordType] [char](1) NULL,
	[BatchID] [char](3) NULL,
	[App_Unapp_Ind] [char](1) NULL,
	[ReasonCode] [char](4) NULL,
	[TransactionNumber] [char](3) NULL,
	[ClientNumber] [char](3) NULL,
	[ShortLoanNumber] [char](7) NULL,
	[GrossDisbursement] [decimal](19, 8) NOT NULL,
	[Desc_tx] [char](13) NULL,
	[ChekNumber] [char](5) NULL,
	[CheckDateMonth] [char](2) NULL,
	[CheckDateDay] [char](2) NULL,
	[Bank1] [char](1) NULL,
	[Bank23] [char](2) NULL,
	[Filler1] [char](1) NULL,
	[DueDateX] [char](4) NULL,
	[SeqNo] [char](2) NULL,
	[PayeeCode] [char](10) NULL,
	[DisbDiscX] [char](3) NULL,
	[DisbTermX] [char](2) NULL,
	[Override] [char](1) NULL,
	[HazardCode] [char](1) NULL,
	[Pers_real] [char](1) NULL,
	[Filler2] [char](1) NULL,
	[Install_Flag] [char](1) NULL,
	[Filler3] [char](1) NULL,
	[Separate_ck] [char](1) NULL,
	[S203_SUSP_DESC_SW] [char](1) NULL,
	[Filler4] [char](1) NULL,
	[Expanded_Loan_No] [char](13) NULL,
	[TrimLoanNumber] [char](13) NULL,
	[Filler5] [char](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_BKInsurance]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_BKInsurance](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Number_tx] [char](18) NULL,
	[REC_STATUS] [char](18) NULL,
	[I_File_ID] [bigint] NOT NULL,
	[TYPE_CODE] [char](3) NULL,
	[AGENT_CODE] [char](5) NULL,
	[INS_CO_CODE] [char](5) NULL,
	[PREM_DUE_DT] [date] NULL,
	[EXP_DATE] [date] NULL,
	[INSTALL] [decimal](19, 8) NOT NULL,
	[TERM_OF_PREM] [int] NOT NULL,
	[AMT_COVER] [decimal](19, 8) NOT NULL,
	[TYPE_PAY] [char](1) NULL,
	[TYPE_COVERAGE] [char](1) NULL,
	[POLICY_NO] [char](20) NULL,
	[Virtual_EFF_DATE] [date] NULL,
	[Virtual_CANCEL_EFF_DATE] [date] NULL,
	[CombinedLineType] [char](5) NULL,
	[UniTracCoverage] [char](20) NULL,
	[Escrow] [char](3) NULL,
	[PayCompany] [char](3) NULL,
	[Condo] [char](3) NULL,
	[Association] [char](3) NULL,
	[UnitOwners] [char](3) NULL,
	[Excess] [char](3) NULL,
	[Property_no] [char](1) NULL,
	[TrimLoanNumber] [char](20) NULL,
	[DateOfLastChange] [date] NULL,
	[Lender_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_BKLoan]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_BKLoan](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[I_FILE_ID] [bigint] NOT NULL,
	[REC_STATUS] [char](20) NULL,
	[RECORDTYPE] [char](1) NULL,
	[LOAN_NO_P13] [char](13) NULL,
	[ADV_TYPE] [char](1) NULL,
	[PRIMARY_LOAN_NO_13] [char](13) NULL,
	[NU_BILL_NAME] [char](30) NULL,
	[NU_BILL_LINE2] [char](30) NULL,
	[NU_BILL_LINE3] [char](30) NULL,
	[NU_BILL_LINE4] [char](30) NULL,
	[NU_BILL_LINE5] [char](30) NULL,
	[NU_BILL_CITY] [char](21) NULL,
	[NU_BILL_STATE] [char](2) NULL,
	[NU_ZIP_CODE] [char](5) NULL,
	[NU_ZIP_SUFFIX] [char](4) NULL,
	[NU_CARRIER_ROUTE] [char](4) NULL,
	[BILL_ADDR_FOREIGN] [char](1) NULL,
	[NU_STREET_NO] [char](6) NULL,
	[NU_STREET_DIR] [char](2) NULL,
	[NU_STREET_NAME] [char](20) NULL,
	[NU_CITY_NAME] [char](21) NULL,
	[NU_STATE_ABBR] [char](2) NULL,
	[NU_PROP_ZIP] [char](5) NULL,
	[NU_PROP_SUFFIX] [char](4) NULL,
	[NU_PROP_UNIT_NO] [char](12) NULL,
	[TELEPHONE_NO] [char](10) NULL,
	[MTGR_SS_NO] [decimal](19, 8) NOT NULL,
	[SEC_TELE_NO] [char](10) NULL,
	[CO_MTGR_SS_NO] [decimal](19, 8) NOT NULL,
	[STATE] [char](2) NULL,
	[COUNTY] [char](3) NULL,
	[LOAN_DATE] [char](7) NULL,
	[ORIG_MTG_AMT] [decimal](19, 8) NOT NULL,
	[NEW_LOAN_SETUP_DATE] [char](7) NULL,
	[LOAN_MATURES] [char](5) NULL,
	[LOAN_TERM] [char](3) NULL,
	[TYPE_ACQ] [char](1) NULL,
	[ACQ_DATE] [char](7) NULL,
	[BRH_OFFICE_CODE] [char](4) NULL,
	[HI_TYPE] [char](1) NULL,
	[LO_TYPE] [char](1) NULL,
	[PROP_TYPE] [char](3) NULL,
	[PROPERTY_TYPE] [char](1) NULL,
	[OCCUPY_CODE] [char](1) NULL,
	[CUR_OCC_STATUS] [char](1) NULL,
	[ORGANIZATION_CD] [char](4) NULL,
	[SALE_ID] [char](10) NULL,
	[OLD_LOAN_NO] [char](15) NULL,
	[FIRST_DUE_DATE] [char](5) NULL,
	[DONT_PROCESS] [char](1) NULL,
	[PIF_STOP] [char](1) NULL,
	[FORECLOSURE_STOP] [char](1) NULL,
	[DISB_STOP] [char](1) NULL,
	[NO_NOTICES] [char](1) NULL,
	[ASSUMP_DATE] [char](7) NULL,
	[LOAN_SERV_SOLD_DATE] [char](7) NULL,
	[LOAN_SERV_SOLD_ID] [char](10) NULL,
	[NEW_SERV_LOAN_NO] [char](18) NULL,
	[LOT] [char](6) NULL,
	[BLOCK_X] [char](6) NULL,
	[SECTION_X] [char](12) NULL,
	[SUB_DIVISION] [char](30) NULL,
	[EXTENDED_LEGAL_DESC_IND] [char](1) NULL,
	[MAN] [char](1) NULL,
	[BANK] [char](3) NULL,
	[AGGR] [char](3) NULL,
	[FIRST_PRIN_BAL] [decimal](19, 2) NOT NULL,
	[ESCROW_MTH] [decimal](19, 2) NOT NULL,
	[ESCROW_BAL] [decimal](19, 2) NOT NULL,
	[ESC_ADV_BAL] [decimal](19, 2) NOT NULL,
	[FORE_WKST_CODE] [char](1) NULL,
	[FORECLOSURE_DATE] [char](7) NULL,
	[BANKRUPT_CODE] [char](2) NULL,
	[BANKRUPT_DATE] [char](7) NULL,
	[BANKRUPT_STATUS] [char](1) NULL,
	[BANKRUPT_START_DATE] [char](7) NULL,
	[BANKRUPT_COMPLETE_DATE] [char](7) NULL,
	[PIF_DATE] [char](7) NULL,
	[PAY_OFF_EFF_DATE] [char](7) NULL,
	[REO_STATUS] [char](1) NULL,
	[REO_START_DATE] [char](7) NULL,
	[REO_COMP_DATE] [char](7) NULL,
	[HAZ_PREM] [decimal](19, 2) NOT NULL,
	[LINE1_TYPE_CODE] [char](3) NULL,
	[LINE1_AGENT_CODE] [char](5) NULL,
	[LINE1_INS_CO_CODE] [char](5) NULL,
	[LINE1_PREM_DUE] [date] NULL,
	[LINE1_EXP_DATE] [date] NULL,
	[LINE1_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE1_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE1_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE1_TYPE_PAY] [char](1) NULL,
	[LINE1_TYPE_COVERAGE] [char](1) NULL,
	[LINE1_POLICY_NO] [char](20) NULL,
	[LINE2_TYPE_CODE] [char](3) NULL,
	[LINE2_AGENT_CODE] [char](5) NULL,
	[LINE2_INS_CO_CODE] [char](5) NULL,
	[LINE2_PREM_DUE] [date] NULL,
	[LINE2_EXP_DATE] [date] NULL,
	[LINE2_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE2_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE2_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE2_TYPE_PAY] [char](1) NULL,
	[LINE2_TYPE_COVERAGE] [char](1) NULL,
	[LINE2_POLICY_NO] [char](20) NULL,
	[LINE3_TYPE_CODE] [char](3) NULL,
	[LINE3_AGENT_CODE] [char](5) NULL,
	[LINE3_INS_CO_CODE] [char](5) NULL,
	[LINE3_PREM_DUE] [date] NULL,
	[LINE3_EXP_DATE] [date] NULL,
	[LINE3_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE3_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE3_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE3_TYPE_PAY] [char](1) NULL,
	[LINE3_TYPE_COVERAGE] [char](1) NULL,
	[LINE3_POLICY_NO] [char](20) NULL,
	[LINE4_TYPE_CODE] [char](3) NULL,
	[LINE4_AGENT_CODE] [char](5) NULL,
	[LINE4_INS_CO_CODE] [char](5) NULL,
	[LINE4_PREM_DUE] [date] NULL,
	[LINE4_EXP_DATE] [date] NULL,
	[LINE4_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE4_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE4_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE4_TYPE_PAY] [char](1) NULL,
	[LINE4_TYPE_COVERAGE] [char](1) NULL,
	[LINE4_POLICY_NO] [char](20) NULL,
	[LINE5_TYPE_CODE] [char](3) NULL,
	[LINE5_AGENT_CODE] [char](5) NULL,
	[LINE5_INS_CO_CODE] [char](5) NULL,
	[LINE5_PREM_DUE] [date] NULL,
	[LINE5_EXP_DATE] [date] NULL,
	[LINE5_INSTALL] [decimal](19, 2) NOT NULL,
	[LINE5_TERM_OF_PREM] [decimal](19, 8) NOT NULL,
	[LINE5_AMT_COVER] [decimal](19, 8) NOT NULL,
	[LINE5_TYPE_PAY] [char](1) NULL,
	[LINE5_TYPE_COVERAGE] [char](1) NULL,
	[LINE5_POLICY_NO] [char](20) NULL,
	[FLOOD_PROCESSED_DATE] [char](7) NULL,
	[FLOOD_COMMUNITY_DATE] [char](7) NULL,
	[FLOOD_PROGRAM] [char](1) NULL,
	[FLOOD_LOMA_R] [char](1) NULL,
	[FLOOD_DETERMINE_DATE] [char](7) NULL,
	[FLOOD_CONTRACT_TYPE] [char](1) NULL,
	[FLOOD_COMMUNITY_NO] [char](6) NULL,
	[FLOOD_PANEL_NO] [char](4) NULL,
	[FLOOD_SUFFIX_NO] [char](1) NULL,
	[FLOOD_ZONE] [char](3) NULL,
	[FLOOD_ZONE_IND] [char](1) NULL,
	[FLOOD_FIRM_DATE] [char](7) NULL,
	[FLOOD_MAPPER_INIT] [char](3) NULL,
	[FLOOD_CMPCO] [char](5) NULL,
	[FLOOD_MAPCO] [char](5) NULL,
	[FLOOD_FEE] [decimal](19, 2) NOT NULL,
	[FLOOD_CERT_NO] [char](14) NULL,
	[HAZARD_PAID_DATE] [char](7) NULL,
	[FORCED_COV_IND] [char](1) NULL,
	[FORCED_COV_DATE] [char](5) NULL,
	[LOAN_PURPOSE] [char](1) NULL,
	[REFINANCE_AMT] [decimal](19, 2) NOT NULL,
	[PROPERTY_VALUE] [decimal](19, 8) NOT NULL,
	[FILLER] [char](130) NULL,
	[Lender_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_MSPDISBURSEMENTTRAN]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_MSPDISBURSEMENTTRAN](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[I_FILE_ID] [bigint] NOT NULL,
	[TRANSACTION1] [char](3) NULL,
	[CLIENT_NO] [char](3) NULL,
	[LOAN_NO] [char](7) NULL,
	[GROSS_DISBURSEMENT] [decimal](19, 2) NOT NULL,
	[DESCRIPTION] [char](13) NULL,
	[CHECK_NO] [char](5) NULL,
	[CHECK_DATE] [char](4) NULL,
	[BANK] [char](3) NULL,
	[DUE_DATE] [char](4) NULL,
	[ESCROW_PAYEE_SEQ_NO] [char](2) NULL,
	[ESCROW_PAYEE_CODE] [char](10) NULL,
	[DISBURSEMENT_DISCOUNT] [char](3) NULL,
	[DISBURSEMENT_TERM] [char](2) NULL,
	[OVERRIDE] [char](1) NULL,
	[HAZARD_CODE] [char](1) NULL,
	[PERSONAL_RE_TAX_CODE] [char](1) NULL,
	[RESERVED1] [char](1) NULL,
	[INSTALL_FLAG] [char](1) NULL,
	[RESERVED2] [char](1) NULL,
	[SEPARATE_CHECK] [char](1) NULL,
	[SUSPENSE_DESCRIPTION] [char](1) NULL,
	[RESERVED3] [char](1) NULL,
	[PMI_CANCEL_SW] [char](1) NULL,
	[CODE_523] [char](1) NULL,
	[RESERVED4] [char](1) NULL,
	[RESERVED5] [char](9) NULL,
	[EXPANDED_LOAN_NO] [char](13) NULL,
	[RawLineofText] [char](150) NULL,
	[Lender_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_MSPFILESOURCE]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_MSPFILESOURCE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FILE_NAME_TX] [char](100) NULL,
	[HEADER_TX] [char](1200) NULL,
	[HEADER_EXTRA_TX] [char](1200) NULL,
	[FOOTER_TX] [char](1200) NULL,
	[Interchange_dt] [date] NULL,
	[STAGING_AREA_TX] [char](25) NULL,
	[Create_user_tx] [varchar](140) NOT NULL,
	[Create_dt] [datetime] NOT NULL,
	[Lender_code_tx] [char](20) NULL,
	[Lender_name_tx] [char](100) NULL,
	[LENDER_ID] [bigint] NULL,
	[FileType_tx] [char](25) NULL,
	[Sub_FileType_tx] [char](25) NULL,
	[WI_ID] [bigint] NULL,
	[purge_dt] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_MSPLETTERLOG]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_MSPLETTERLOG](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[I_FILE_ID] [bigint] NOT NULL,
	[TRANSACTION1] [char](3) NULL,
	[CLIENT_NO] [char](3) NULL,
	[LOAN_NO] [char](7) NULL,
	[ACTION_CODE] [char](1) NULL,
	[REQUEST_ID] [char](3) NULL,
	[LETTER_ID] [char](5) NULL,
	[LETTER_VERSION] [decimal](19, 8) NOT NULL,
	[DATE_SENT] [char](6) NULL,
	[LETTER_DESC] [char](20) NULL,
	[RESERVED] [char](29) NULL,
	[EXPANDED_LOAN_NO] [char](12) NULL,
	[RawLineofText] [char](150) NULL,
	[Lender_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_MSPMAINTENANCETRAN]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_MSPMAINTENANCETRAN](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[I_FILE_ID] [bigint] NOT NULL,
	[TRANSACTION1] [char](3) NULL,
	[CLIENT_NO] [char](3) NULL,
	[LOAN_NO] [char](7) NULL,
	[INSURANCE_TYPE_CODE] [char](3) NULL,
	[AGENT_CODE] [char](5) NULL,
	[INSURANCE_COMPANY_CODE] [char](5) NULL,
	[PREMIUM_DUE_DATE] [char](4) NULL,
	[EXPIRATION_DATE] [char](6) NULL,
	[INSTALLMENT] [decimal](19, 8) NOT NULL,
	[TERM_OF_PREMIUM] [char](2) NULL,
	[COVERAGE_IN_DOLLARS] [decimal](19, 8) NOT NULL,
	[TYPE_PAYMENT] [char](1) NULL,
	[TYPE_COVERAGE] [char](1) NULL,
	[POLICY_NO] [char](20) NULL,
	[DISB_CODE] [char](1) NULL,
	[MORTGAGE_CLAUSE] [char](1) NULL,
	[RESERVED1] [char](2) NULL,
	[RESERVED2] [char](9) NULL,
	[EXPANDED_LOAN_NO] [char](13) NULL,
	[RawLineofData] [char](150) NULL,
	[TrimLoanNumber] [char](13) NULL,
	[Lender_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prod_MSPTRANSFORMSIXTYTHREE]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prod_MSPTRANSFORMSIXTYTHREE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[I_FILE_ID] [bigint] NOT NULL,
	[TRANSACTION1] [char](3) NULL,
	[CLIENT_NO] [char](3) NULL,
	[LOAN_NO] [char](7) NULL,
	[ESCROW_PAID] [decimal](19, 2) NOT NULL,
	[RESERVED1] [char](12) NULL,
	[SUSPENSE_RECEIVED] [decimal](19, 2) NOT NULL,
	[TOTAL_PAYMENT] [decimal](19, 2) NOT NULL,
	[RESERVED2] [char](6) NULL,
	[MEMO_CODE] [char](1) NULL,
	[FROM_PAYEE] [char](10) NULL,
	[DESCRIPTION] [char](17) NULL,
	[EXPANDED_LOAN_NO] [char](13) NULL,
	[RawLineofText] [char](150) NULL,
	[Lender_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sd_example]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sd_example](
	[LOANNUMBER] [varchar](50) NULL,
	[COVERAGETYPE] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SD_Integration]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SD_Integration](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FILE_NAME_TX] [char](100) NULL,
	[Lender_code_tx] [char](20) NULL,
	[Lender_name_tx] [char](100) NULL,
	[LENDER_ID] [bigint] NOT NULL,
	[Interchange_dt] [date] NULL,
	[FileType_tx] [char](25) NULL,
	[WI_ID] [bigint] NOT NULL,
	[Create_user_tx] [char](140) NOT NULL,
	[Create_dt] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SDBackfeedTable]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SDBackfeedTable](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[I_File_ID] [bigint] NOT NULL,
	[LOANNUMBER] [char](35) NULL,
	[COVERAGETYPE] [char](1) NULL,
	[COVERAGEAMOUNT] [char](11) NULL,
	[AGENTPAYEE] [char](5) NULL,
	[COMPANYPAYEE] [char](5) NULL,
	[POLICYNUMBER] [char](18) NULL,
	[CANCELDATE] [char](7) NULL,
	[EXPIREDATE] [char](7) NULL,
	[EFFECTIVEDATE] [char](7) NULL,
	[ESCROWTYPE] [char](1) NULL,
	[PREMIUMDUEAMOUNT] [char](8) NULL,
	[PAYMENTDUEDATE] [char](7) NULL,
	[BORROWERNAME] [char](30) NULL,
	[PROPERTYADDRESS1] [char](30) NULL,
	[PROPERTYADDRESS2] [char](30) NULL,
	[PROPERTYCITY] [char](25) NULL,
	[PROPERTYSTATE] [char](2) NULL,
	[PROPERTYZIP] [char](5) NULL,
	[COMPANYNAME] [char](30) NULL,
	[COMPANYADDRESS1] [char](30) NULL,
	[COMPANYADDRESS2] [char](30) NULL,
	[COMPANYCITY] [char](25) NULL,
	[COMPANYSTATE] [char](2) NULL,
	[COMPANYZIP] [char](5) NULL,
	[COMPANYZIP4] [char](4) NULL,
	[INSURANCECOMPANYNAME] [char](8) NULL,
	[AddlInsFlag] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaxPayee_XRef]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxPayee_XRef](
	[TaxServiceCode] [varchar](50) NULL,
	[TaxServicePayee] [varchar](50) NULL,
	[Payee] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Test_Integration_File]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test_Integration_File](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Int_Code_TX] [char](30) NULL,
	[FILE_NAME_TX] [char](100) NULL,
	[Lender_code_tx] [char](20) NULL,
	[Lender_name_tx] [char](100) NULL,
	[LENDER_ID] [bigint] NOT NULL,
	[Interchange_dt] [date] NULL,
	[FileType_tx] [char](25) NULL,
	[Sub_FileType_tx] [char](25) NULL,
	[WI_ID] [bigint] NOT NULL,
	[Create_user_tx] [char](140) NOT NULL,
	[Create_dt] [datetime] NOT NULL,
	[Live_IN_tx] [char](1) NULL,
	[Purge_dt] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Test_OneMainCPIIssueRefund]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test_OneMainCPIIssueRefund](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IFILE_ID] [bigint] NOT NULL,
	[PURGE_DT] [datetime] NULL,
	[RecordID] [char](1) NULL,
	[Branch] [char](8) NULL,
	[ContractNumber] [char](18) NULL,
	[AssetNumber] [char](3) NULL,
	[LastName] [char](30) NULL,
	[FirstName] [char](30) NULL,
	[MiddleInitial] [char](1) NULL,
	[Address1] [char](40) NULL,
	[Address2] [char](40) NULL,
	[City] [char](15) NULL,
	[State] [char](2) NULL,
	[Zip] [char](9) NULL,
	[VehicleYear] [char](4) NULL,
	[VehicleMake] [char](30) NULL,
	[VehicleModel] [char](30) NULL,
	[VIN] [char](18) NULL,
	[PolicyNumber] [char](10) NULL,
	[PolicyEffectiveDate] [date] NULL,
	[PolicyCancellationDate] [date] NULL,
	[PolicyExpirationDate] [date] NULL,
	[PolicyTerm] [char](3) NULL,
	[PolicyIssuePremium] [decimal](19, 8) NOT NULL,
	[PolicyRefundPremium] [decimal](19, 8) NOT NULL,
	[PolicyCancelReason] [char](30) NULL,
	[PolicyBasis] [decimal](19, 8) NOT NULL,
	[PolicyXYCODE] [char](18) NULL,
	[CategoryCode] [char](1) NULL,
	[PolicyTransactionDate] [date] NULL,
	[PolicyOriginalLoanTerm] [char](4) NULL,
	[PolciyLoanBalance] [decimal](19, 8) NOT NULL,
	[PolicyIssueFee] [decimal](19, 8) NOT NULL,
	[PolicyIssueTax1] [decimal](19, 8) NOT NULL,
	[PolicyIssueTax2] [decimal](19, 8) NOT NULL,
	[PolicyIssueOther] [decimal](19, 8) NOT NULL,
	[PolicyCancelFee] [decimal](19, 8) NOT NULL,
	[PolicyCancelTax1] [decimal](19, 8) NOT NULL,
	[PolicyCancelTax2] [decimal](19, 8) NOT NULL,
	[PolicyCancelOther] [decimal](19, 8) NOT NULL,
	[MaxCPIAct_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VOWBICListing]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VOWBICListing](
	[BIC_ID] [bigint] NOT NULL,
	[HighLevel_TX] [char](127) NULL,
	[Description_tx] [char](127) NULL,
	[Create_user_tx] [char](140) NOT NULL,
	[Create_dt] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [VOWBICListing_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE CLUSTERED INDEX [VOWBICListing_I1] ON [dbo].[VOWBICListing]
(
	[BIC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ZipCode]    Script Date: 7/14/2021 8:29:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ZipCode](
	[ZIP] [char](5) NULL,
	[CountyName] [char](25) NULL,
	[CountyFIPS] [char](20) NULL,
	[StateAbbr] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [CVSYM_IFILE_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [CVSYM_IFILE_ID_IDX] ON [dbo].[CVSymitarIns]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CVSYM_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [CVSYM_LN_IDX] ON [dbo].[CVSymitarIns]
(
	[AccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [DNA_II_IFILE_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [DNA_II_IFILE_ID_IDX] ON [dbo].[DNA_INSIMPORT]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [DNA_II_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [DNA_II_LN_IDX] ON [dbo].[DNA_INSIMPORT]
(
	[LoanNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FICS_FS_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [FICS_FS_I1] ON [dbo].[FICS_FS]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSPFILESOURCEfs_fn_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [MSPFILESOURCEfs_fn_IDX] ON [dbo].[FICS_FS]
(
	[FILE_NAME_TX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FICSExtract_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [FICSExtract_I1] ON [dbo].[FICSExtract]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FA_file_dt_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FA_file_dt_IDX] ON [dbo].[File_A]
(
	[File_dt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FA_FNAME_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FA_FNAME_IDX] ON [dbo].[File_A]
(
	[File_name_tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FA_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FA_LN_IDX] ON [dbo].[File_A]
(
	[Loan_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FB_file_dt_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FB_file_dt_IDX] ON [dbo].[File_B]
(
	[File_dt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FB_FNAME_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FB_FNAME_IDX] ON [dbo].[File_B]
(
	[File_name_tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FB_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FB_LN_IDX] ON [dbo].[File_B]
(
	[Loan_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FC_file_dt_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FC_file_dt_IDX] ON [dbo].[File_C]
(
	[File_dt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FC_FNAME_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FC_FNAME_IDX] ON [dbo].[File_C]
(
	[File_name_tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [FC_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [FC_LN_IDX] ON [dbo].[File_C]
(
	[Loan_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [GLSMAS_II_IFILE_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [GLSMAS_II_IFILE_ID_IDX] ON [dbo].[GuardianLSAMSBackfeed]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [GLSMAS_II_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [GLSMAS_II_LN_IDX] ON [dbo].[GuardianLSAMSBackfeed]
(
	[LoanNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Int_FILE_C_N_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [Int_FILE_C_N_IDX] ON [dbo].[Integration_File]
(
	[Int_Code_TX] ASC,
	[FILE_NAME_TX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Integration_File_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Integration_File_I1] ON [dbo].[Integration_File]
(
	[ID] ASC,
	[WI_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LS_FA__LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LS_FA__LN_IDX] ON [dbo].[LoanServ_File_A]
(
	[Loan_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LS_FA_IFILE_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LS_FA_IFILE_ID_IDX] ON [dbo].[LoanServ_File_A]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LS_FB_IFILE_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LS_FB_IFILE_ID_IDX] ON [dbo].[LoanServ_File_B]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LS_FB_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LS_FB_LN_IDX] ON [dbo].[LoanServ_File_B]
(
	[Loan_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LS_FC_IFILE_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LS_FC_IFILE_ID_IDX] ON [dbo].[LoanServ_File_C]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [LS_FC_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LS_FC_LN_IDX] ON [dbo].[LoanServ_File_C]
(
	[Loan_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSPFILESOURCE_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSPFILESOURCE_I1] ON [dbo].[MSPFILESOURCE]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSPIP1477LOAN_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSPIP1477LOAN_I1] ON [dbo].[MSPIP1477LOAN]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [OMCPI_IR_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [OMCPI_IR_ID_IDX] ON [dbo].[OneMainCPIIssueRefund]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [OMCPI_IR_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [OMCPI_IR_LN_IDX] ON [dbo].[OneMainCPIIssueRefund]
(
	[ContractNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [OMCPI_IR_PN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [OMCPI_IR_PN_IDX] ON [dbo].[OneMainCPIIssueRefund]
(
	[PolicyNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [OneMain_M__Account_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [OneMain_M__Account_IDX] ON [dbo].[OneMainMonthly]
(
	[BRANCH] ASC,
	[ACCOUNT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PAYEEMAP_LFPC_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [PAYEEMAP_LFPC_IDX] ON [dbo].[PayeeMapQATool]
(
	[Lender_ID] ASC,
	[LENDER_PAYEE_CODE_FILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PayeeMapQATool_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [PayeeMapQATool_I1] ON [dbo].[PayeeMapQATool]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKEcho_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_BKEcho_I1] ON [dbo].[prod_BKEcho]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKEchoBKEcho_FID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_BKEchoBKEcho_FID_IDX] ON [dbo].[prod_BKEcho]
(
	[I_FILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKEchoBKEcho_LL_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_BKEchoBKEcho_LL_IDX] ON [dbo].[prod_BKEcho]
(
	[Lender_ID] ASC,
	[TrimLoanNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKIL_FID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_BKIL_FID_IDX] ON [dbo].[prod_BKInsurance]
(
	[I_File_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKIL_NRS_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_BKIL_NRS_IDX] ON [dbo].[prod_BKInsurance]
(
	[Lender_id] ASC,
	[Number_tx] ASC,
	[REC_STATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKInsurance_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_BKInsurance_I1] ON [dbo].[prod_BKInsurance]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKILOAN_NRS_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_BKILOAN_NRS_IDX] ON [dbo].[prod_BKLoan]
(
	[Lender_id] ASC,
	[LOAN_NO_P13] ASC,
	[REC_STATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKILOAN_STATS_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_BKILOAN_STATS_IDX] ON [dbo].[prod_BKLoan]
(
	[REC_STATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKLOAN_FID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_BKLOAN_FID_IDX] ON [dbo].[prod_BKLoan]
(
	[I_FILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_BKLoan_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_BKLoan_I1] ON [dbo].[prod_BKLoan]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LN_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LN_ID_IDX] ON [dbo].[prod_MSPDISBURSEMENTTRAN]
(
	[Lender_id] ASC,
	[EXPANDED_LOAN_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_fID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_fID_IDX] ON [dbo].[prod_MSPDISBURSEMENTTRAN]
(
	[I_FILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_MSPDISBURSEMENTTRAN_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_MSPDISBURSEMENTTRAN_I1] ON [dbo].[prod_MSPDISBURSEMENTTRAN]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [BKfs_LID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [BKfs_LID_IDX] ON [dbo].[prod_MSPFILESOURCE]
(
	[LENDER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_MSPFILESOURCE_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_MSPFILESOURCE_I1] ON [dbo].[prod_MSPFILESOURCE]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_MSPFILESOURCEfs_fn_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_MSPFILESOURCEfs_fn_IDX] ON [dbo].[prod_MSPFILESOURCE]
(
	[FILE_NAME_TX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LN_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LN_ID_IDX] ON [dbo].[prod_MSPLETTERLOG]
(
	[Lender_id] ASC,
	[EXPANDED_LOAN_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_fID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_fID_IDX] ON [dbo].[prod_MSPLETTERLOG]
(
	[I_FILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_MSPLETTERLOG_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_MSPLETTERLOG_I1] ON [dbo].[prod_MSPLETTERLOG]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LN_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LN_ID_IDX] ON [dbo].[prod_MSPMAINTENANCETRAN]
(
	[Lender_id] ASC,
	[TrimLoanNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_fID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_fID_IDX] ON [dbo].[prod_MSPMAINTENANCETRAN]
(
	[I_FILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_MSPMAINTENANCETRAN_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_MSPMAINTENANCETRAN_I1] ON [dbo].[prod_MSPMAINTENANCETRAN]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [LN_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [LN_ID_IDX] ON [dbo].[prod_MSPTRANSFORMSIXTYTHREE]
(
	[Lender_id] ASC,
	[EXPANDED_LOAN_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_fID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [prod_fID_IDX] ON [dbo].[prod_MSPTRANSFORMSIXTYTHREE]
(
	[I_FILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [prod_MSPTRANSFORMSIXTYTHREE_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [prod_MSPTRANSFORMSIXTYTHREE_I1] ON [dbo].[prod_MSPTRANSFORMSIXTYTHREE]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [SD_Int_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [SD_Int_IDX] ON [dbo].[SD_Integration]
(
	[FILE_NAME_TX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [SD_Integration_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [SD_Integration_I1] ON [dbo].[SD_Integration]
(
	[ID] ASC,
	[WI_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [SDBackfeedTable_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [SDBackfeedTable_I1] ON [dbo].[SDBackfeedTable]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Test_Int_FILE_C_N_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [Test_Int_FILE_C_N_IDX] ON [dbo].[Test_Integration_File]
(
	[Int_Code_TX] ASC,
	[FILE_NAME_TX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Test_Integration_File_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Test_Integration_File_I1] ON [dbo].[Test_Integration_File]
(
	[ID] ASC,
	[WI_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Test_OMCPI_IR_ID_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [Test_OMCPI_IR_ID_IDX] ON [dbo].[Test_OneMainCPIIssueRefund]
(
	[IFILE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Test_OMCPI_IR_LN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [Test_OMCPI_IR_LN_IDX] ON [dbo].[Test_OneMainCPIIssueRefund]
(
	[ContractNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Test_OMCPI_IR_PN_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [Test_OMCPI_IR_PN_IDX] ON [dbo].[Test_OneMainCPIIssueRefund]
(
	[PolicyNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ZC_ST_CNTY_IDX]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [ZC_ST_CNTY_IDX] ON [dbo].[ZipCode]
(
	[StateAbbr] ASC,
	[CountyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ZipCode_I1]    Script Date: 7/14/2021 8:29:48 PM ******/
CREATE NONCLUSTERED INDEX [ZipCode_I1] ON [dbo].[ZipCode]
(
	[ZIP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FICS_FS] ADD  DEFAULT (user_name()) FOR [Create_user_tx]
GO
ALTER TABLE [dbo].[FICS_FS] ADD  DEFAULT (getdate()) FOR [Create_dt]
GO
ALTER TABLE [dbo].[Integration_File] ADD  DEFAULT (user_name()) FOR [Create_user_tx]
GO
ALTER TABLE [dbo].[Integration_File] ADD  DEFAULT (getdate()) FOR [Create_dt]
GO
ALTER TABLE [dbo].[PayeeMapQATool] ADD  DEFAULT (user_name()) FOR [Update_user_tx]
GO
ALTER TABLE [dbo].[PayeeMapQATool] ADD  DEFAULT (getdate()) FOR [Update_dt]
GO
ALTER TABLE [dbo].[prod_MSPFILESOURCE] ADD  DEFAULT (user_name()) FOR [Create_user_tx]
GO
ALTER TABLE [dbo].[prod_MSPFILESOURCE] ADD  DEFAULT (getdate()) FOR [Create_dt]
GO
ALTER TABLE [dbo].[SD_Integration] ADD  DEFAULT (user_name()) FOR [Create_user_tx]
GO
ALTER TABLE [dbo].[SD_Integration] ADD  DEFAULT (getdate()) FOR [Create_dt]
GO
ALTER TABLE [dbo].[Test_Integration_File] ADD  DEFAULT (user_name()) FOR [Create_user_tx]
GO
ALTER TABLE [dbo].[Test_Integration_File] ADD  DEFAULT (getdate()) FOR [Create_dt]
GO
ALTER TABLE [dbo].[VOWBICListing] ADD  DEFAULT (user_name()) FOR [Create_user_tx]
GO
ALTER TABLE [dbo].[VOWBICListing] ADD  DEFAULT (getdate()) FOR [Create_dt]
GO
USE [master]
GO
ALTER DATABASE [UNITRAC_MORTGAGE] SET  READ_WRITE 
GO
