USE [master]
GO

/****** Object:  Database [PRL_AIRACADEMY_1555_PROD]    Script Date: 3/1/2021 9:47:50 PM ******/

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PRL_AIRACADEMY_1555_PROD')
BEGIN

CREATE DATABASE [PRL_AIRACADEMY_1555_PROD]
 CONTAINMENT = NONE
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PRL_AIRACADEMY_1555_PROD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET ANSI_NULL_DEFAULT ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET ANSI_NULLS ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET ANSI_PADDING ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET ANSI_WARNINGS ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET ARITHABORT ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET CURSOR_DEFAULT  LOCAL 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET CONCAT_NULL_YIELDS_NULL ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET QUOTED_IDENTIFIER ON 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET DB_CHAINING OFF 
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET ENCRYPTION ON
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET QUERY_STORE = ON
GO

ALTER DATABASE [PRL_AIRACADEMY_1555_PROD] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO


/*

****USE THIS TO CREATE USERS********************************************
EXEC DBA.[rfpl].[CreateRFPLSQLUser] @DryRun = 0 --Refresh all permissions
************************************************************************
*/