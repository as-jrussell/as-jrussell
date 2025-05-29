USE [PerfStats]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PurgeConfig]') AND type in (N'U'))
BEGIN

---Talk about if want to have a standardized table if want to have multiple different jobs using this

CREATE TABLE [dbo].[PurgeConfig](
	[JobName] [nvarchar](100) NOT NULL,
	[Seconds] [int] NOT NULL,
	[Source] [int] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END


