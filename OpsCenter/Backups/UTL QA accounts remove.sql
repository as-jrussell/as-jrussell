USE [master]
GO

/****** Object:  Login [UTQALinkedVMAX]    Script Date: 12/2/2022 10:07:13 AM ******/
DROP LOGIN [UTQALinkedVMAX]
GO

USE [DBA]
GO
/****** Object:  User [ELDREDGE_A\IT Sys Admins]    Script Date: 12/2/2022 10:02:27 AM ******/
DROP USER [ELDREDGE_A\IT Sys Admins]
GO



USE [master]
GO

/****** Object:  Login [ELDREDGE_A\Sys Admins]    Script Date: 12/2/2022 10:03:45 AM ******/
DROP LOGIN [ELDREDGE_A\Sys Admins]
GO


USE [master]
GO

/****** Object:  Login [egold]    Script Date: 12/2/2022 9:53:33 AM ******/
DROP LOGIN [egold]
GO

USE [master]
GO

/****** Object:  Login [ELDREDGE_A\egold]    Script Date: 12/2/2022 9:53:55 AM ******/
DROP LOGIN [ELDREDGE_A\egold]
GO

USE [master]
GO

/****** Object:  Login [m_agarwal]    Script Date: 12/2/2022 9:54:54 AM ******/
DROP LOGIN [m_agarwal]
GO

USE [HDTStorage]
GO
ALTER ROLE [db_datareader] DROP MEMBER [ELDREDGE_A\SQL_UniTrac_Development_Team]
GO
USE [HDTStorage]
GO
ALTER ROLE [db_datawriter] DROP MEMBER [ELDREDGE_A\SQL_UniTrac_Development_Team]
GO


USE [master]
GO
/****** Object:  User [ELDREDGE_A\SQL_UniTrac_ReadOnly]    Script Date: 12/2/2022 9:56:25 AM ******/
DROP USER [ELDREDGE_A\SQL_UniTrac_ReadOnly]
GO

+


USE [master]
GO

/****** Object:  Login [ELDREDGE_A\UniTrac System Administrators]    Script Date: 12/2/2022 9:58:47 AM ******/
DROP LOGIN [ELDREDGE_A\UniTrac System Administrators]
GO


USE [master]
GO

/****** Object:  Login [ELDREDGE_A\Unitrac Development Team]    Script Date: 12/2/2022 9:59:04 AM ******/
DROP LOGIN [ELDREDGE_A\Unitrac Development Team]
GO


USE [master]
GO

/****** Object:  Login [ELDREDGE_A\UniTrac Read Only]    Script Date: 12/2/2022 9:59:25 AM ******/
DROP LOGIN [ELDREDGE_A\UniTrac Read Only]
GO

ALTER SERVER ROLE [sysadmin] DROP MEMBER [UniTracAppUser]
GO
USE [UTL]
GO
CREATE USER [UniTracAppUser] FOR LOGIN [UniTracAppUser]
GO
USE [UTL]
GO
ALTER USER [UniTracAppUser] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [UTL]
GO
ALTER ROLE [db_owner] ADD MEMBER [UniTracAppUser]
GO

