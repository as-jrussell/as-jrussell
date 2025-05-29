USE [CenterPointSecurity]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CP_PasswordHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CP_PasswordHistory](
	[Id] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[Created] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

/* ADD columns that changed after initial deploy */
IF EXISTS(SELECT *
              FROM sys.columns 
              WHERE Name      = N'Id'
                AND Object_ID = Object_ID(N'[CP_PasswordHistory]'))
BEGIN
    ALTER TABLE [dbo].[CP_PasswordHistory] ADD  CONSTRAINT [DF_CP_PasswordHistory_Id]  DEFAULT (newid()) FOR [Id];
END;


IF EXISTS(SELECT *
              FROM sys.columns 
              WHERE Name      = N'Created'
                AND Object_ID = Object_ID(N'[CP_PasswordHistory]'))
BEGIN
    ALTER TABLE [dbo].[CP_PasswordHistory] ADD  CONSTRAINT [DF_CP_PasswordHistory_Created]  DEFAULT (getdate()) FOR [Created];
END;

ELSE 
BEGIN 
	PRINT 'Table already created'
END;