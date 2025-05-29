USE [PerfStats]
GO

/****** Object:  Table [dbo].[IndexRebuildLog]    Script Date: 9/30/2024 9:42:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/* Creat table if it does not exist */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[action].[IndexRebuildLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [action].[IndexRebuildLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[TableName] [nvarchar](128) NULL,
	[IndexName] [nvarchar](128) NULL,
	[ExecutionDate] [datetime] NULL,
	[DurationMinutes] [int] NULL,
	[Status] [nvarchar](50) NULL,
	[User] NVARCHAR(128) NULL
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END 


