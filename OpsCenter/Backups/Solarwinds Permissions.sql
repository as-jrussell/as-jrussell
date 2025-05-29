ALTER SERVER ROLE [sysadmin] DROP MEMBER [solarwinds_sql]
GO

--USE [QCModule]
--GO
--CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
--GO
--USE [QCModule]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
--GO
--USE [QCModule]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
--GO
--USE [UniTrac]
--GO
--CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
--GO
--USE [UniTrac]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
--GO
--USE [UniTrac]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
--GO


USE UTL
GO
CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
GO
USE UTL
GO
ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
GO
USE [UTL]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
GO


ALTER LOGIN [ELDREDGE_A\Solarwinds] DISABLE
GO


ALTER LOGIN [solarwinds] DISABLE
GO




USE [LIMC]
GO
CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
GO
USE [LIMC]
GO
ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
GO
USE [LIMC]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
GO




USE [LIMC]
GO
CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
GO
USE [LIMC]
GO
ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
GO
USE [LIMC]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
GO
USE [VUT]
GO
CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
GO
USE [VUT]
GO
ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
GO
USE [VUT]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
GO

USE [OperationalDashboard]
GO
CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
GO
USE [OperationalDashboard]
GO
ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
GO
USE [OperationalDashboard]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
GO
USE [OspreyDashboard]
GO
CREATE USER [solarwinds_sql] FOR LOGIN [solarwinds_sql]
GO
USE [OspreyDashboard]
GO
ALTER ROLE [db_datareader] ADD MEMBER [solarwinds_sql]
GO
USE [OspreyDashboard]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [solarwinds_sql]
GO

--	EXEC xp_ReadErrorLog 0, 1, N'solarwinds'



--USE [master]
--GO
--EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', REG_DWORD, 2
--GO
