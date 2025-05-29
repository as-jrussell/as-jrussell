USE [master]
GO

/****** Object:  LinkedServer [VUTSTAGE01]    Script Date: 3/19/2021 9:42:30 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'VUTSTAGE01', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'VUTSTAGE01',@useself=N'False',@locallogin=NULL,@rmtuser=N'devsa',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'VUTSTAGE01', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO




/****** Object:  LinkedServer [UT-PRD-LISTENER]    Script Date: 3/19/2021 9:42:04 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UT-PRD-LISTENER', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UT-PRD-LISTENER',@useself=N'False',@locallogin=NULL,@rmtuser=N'sa',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-PRD-LISTENER', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO






















/****** Object:  LinkedServer [UNITRAC-REPORTS]    Script Date: 3/19/2021 9:41:40 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UNITRAC-REPORTS', @srvproduct=N'sql_server', @provider=N'SQLNCLI11', @datasrc=N'UNITRAC-RPT01'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UNITRAC-REPORTS',@useself=N'False',@locallogin=NULL,@rmtuser=N'informix_upload',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UNITRAC-REPORTS', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

