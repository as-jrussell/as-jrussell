USE [master]
GO

/****** Object:  LinkedServer [TIMMAY]    Script Date: 1/15/2021 4:14:40 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'TIMMAY', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'TIMMAY',@useself=N'False',@locallogin=NULL,@rmtuser=N'sa',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'TIMMAY', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

