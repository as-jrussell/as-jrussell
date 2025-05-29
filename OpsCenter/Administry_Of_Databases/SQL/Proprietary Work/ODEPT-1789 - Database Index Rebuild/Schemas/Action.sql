USE [PerfStats]
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'action')
	EXEC sys.sp_executesql N'CREATE SCHEMA [action]'
GO

