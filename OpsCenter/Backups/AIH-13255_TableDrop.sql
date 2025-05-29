USE [AppLog]
GO

/****** Object:  Table [dbo].[Applog_old]    Script Date: 8/16/2022 12:36:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Applog_old]') AND type in (N'U'))
DROP TABLE [dbo].[Applog_old]
GO


