USE [OperationalDashboard]
GO
CREATE USER [UTdbInternalDashWinServiceQA] FOR LOGIN [UTdbInternalDashWinServiceQA]
GO
USE [OperationalDashboard]
GO
ALTER ROLE [db_datareader] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
USE [OperationalDashboard]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
USE [UniTrac]
GO
CREATE USER [UTdbInternalDashWinServiceQA] FOR LOGIN [UTdbInternalDashWinServiceQA]
GO
USE [UniTrac]
GO
ALTER ROLE [db_datareader] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
USE [UniTrac]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
USE [UniTrac_DW]
GO
CREATE USER [UTdbInternalDashWinServiceQA] FOR LOGIN [UTdbInternalDashWinServiceQA]
GO
USE [UniTrac_DW]
GO
ALTER ROLE [db_datareader] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
USE [UniTrac_DW]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
USE [VUT]
GO
CREATE USER [UTdbInternalDashWinServiceQA] FOR LOGIN [UTdbInternalDashWinServiceQA]
GO
USE [VUT]
GO
ALTER ROLE [db_datareader] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
USE [VUT]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UTdbInternalDashWinServiceQA]
GO
