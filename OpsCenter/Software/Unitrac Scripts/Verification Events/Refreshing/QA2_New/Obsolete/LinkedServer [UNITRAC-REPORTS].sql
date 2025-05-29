USE [master]
GO

/****** Object:  LinkedServer [UNITRAC-REPORTS]    Script Date: 6/24/2016 8:12:49 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UNITRAC-REPORTS', @srvproduct=N'sql_server', @provider=N'SQLNCLI11', @datasrc=N'utqa-sql-14', @catalog=N'Unitrac'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UNITRAC-REPORTS',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTQAAdmin',@rmtpassword='pVwOIhk0MmD'

GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'collation name', @optvalue=NULL
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


