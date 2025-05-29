USE [master]
GO

/****** Object:  LinkedServer [UTPROD_RO]    Script Date: 6/24/2016 3:19:55 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UTPROD_RO', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'utqa-sql-14', @catalog=N'UniTrac'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UTPROD_RO',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTQAAdmin',@rmtpassword='pVwOIhk0MmD'

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

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'collation name', @optvalue=NULL
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTPROD_RO', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO





USE UniTrac

UPDATE USErs 
SET PASSWORD_TX = 'uTqu6OApwDdtd6MymoPiy1806leUIeGioIk+icVePJI='
--SELECT * FROM dbo.USERS
WHERE USER_NAME_TX = 'jrussell'