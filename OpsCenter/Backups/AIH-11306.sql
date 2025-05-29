ALTER SERVER ROLE [sysadmin] DROP MEMBER [fims]
GO
USE [RepoPlusAnalytics]
GO
ALTER ROLE [db_datareader] ADD MEMBER [fims]
GO
USE [RepoPlusAnalytics]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [fims]
GO
USE [RepoPlusAnalytics]
GO
ALTER ROLE [db_owner] DROP MEMBER [fims]
GO
USE [SkipAgentInvoices]
GO
ALTER ROLE [db_owner] DROP MEMBER [fims]
GO
USE [X25]
GO
ALTER ROLE [db_owner] DROP MEMBER [fims]
GO
