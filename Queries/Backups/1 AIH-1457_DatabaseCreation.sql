use [master]
GO 

CREATE DATABASE [WinAppLog]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WinAppLog', FILENAME = N'E:\SQLDATA\WinAppLog.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WinAppLog_log', FILENAME = N'F:\SQLLOGS\WinAppLog_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [WinAppLog] SET COMPATIBILITY_LEVEL = 130
GO
ALTER DATABASE [WinAppLog] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WinAppLog] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WinAppLog] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WinAppLog] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WinAppLog] SET ARITHABORT OFF 
GO
ALTER DATABASE [WinAppLog] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WinAppLog] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WinAppLog] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [WinAppLog] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WinAppLog] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WinAppLog] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WinAppLog] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WinAppLog] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WinAppLog] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WinAppLog] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WinAppLog] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WinAppLog] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WinAppLog] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WinAppLog] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WinAppLog] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WinAppLog] SET  READ_WRITE 
GO
ALTER DATABASE [WinAppLog] SET RECOVERY FULL 
GO
ALTER DATABASE [WinAppLog] SET  MULTI_USER 
GO
ALTER DATABASE [WinAppLog] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WinAppLog] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WinAppLog] SET DELAYED_DURABILITY = DISABLED 
GO
USE [WinAppLog]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE [WinAppLog]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [WinAppLog] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

USE [WinAppLog]
GO
CREATE USER [ELDREDGE_A\CP-SQL-DEV] FOR LOGIN [ELDREDGE_A\CP-SQL-DEV]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\CP-SQL-DEV]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ELDREDGE_A\CP-SQL-DEV]
GO




USE [WinAppLog]
GO
CREATE USER [ELDREDGE_A\SQL_CenterPoint_admins] FOR LOGIN [ELDREDGE_A\SQL_CenterPoint_admins]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\SQL_CenterPoint_admins]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ELDREDGE_A\SQL_CenterPoint_admins]
GO





USE [WinAppLog]
GO
CREATE USER [ELDREDGE_A\SQL_CenterPoint_Development_Team] FOR LOGIN [ELDREDGE_A\SQL_CenterPoint_Development_Team]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\SQL_CenterPoint_Development_Team]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ELDREDGE_A\SQL_CenterPoint_Development_Team]
GO



USE [WinAppLog]
GO
CREATE USER [CP-SQL-DEV] FOR LOGIN [CP-SQL-DEV]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datareader] ADD MEMBER [CP-SQL-DEV]
GO
USE [WinAppLog]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [CP-SQL-DEV]
GO

--This may get omitted but just don't want the owner be the DBA who run script
USE [WinAppLog]
GO
ALTER AUTHORIZATION ON DATABASE::[WinAppLog] TO [sa]
GO