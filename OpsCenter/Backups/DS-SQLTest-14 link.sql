USE [master]
GO

/****** Object:  LinkedServer [DS-SQLTEST-14.RD.AS.LOCAL]    Script Date: 7/7/2022 9:42:38 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'DS-SQLTEST-14.RD.AS.LOCAL', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DS-SQLTEST-14.RD.AS.LOCAL',@useself=N'False',@locallogin=NULL,@rmtuser=N'PIMSdbLinkedUTStage_DSTest',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DS-SQLTEST-14.RD.AS.LOCAL', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

