USE [master]
GO

/****** Object:  LinkedServer [UTPROD_RO]    Script Date: 10/9/2017 10:40:08 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UTPROD_RO', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'10.10.18.172', @catalog=N'UniTrac'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UTPROD_RO',@useself=N'False',@locallogin=NULL,@rmtuser=N'Informatica',@rmtpassword='########'

GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

