USE [master]
GO

/****** Object:  LinkedServer [UNITRAC-REPORTS]    Script Date: 3/19/2021 9:41:40 AM ******/
EXEC master.dbo.sp_dropserver @server=N'UNITRAC-REPORTS', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [UT-PRD-LISTENER]    Script Date: 3/19/2021 9:42:04 AM ******/
EXEC master.dbo.sp_dropserver @server=N'UT-PRD-LISTENER', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [VUTSTAGE01]    Script Date: 3/19/2021 9:42:30 AM ******/
EXEC master.dbo.sp_dropserver @server=N'VUTSTAGE01', @droplogins='droplogins'
GO
