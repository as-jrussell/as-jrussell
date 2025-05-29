USE [master]
GO

/****** Object:  Login [ELDREDGE_A\svc_idpm_dev01]    Script Date: 4/22/2022 9:37:27 AM ******/
DROP LOGIN [ELDREDGE_A\svc_idpm_dev01]
GO


USE [master]
GO
CREATE LOGIN [svc_idpm_dev01] WITH PASSWORD=N'please do not save with password added', DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
USE [CPI_STUDY]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [CPI_STUDY]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]

GO
USE [HDTStorage]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]

GO
USE [HDTStorage]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [IQQ_COMMON_EDW]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [IQQ_COMMON_EDW]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO

USE [IQQ_LIVE_EDW]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [IQQ_LIVE_EDW]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [IVOS_EDW]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [IVOS_EDW]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [JCs]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [JCs]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [PremAcc3_EDW]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [PremAcc3_EDW]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [ReportServer]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [ReportServer]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [ReportServerTempDB]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [ReportServerTempDB]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [TraceDB]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [TraceDB]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [UniTrac_DW]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [UniTrac_DW]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [UNITRAC_EDW]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [UNITRAC_EDW]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [UniTracArchive]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [UniTracArchive]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
USE [UniTracHDStorage]
GO
CREATE USER [svc_idpm_dev01] FOR LOGIN [svc_idpm_dev01]
GO
USE [UniTracHDStorage]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_idpm_dev01]
GRANT VIEW DEFINITION TO [svc_idpm_dev01]
GO
