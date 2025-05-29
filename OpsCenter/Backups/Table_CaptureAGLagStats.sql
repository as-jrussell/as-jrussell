USE [PerfStats]
GO

/****** Object:  Table [dbo].[AGLagStats]    Script Date: 1/16/2023 2:11:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AGLagStats]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AGLagStats](
	[seconds behind] [int] NULL,
	[ServerName] [varchar](250) NULL,
	[DatabaseName - secondary_replica] [varchar](250) NULL,
	[Is_Suspended] [int] NULL,
	[group_name] [varchar](100) NULL,
	[availability_mode_desc] [varchar](100) NULL,
	[Current_DT] [datetime] NULL,
	[ID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END



