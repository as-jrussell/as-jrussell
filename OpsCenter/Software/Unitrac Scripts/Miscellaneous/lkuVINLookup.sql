USE [VUT]
GO

--ALTER TABLE [dbo].[lkuVINLookup] DROP CONSTRAINT [DF__lkuVINLoo__Creat__4D362B96]
--GO

--ALTER TABLE [dbo].[lkuVINLookup] DROP CONSTRAINT [DF__lkuVINLoo__Creat__4C42075D]
--GO

/****** Object:  Table [dbo].[lkuVINLookup]    Script Date: 10/1/2020 9:17:44 AM ******/


/****** Object:  Table [dbo].[lkuVINLookup]    Script Date: 10/1/2020 9:17:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lkuVINLookup20200920](
	[VIN] [varchar](18) NOT NULL,
	[Year] [varchar](4) NULL,
	[Make] [varchar](30) NULL,
	[Model] [varchar](30) NULL,
	[Body] [varchar](30) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](30) NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SOURCE_CD] [nvarchar](20) NULL,
	[XML_CONTAINER] [xml] NULL,
	[VehicleType] [nvarchar](250) NULL,
	[VehicleClass] [nvarchar](250) NULL,
	[CallCount] [int] NULL,
 CONSTRAINT [PK_VINLookup1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[lkuVINLookup20200920] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[lkuVINLookup20200920] ADD  DEFAULT (suser_sname()) FOR [CreatedBy]
GO

USE [VUT_VINLookup20200920]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [idxVIN]    Script Date: 10/1/2020 9:19:43 AM ******/
CREATE NONCLUSTERED INDEX [idxVIN] ON [dbo].[lkuVINLookup20200920]
(
	[VIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


EXEC sp_rename 'dbo.lkuVINLookup', 'lkuVINLookup20200110_Org';

EXEC sp_rename 'dbo.lkuVINLookup20200920', 'lkuVINLookup';




select o.name as ObjName, r.name as ReferencedObj
from sys.sql_dependencies d
join sys.objects o on o.object_id=d.object_id
join sys.objects r on r.object_id=d.referenced_major_id
where d.class=1
AND r.name = 'lkuVINLookup20200920'

Exec sp_spaceused lkuVINLookup
--55,128,268           

Select top 10 * from lkuVINLookup order by ID desc