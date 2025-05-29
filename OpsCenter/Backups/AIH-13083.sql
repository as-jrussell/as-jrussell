_USE [Unitrac_SmokeTest_10.3]
GO
CREATE USER [UTdbSmokeTest-DEV] FOR LOGIN [UTdbSmokeTest-DEV]
GO
USE [Unitrac_SmokeTest_10.3]
GO
ALTER USER [UTdbSmokeTest-DEV] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [Unitrac_SmokeTest_10.3]
GO
ALTER ROLE [db_owner] ADD MEMBER [UTdbSmokeTest-DEV]
GO
USE [Unitrac_SmokeTest_ReleaseCandidate]
GO
CREATE USER [UTdbSmokeTest-DEV] FOR LOGIN [UTdbSmokeTest-DEV]
GO
USE [Unitrac_SmokeTest_ReleaseCandidate]
GO
ALTER USER [UTdbSmokeTest-DEV] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [Unitrac_SmokeTest_ReleaseCandidate]
GO
ALTER ROLE [db_owner] ADD MEMBER [UTdbSmokeTest-DEV]
GO
USE [Unitrac_SmokeTest_Stable]
GO
CREATE USER [UTdbSmokeTest-DEV] FOR LOGIN [UTdbSmokeTest-DEV]
GO
USE [Unitrac_SmokeTest_Stable]
GO
ALTER USER [UTdbSmokeTest-DEV] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [Unitrac_SmokeTest_Stable]
GO
ALTER ROLE [db_owner] ADD MEMBER [UTdbSmokeTest-DEV]
GO


USE [ReportServer]
GO
CREATE USER [UTdbSmokeTest-DEV] FOR LOGIN [UTdbSmokeTest-DEV]
GO
USE [ReportServer]
GO
ALTER ROLE [db_owner] ADD MEMBER [UTdbSmokeTest-DEV]
GO



		USE [master]

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'SUBSCRIBERREPORTHISTORY', @locallogin = NULL , @useself = N'False', @rmtuser = N'UTdbSmokeTest-DEV', @rmtpassword = N'PasswordinCyberArk'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'UTPROD_RO', @locallogin = NULL , @useself = N'False', @rmtuser = N'UTdbSmokeTest-DEV', @rmtpassword = N'PasswordinCyberArk'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'UNITRAC-REPORTS', @locallogin = NULL , @useself = N'False', @rmtuser = N'UTdbSmokeTest-DEV', @rmtpassword = N'PasswordinCyberArk'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'RPTSERVER', @locallogin = NULL , @useself = N'False', @rmtuser = N'UTdbSmokeTest-DEV', @rmtpassword = N'PasswordinCyberArk'
