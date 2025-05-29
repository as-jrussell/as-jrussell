-- =============================================
-- Author:Judy Roberson-- Create date: 1/18/2021
-- Description: Add constraints
-- =============================================
USE [PremAcc3]

/****** Object:  Table [dbo].[InsuranceCompanyPhoneList]    Script Date: 2/2/2021 3:06:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsuranceCompanyPhoneList]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[InsuranceCompanyPhoneList](
		[GUID] [uniqueidentifier] NOT NULL,
		[Insurance_Company_Name] [nvarchar](256) NOT NULL,
		[Region] [nvarchar](256) NULL,
		[Phone_Number] [nvarchar](50) NULL,
		[Fax_Number] [nvarchar](50) NULL,
		[Notes] [nvarchar](max) NULL,
		[Created] [datetime2](7) NOT NULL,
		[Modified] [datetime2](7) NOT NULL,
		[User_ID] [nvarchar](256) NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

/* Create constraints */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_InsuranceCompanyPhoneList_Created]') AND type = 'D')
BEGIN
	alter table InsuranceCompanyPhoneList add constraint DF_InsuranceCompanyPhoneList_Created default getdate() for Created;
END 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_InsuranceCompanyPhoneList_Modified]') AND type = 'D')
BEGIN
	alter table InsuranceCompanyPhoneList add constraint DF_InsuranceCompanyPhoneList_Modified default getdate() for Modified;
END

