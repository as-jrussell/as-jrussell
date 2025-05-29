USE [master]
GO

/****** Object:  LinkedServer [WINTRAQSQL.COLO.AS.LOCAL]    Script Date: 7/5/2022 2:39:33 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'WINTRAQSQL.COLO.AS.LOCAL', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'WINTRAQSQL.COLO.AS.LOCAL',@useself=N'False',@locallogin=NULL,@rmtuser=N'ProdSyncUser',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'WINTRAQSQL.COLO.AS.LOCAL', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


USE [master]
GO

/****** Object:  LinkedServer [VUT-DB01]    Script Date: 7/5/2022 2:39:55 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'VUT-DB01', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'VUT-DB01',@useself=N'False',@locallogin=NULL,@rmtuser=N'VUTAppUser',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'VUT-DB01', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


USE [master]
GO

/****** Object:  LinkedServer [UT-STG-LISTENER]    Script Date: 7/5/2022 2:40:25 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UT-STG-LISTENER', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UT-STG-LISTENER',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTdbLinkedUTDB01_UTSTGLISTENER',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UT-STG-LISTENER', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

USE [master]
GO

/****** Object:  LinkedServer [UTSTAGE01]    Script Date: 7/5/2022 2:42:04 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UTSTAGE01', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UTSTAGE01',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTdbLinkedUTDB01_UTSTAGE01',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTSTAGE01', @optname=N'rpc out', @optvalue=N'false'
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

USE [master]
GO

/****** Object:  LinkedServer [UTQA-SQL]    Script Date: 7/5/2022 2:43:48 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'UTQA-SQL', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'UTQA-SQL',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTdbLinkedUTDB01_UTQA',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'UTQA-SQL', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

USE [master]
GO

/****** Object:  LinkedServer [MRHAT]    Script Date: 7/5/2022 2:44:48 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'MRHAT', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'MRHAT',@useself=N'False',@locallogin=NULL,@rmtuser=N'sa',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MRHAT', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

USE [master]
GO

/****** Object:  LinkedServer [DPASTATS]    Script Date: 7/5/2022 2:45:22 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'DPASTATS', @srvproduct=N'sql_server', @provider=N'SQLNCLI11', @datasrc=N'IGNITE-SQL14'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DPASTATS',@useself=N'False',@locallogin=NULL,@rmtuser=N'UTdbLinkedUTDB01_IGNITESQL14',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'DPASTATS', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


