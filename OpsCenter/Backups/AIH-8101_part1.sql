USE [master]
GO

/****** Object:  LinkedServer [DS-SQLDEV-14]    Script Date: 10/4/2021 2:16:24 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'DS-SQLDEV-14', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DS-SQLDEV-14',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTdbLinkedUTSQLDEV01_DSSQLDEV14',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'name', @optvalue=N'ALLIED-PIMSDB'
GO
