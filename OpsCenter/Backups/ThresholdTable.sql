USE [PerfStats]
GO

/****** Object:  Table [dbo].[ThresholdConfig]    Script Date: 1/20/2023 12:47:59 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ThresholdConfig]') AND type in (N'U'))
DROP TABLE [dbo].[ThresholdConfig]
GO

/****** Object:  Table [dbo].[ThresholdConfig]    Script Date: 1/20/2023 12:47:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ThresholdConfig](
	[EventName] [nvarchar](100) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[broken] [nvarchar](100)  NULL,
	[normal] [nvarchar](100)  NULL,
	[info] [nvarchar](100) NOT NULL,
	[low] [nvarchar](100) NOT NULL,
	[medium] [nvarchar](100) NOT NULL,
	[high] [nvarchar](100) NOT NULL,
	[UnitsOfMeasure] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[EventName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


