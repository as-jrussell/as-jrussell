USE [TestFileShrink]
GO

/****** Object:  Table [dbo].[Table1]    Script Date: 10/2/2023 9:49:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

USE [master]
GO

/****** Object:  Database [TestFileShrink]    Script Date: 10/2/2023 9:49:31 AM ******/
CREATE DATABASE [TestFileShrink]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestFileShrink_data', FILENAME = N'C:\Downloads\SQLDATA\TestFileShrink_data.mdf' , SIZE = 512KB , MAXSIZE = 15000 MB , FILEGROWTH = 10 MB )
 LOG ON 
( NAME = N'TestFileShrink_log', FILENAME = N'C:\Downloads\SQLLOGS\TestFileShrink_log.ldf' , SIZE = 512KB , MAXSIZE = 1024 MB , FILEGROWTH = 10 MB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO


CREATE TABLE [dbo].[Table1](
	[col1] [int] IDENTITY(1,1) NOT NULL,
	[col2] [char](7000) NULL,
PRIMARY KEY CLUSTERED 
(
	[col1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Table1] ADD  DEFAULT ('Any value in Table 1') FOR [col2]
GO



  INSERT [TestFileShrink].[dbo].[Table]
  valUES ('Any value in Table 1')
  Go 250000




  /*
SELECT TOP (1000) [col1]
      ,[col2]
  FROM [TestFileShrink].[dbo].[Table]


--  	   truncate table [TestFileShrink].[dbo].[Table]

USE [TestFileShrink]
GO
DBCC SHRINKDATABASE(N'TestFileShrink' )
GO
