USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'SysLog'
GO


USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'AppLog'
GO
