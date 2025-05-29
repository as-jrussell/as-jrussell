USE [master]
GO

DECLARE @targetDB VARCHAR(100) = 'PerfStats'; -- <targetDB>
DECLARE @dataPath NVARCHAR(100), @logPath NVARCHAR(100), @createStatement VARCHAR(MAX);

SELECT @dataPath = convert(varchar(100),SERVERPROPERTY('InstanceDefaultDataPath'));  --select   SERVERPROPERTY('InstanceDefaultDataPath')
SELECT @logPath = convert(varchar(100),SERVERPROPERTY('InstanceDefaultLogPath'));

If( (isNull(@logPath,'') = '') OR (isNull(@logPath,'') = '') ) 
BEGIN
	RAISERROR ('Raise Error: Default Paths not defined', 16, 1);
END

SELECT @createStatement = 'CREATE DATABASE ['+ @targetDB +']
 CONTAINMENT = NONE
 ON PRIMARY 
( NAME = N'''+ @targetDB +''', FILENAME = N'''+  @dataPath + @targetDB +'.mdf'' , SIZE = 10240MB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024MB ) 
 LOG ON 
( NAME = N'''+ @targetDB +'_log'', FILENAME = N'''+  @logPath + @targetDB +'_log.ldf'' , SIZE = 2048MB , MAXSIZE = 2048GB , FILEGROWTH = 1024MB )
';
PRINT @createStatement;
EXEC(@createStatement);

DECLARE @alterStatement VARCHAR(100), @execStatement VARCHAR(100);
/****** Object:  Database [PerfStats]    Script Date: 12/22/2020 3:33:00 PM ******/
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
	SELECT @execStatement = 'EXEC ['+ @targetDB +'].[dbo].[sp_fulltext_database] @action = ''enable'';';
	PRINT @execStatement
	EXEC(@execStatement);
END

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET ANSI_NULL_DEFAULT OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET ANSI_NULLS OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET ANSI_PADDING OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET ANSI_WARNINGS OFF;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET ARITHABORT OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET AUTO_CLOSE OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET AUTO_SHRINK OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET AUTO_UPDATE_STATISTICS ON;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET CURSOR_CLOSE_ON_COMMIT OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET CURSOR_DEFAULT  GLOBAL;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET CONCAT_NULL_YIELDS_NULL OFF;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET NUMERIC_ROUNDABORT OFF;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET QUOTED_IDENTIFIER OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET RECURSIVE_TRIGGERS OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET  DISABLE_BROKER;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET AUTO_UPDATE_STATISTICS_ASYNC OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET DATE_CORRELATION_OPTIMIZATION OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET TRUSTWORTHY OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET ALLOW_SNAPSHOT_ISOLATION OFF;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET PARAMETERIZATION SIMPLE;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET READ_COMMITTED_SNAPSHOT OFF;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET HONOR_BROKER_PRIORITY OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET RECOVERY SIMPLE;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET  MULTI_USER;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET PAGE_VERIFY CHECKSUM;';  
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET DB_CHAINING OFF;';
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF );'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET TARGET_RECOVERY_TIME = 60 SECONDS;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET DELAYED_DURABILITY = DISABLED;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

--SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET QUERY_STORE = OFF;';
--PRINT @alterStatement;
--EXEC(@alterStatement);

SELECT @alterStatement = 'ALTER DATABASE ['+ @targetDB +'] SET READ_WRITE;'; 
PRINT @alterStatement;
EXEC(@alterStatement);

--SELECT @alterStatement = 'ALTER AUTHORIZATION ON DATABASE::['+ @targetDB +'] TO [sa];';
--PRINT @alterStatement;
--EXEC(@alterStatement);
