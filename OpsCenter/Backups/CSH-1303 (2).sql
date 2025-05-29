USE [CenterPointSecurity]
 GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CP_LenderSecurityProfile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CP_LenderSecurityProfile]
GO

 /****** Object:  Table [dbo].[CP_LenderSecurityProfile]   
  Script Date: 1/29/2021 3:05:41 PM ******/
  SET ANSI_NULLS ON
  GO
  SET QUOTED_IDENTIFIER ON
  GO
  CREATE TABLE [dbo].[CP_LenderSecurityProfile]
  (	[Id] [uniqueidentifier] NOT NULL,	
  [ClientID] [nvarchar](10) NOT NULL,	
  [PassRemembered] [int] NULL,	
  [PassMaxAge] [int] NULL,	
  [PassMinLength] [int] NULL,	
  [UpperReq] [bit] NULL,	
  [LowerReq] [bit] NULL,	
  [NumericReq] [bit] NULL,	
  [SpecialReq] [bit] NULL,	
  [LockoutEnabled] [bit] NULL,	
  [MaxAttempts] [int] NULL,	
  [LockoutDuration] [int] NULL,	
  [IdleSessionExpiration] [int] NULL,	
  [MaxSessionDuration] [int] NULL,	
  [NetworkRestrictions] [bit] NULL,	
  [EnabledIP] [nvarchar](max) NULL,	
  [DisabledIP] [nvarchar](max) NULL,	
  [Created] [datetime] NULL,	
  [Modified] [datetime] NULL, 
  CONSTRAINT [PK_ClientId] PRIMARY KEY CLUSTERED (	[ClientID] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
  
  GO
  
  ALTER TABLE [dbo].[CP_LenderSecurityProfile] ADD  DEFAULT (newid()) FOR [Id]
  GO
  
  ALTER TABLE [dbo].[CP_LenderSecurityProfile] ADD  CONSTRAINT [DF_LenderSecurityProfile_Created]  DEFAULT (getdate()) FOR [Created]
  GO
  
  ALTER TABLE [dbo].[CP_LenderSecurityProfile] ADD  CONSTRAINT [DF_LenderSecurityProfile_Modified]  DEFAULT (getdate()) FOR [Modified]
  GO