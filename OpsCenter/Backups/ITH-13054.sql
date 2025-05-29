USE [VUT]
GO
CREATE USER [ELDREDGE_A\SQL_UniTrac_Development_Team] FOR LOGIN [ELDREDGE_A\SQL_UniTrac_Development_Team]
GO
USE [VUT]
GO
EXEC sp_addrolemember N'db_datareader', N'ELDREDGE_A\SQL_UniTrac_Development_Team'
GO
