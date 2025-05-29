USE [master]
GO

/****** Object:  LinkedServer [UTSTAGE01]    Script Date: 12/6/2021 10:09:29 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UTSTAGE01', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UTSTAGE01',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTdbLinkedUTSTGLISTENER_UTSTAGE01',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


