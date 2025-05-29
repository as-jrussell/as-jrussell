
USE [tempdb]
GO

/****** Object:  Login [ELDREDGE_A\Solarwinds]    Script Date: 8/13/2021 8:32:19 AM ******/
CREATE LOGIN [ELDREDGE_A\Solarwinds] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
GO


/****** Object:  Login [ELDREDGE_A\SQL Administrators]    Script Date: 8/13/2021 8:32:36 AM ******/
CREATE LOGIN [ELDREDGE_A\SQL Administrators] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
GO


/****** Object:  Login [ELDREDGE_A\SQL Server Maint Group]    Script Date: 8/13/2021 8:32:51 AM ******/
CREATE LOGIN [ELDREDGE_A\SQL Server Maint Group] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
GO

/****** Object:  Login [ELDREDGE_A\Avamar-SQL]    Script Date: 8/13/2021 8:33:51 AM ******/
CREATE LOGIN [ELDREDGE_A\Avamar-SQL] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
GO


/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [SolarWindsOrionDatabaseUser]    Script Date: 8/13/2021 8:34:42 AM ******/
CREATE LOGIN [SolarWindsOrionDatabaseUser] WITH PASSWORD=N'3rxdVNoRoXzpPJzW/C1Wf85BZEpDUm3dYp9hdy7we7M=', DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [SolarWindsOrionDatabaseUser] DISABLE
GO

ALTER SERVER ROLE [securityadmin] ADD MEMBER [SolarWindsOrionDatabaseUser]
GO

