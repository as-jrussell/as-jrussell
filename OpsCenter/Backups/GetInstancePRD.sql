USE [DBA]
GO

/****** Object:  StoredProcedure [info].[GetInstance]    Script Date: 9/29/2022 9:36:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [info].[GetInstance]   ******/
ALTER PROCEDURE [info].[GetInstance] ( @servername varchar(100) = '', @DomainName varchar(100) = '', @DryRun int = 1, @Debug int = 0 )
AS 
BEGIN
    -- ServerName DomainName InstnaceName parameters support Deploy tool with RDS instances
	-- EXEC dba.info.GetInstance  @ServerName = '', @DomainName = '', @DryRun = 0
	-- EXEC dba.info.GetInstance @Debug = 1
SET NOCOUNT ON
--DECLARE  @servername varchar(100) = 'sqlsstgawrd02', @DomainName varchar(100) = 'clm0vrvchewi.us-east-2.rds.amazonaws.com', @DryRun int = 1, @Debug int = 0
DECLARE @DAC NVARCHAR(100), @TCP NVARCHAR(100), @TCPDynamic NVARCHAR(100), @IP NVARCHAR(100)
DECLARE @InstanceName NVARCHAR(100), @registryPath NVARCHAR(MAX), @sqlVersion varchar(10), @ProductVersion int
DECLARE @xpCMD nvarchar(100), @sqlCMD nvarchar(max) --@ServerName NVARCHAR(100),

IF( @ServerName = '') SET @ServerName = ( SELECT [DBA].[info].[GetSystemConfig] ( 'Instance.name' , isnull(convert(varchar(max),serverproperty('ServerName')),'MSSQLSERVER')) ); -- SELECT @@Servername
IF( charindex ('\', @servername) > 0 ) SET @Servername = left(@Servername, charindex ('\', @servername)-1 );
SET @InstanceName = ( select isnull(convert(varchar(max),serverproperty('InstanceName')),'MSSQLSERVER') ); -- select serverproperty('instancename')
SET @ProductVersion = ( select  LEFT( convert(varchar(max),SERVERPROPERTY('ProductVersion')), CharIndex('.', convert(varchar(max),SERVERPROPERTY('ProductVersion')))- 1) );

--DECLARE @Domain NVARCHAR(100)
IF( @DomainName = '' )
BEGIN
    IF( (select @@version) like '%AZURE%' )
        BEGIN
            SET @DomainName = REPLACE( convert(varchar(100), SERVERPROPERTY('ServerName')), LEFT(convert(varchar(100), SERVERPROPERTY('ServerName')),charIndex('.',convert(varchar(100), SERVERPROPERTY('ServerName')))),'');
        END
    ELSE
        BEGIN
            BEGIN TRY
                EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\services\Tcpip\Parameters', N'Domain', @DomainName OUTPUT
            END TRY
            BEGIN CATCH
                PRINT 'failed to get DOMAIN from xp_regread'
                SET @DomainName = (select TOP 1 DomainName from dba.info.instance ORDER BY HarvestDate DESC)
            END CATCH
        END;
END

IF(@ProductVersion < 11)
	BEGIN
		SET @sqlVersion = (select convert(varchar(max),@ProductVersion) +'_'+ LEFT( REPLACE(convert(varchar(max),SERVERPROPERTY('ProductVersion')), convert(varchar(max),@ProductVersion) +'.' ,'' ), CharIndex('.', REPLACE(convert(varchar(max),SERVERPROPERTY('ProductVersion')), convert(varchar(max),@ProductVersion) +'.' ,'' ))- 1))
	
        IF( @sqlVersion = '10_0' ) SET @sqlVersion= '10'
    END
ELSE
	BEGIN
		SET @sqlVersion = (select  LEFT( convert(varchar(max),SERVERPROPERTY('ProductVersion')), CharIndex('.', convert(varchar(max),SERVERPROPERTY('ProductVersion')))- 1))
        IF( @Servername IN ('OCR-SQLPRD-01', 'OCR-SQLPRD-04') ) SET @sqlVersion = 13
	END

/*  DAC */
SET @registryPath = (SELECT 'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL'+ @sqlVersion +'.'+ @InstanceName +'\MSSQLServer\SuperSocketNetLib\AdminConnection\Tcp' )
IF( (select @@version) like '%AZURE%' )
    BEGIN
        SET @DAC = '0';
    END
ELSE
    BEGIN
        BEGIN TRY
		    EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', @registryPath, N'TcpDynamicPorts', @DAC OUTPUT
        END TRY
        BEGIN CATCH
            PRINT 'failed to get DAC from xp_regread'
            SET @DAC = '0';
        END CATCH
	END;

/* TCP */
SET @registryPath = (SELECT 'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL'+ @sqlVersion +'.'+ @InstanceName +'\MSSQLServer\SuperSocketNetLib\Tcp\IPAll' )
IF( (select @@version) NOT like '%AZURE%' )
    BEGIN
        BEGIN TRY        
            EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', @registryPath, N'TcpPort', @TCP OUTPUT
        END TRY
        BEGIN CATCH
            PRINT 'failed to get TCP from xp_regread'
            SET @TCP = '0';
        END CATCH
    END;

/* TCP DYNAMIC */
SET @registryPath = (SELECT 'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL'+ @sqlVersion +'.'+ @InstanceName +'\MSSQLServer\SuperSocketNetLib\Tcp\IPAll' )
IF( (select @@version) like '%AZURE%' )
    BEGIN
        SET @TCPDynamic = 0;
    END
ELSE
    BEGIN
        BEGIN TRY
		    EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', @registryPath, N'TcpDynamicPorts', @TCPDynamic OUTPUT
        END TRY
        BEGIN CATCH
            PRINT 'failed to get TCPDynamic from xp_regread'
            SET @TCPDynamic = 0;
        END CATCH
	END;

/* IP */
SET @registryPath = (SELECT 'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL'+ @sqlVersion +'.'+ @InstanceName +'\MSSQLServer\SuperSocketNetLib\Tcp\IP2' )
IF( (select @@version) like '%AZURE%' OR @DomainName like '%.RDS.%')
    BEGIN
		-- Select distinct local_net_address, local_tcp_port from sys.dm_exec_connections where local_net_address is not null and Local_net_Address not like '10.%'
        select distinct @IP = local_net_address, @TCP = local_tcp_port from sys.dm_exec_connections where local_net_address is not null and Local_net_Address not like '10.%'

    END
ELSE
    BEGIN
        BEGIN TRY 
		    EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', @registryPath, N'IPAddress', @IP OUTPUT
        END TRY
        BEGIN CATCH
            PRINT 'failed to get IP/TCP from xp_regread'
            SET @TCP = 0;
            SET @IP = 0;
        END CATCH
	END;

IF( (select @@version) like '%AZURE%' )
    BEGIN
        select distinct @IP = local_net_address, @TCP = local_tcp_port from sys.dm_exec_connections where local_net_address is not null
    END
ELSE
    BEGIN
		IF OBJECT_ID('tempdb..#results') IS NOT NULL
			DROP TABLE #results
		CREATE TABLE #results(
			RowNumber int identity (1,1),
			output varchar(max) )
        
        SELECT @xpCMD = 'nslookup '+ REPLACE(REPLACE(@ServerName ,'NEWTIMMAY','TIMMAY'), 'SITECOREBUILD01', 'SITECORE-BUILD' ) -- instance name DNS mismatches 

        BEGIN TRY
		    INSERT INTO #results
		        EXEC xp_cmdshell @xpCMD --DailyHarvest;
        END TRY
        BEGIN CATCH
            PRINT 'Failed to get IP from xp_cmdShell'
        END CATCH

		DELETE FROM #results where output is null

		SELECT @IP = lTrim(REPLACE(output,'Address: ','')) FROM  #results where RowNumber = ( SELECT Max(RowNumber) FROM  #results)
		--SELECT IsNull(@TCP, @TCPDynamic), @DAC, @IP
	END;


/*
######################################################################
			CREATE TEMP TABLE
######################################################################
*/
IF OBJECT_ID('tempdb..#Instance') IS NOT NULL
	DROP TABLE #Instance
CREATE TABLE #Instance(
	[SQLServerName] [nvarchar](128) NOT NULL,
	[MachineName] [varchar](48) NOT NULL,
	[InstanceName] [varchar](48) NOT NULL,
	[DomainName] [varchar](48) NOT NULL,
	[Local_Net_Address] [varchar](48) NOT NULL,
	[Port] [int] NOT NULL,
	[DACPort] [int] NOT NULL,
	[ProductName] [nvarchar](48) NULL,
	[ProductVersion] [nvarchar](48) NOT NULL,
	[ProductLevel] [nvarchar](48) NOT NULL,
	[ProductUpdateLevel] [nvarchar](10) NULL,
	[Edition] [nvarchar](148) NOT NULL,
	[EngineEdition] [nvarchar](48) NOT NULL,
	[MIN_SIZE_SERVER_MEMORY_MB] [sql_variant] NOT NULL,
	[MAX_SIZE_SERVER_MEMORY_MB] [sql_variant] NOT NULL,
	[CTFP] [int] NOT NULL,
	[MDOP] [int] NOT NULL,
	[IsAdHocEnabled] [int] NOT NULL,
	[IsDBMailEnabled] [int] NOT NULL,
	[IsAgentXPsEnabled] [int] NOT NULL,
	[IsHadrEnabled] [int] NOT NULL,
	[HadrManagerStatus] [nvarchar](48) NOT NULL,
	[InSingleUser] [int] NOT NULL,
	[IsClustered] [int] NOT NULL,
	[ServerEnvironment] [nvarchar](48) NOT NULL,
	[ServerStatus] [nvarchar](128) NULL,
    [ServerLocation] [nvarchar](128) NULL,
	[Comments] [nvarchar](128) NULL,
    [HarvestDate] [DateTime]
) 

SELECT @sqlCMD = '       
	SELECT '''+ upper(@ServerName) +''' AS [SQLServerName],    
        --convert(varchar(100), SERVERPROPERTY(''ServerName'')) AS [SQLServerName],  
        UPPER(IsNull(convert(varchar(100), SERVERPROPERTY(''MachineName'')), LEFT(convert(varchar(100), SERVERPROPERTY(''ServerName'')),charIndex(''.'',convert(varchar(100), SERVERPROPERTY(''ServerName'')))-1) )) AS [MachineName], 
		--(SELECT SERVERPROPERTY(''computerNamePhysicalNetBIOS'')) AS [ServerName],
        '''+ upper(@InstanceName) +''' AS [InstanceName],
        '''+ upper(@DomainName) +''' AS [DomainName],
        '''+ @IP +''' AS [Local_Net_Address],  -- sELECT * FROM SYS.DM_EXEC_CONNECTIONS 
        '+ IsNull(@TCP, @TCPDynamic) +' as Port,      
        '+ @DAC +' as DACport,
        SUBSTRING ( (SELECT convert(varchar(100), @@VERSION)),1, CHARINDEX(''('',(SELECT REPLACE(convert(varchar(100), @@VERSION),''-'',''('')))-1 ) as [ProductName],
        convert(varchar(100), SERVERPROPERTY(''ProductVersion'')) AS [ProductVersion],  
        convert(varchar(100), SERVERPROPERTY(''ProductLevel'')) AS [ProductLevel],
        convert(varchar(10), SERVERPROPERTY(''ProductUpdateLevel'')) as [ProductUpdateLevel],
        --SERVERPROPERTY(''ProductMajorVersion'') AS [ProductMajorVersion],
        --SERVERPROPERTY(''ProductMinorVersion'') AS [ProductMinorVersion],
        --SERVERPROPERTY(''ProductBuild'') AS [ProductBuild],
        convert(varchar(100), SERVERPROPERTY(''Edition'')) AS [Edition],
        CASE convert(int, SERVERPROPERTY(''EngineEdition''))
            WHEN 1 THEN ''PERSONAL''
            WHEN 2 THEN ''STANDARD''
            WHEN 3 THEN ''ENTERPRISE''
            WHEN 4 THEN ''EXPRESS''
            WHEN 5 THEN ''SQL DATABASE''
            WHEN 6 THEN ''SQL DATAWAREHOUSE''
            WHEN 8 THEN ''Azure SQL Managed Instance''
        END AS [EngineEdition], 
        ( SELECT value FROM sys.configurations WHERE name like ''min server memory%'' ) AS [MIN_SIZE_SERVER_MEMORY_MB],  --select * from sys.configurations
        ( SELECT value FROM sys.configurations WHERE name like ''max server memory%'' ) AS [MAX_SIZE_SERVER_MEMORY_MB],
        ( SELECT convert(int, value) FROM sys.configurations WHERE name like ''cost threshold for parallelism%'' ) AS [CTFP],
        ( SELECT convert(int, value) FROM sys.configurations WHERE name like ''max degree of parallelism%'' ) AS [MDOP],
        ( SELECT convert(int, value) FROM sys.configurations WHERE name like ''Ad Hoc Distributed Queries%'' ) as [IsAdHocEnabled],
        ( SELECT convert(int, value) FROM sys.configurations WHERE name like ''Database Mail XPs%'' ) as [IsDBMailEnabled],
        ( SELECT convert(int, value) FROM sys.configurations WHERE name like ''Agent XPs%'' ) as [IsAgentXPsEnabled],
        CASE convert(int, SERVERPROPERTY(''IsHadrEnabled'')) WHEN 0 THEN 0 WHEN 1 THEN 1 ELSE 0 END AS IsHadrEnabled,
        CASE convert(int, SERVERPROPERTY(''HadrManagerStatus''))
            WHEN 0 THEN ''Not started, pending communication''
            WHEN 1 THEN ''Started and running''
            WHEN 2 THEN ''Not started and failed''
            ELSE ''Not applicable''
        END AS HadrManagerStatus,
        CASE convert(int, SERVERPROPERTY(''IsSingleUser'')) WHEN 0 THEN 0 ELSE 1 END AS InSingleUser,
        CASE convert(int, SERVERPROPERTY(''IsClustered'')) WHEN 1 THEN 1 WHEN 0 THEN 0 ELSE 0 END AS IsClustered,
        ( SELECT UPPER(info.GetSystemConfig(''Server.Environment'', ''ENV - Missing'')) ) as ServerEnvironment,
        '''' as ServerStatus,
         CASE   WHEN '''+ upper(@ServerName) +''' = ''TTUSPRDAZDB01'' THEN ''MS-AZURE'' -- Hard coded override....bad domain name
                WHEN '''+ SUBSTRING ( (SELECT convert(varchar(100), @@VERSION)),1, CHARINDEX('(',(SELECT REPLACE(convert(varchar(100), @@VERSION),'-','(')))-1 ) +''' = ''Microsoft SQL Azure'' THEN ''MS-AZURE''
                WHEN '''+ upper(@DomainName) +''' like ''%.RDS.%'' THEN ''AWS-RDS''
                WHEN '''+ @IP +''' like ''172.%'' THEN ''AWS-EC2''
                ELSE ''ON-PREM''
          END 
	   AS ServerLocation,
        '''+ CASE WHEN @DryRun = 0 THEN 'DESC' ELSE 'DryRun' END +''' as Comments,
        GetDate() As HarvestDate;'

        INSERT INTO #Instance
			EXEC(@sqlCMD)
 IF( @DryRun = 0 ) 
	 BEGIN
        /* Merge */
        MERGE info.instance AS TARGET
        USING #Instance AS SOURCE
        ON TARGET.MachineName = SOURCE.MachineName
        WHEN MATCHED AND ( TARGET.ProductName != SOURCE.ProductName OR TARGET.ProductVersion != SOURCE.ProductVersion OR TARGET.ProductLevel != SOURCE.ProductLevel OR
                           TARGET.ProductUpdateLevel != SOURCE.ProductUpdateLevel OR TARGET.Edition != SOURCE.Edition OR TARGET.EngineEdition != SOURCE.EngineEdition OR
                           TARGET.Local_Net_Address != SOURCE.Local_Net_Address OR IsNull(TARGET.ServerLocation, '') != SOURCE.ServerLocation OR
                           IsNull(TARGET.ServerEnvironment, '') != SOURCE.ServerEnvironment OR IsNull(TARGET.HarvestDate,'') != SOURCE.HarvestDate
				         ) THEN
	        UPDATE SET TARGET.ProductName = SOURCE.ProductName,
		        TARGET.ProductVersion = SOURCE.ProductVersion,
                TARGET.ProductLevel = SOURCE.ProductLevel,
                TARGET.ProductUpdateLevel = SOURCE.ProductUpdateLevel,
                TARGET.Edition = SOURCE.Edition,
                TARGET.EngineEdition = SOURCE.EngineEdition,
                TARGET.Local_Net_Address = SOURCE.Local_Net_Address,
                TARGET.ServerLocation = SOURCE.ServerLocation,
                TARGET.ServerEnvironment = SOURCE.ServerEnvironment,
                TARGET.HarvestDate = SOURCE.HarvestDate
        WHEN NOT MATCHED THEN
	        INSERT( [SQLServerName],
	                [MachineName],
	                [InstanceName],
	                [DomainName] ,
	                [Local_Net_Address],
	                [Port],
	                [DACPort],
	                [ProductName] ,
	                [ProductVersion],
	                [ProductLevel] ,
	                [ProductUpdateLevel],
	                [Edition] ,
	                [EngineEdition] ,
	                [MIN_SIZE_SERVER_MEMORY_MB] ,
	                [MAX_SIZE_SERVER_MEMORY_MB],
	                [CTFP] ,
	                [MDOP],
	                [IsAdHocEnabled],
	                [IsDBMailEnabled] ,
	                [IsAgentXPsEnabled] ,
	                [IsHadrEnabled],
	                [HadrManagerStatus] ,
	                [InSingleUser] ,
	                [IsClustered] ,
	                [ServerEnvironment] ,
	                [ServerStatus] ,
                    [ServerLocation],
	                [Comments],
                    [HarvestDate])
	        VALUES( SOURCE.[SQLServerName],
	                SOURCE.[MachineName],
	                SOURCE.[InstanceName],
	                SOURCE.[DomainName] ,
	                SOURCE.[Local_Net_Address],
	                SOURCE.[Port],
	                SOURCE.[DACPort],
	                SOURCE.[ProductName] ,
	                SOURCE.[ProductVersion],
	                SOURCE.[ProductLevel] ,
	                SOURCE.[ProductUpdateLevel],
	                SOURCE.[Edition] ,
	                SOURCE.[EngineEdition] ,
	                SOURCE.[MIN_SIZE_SERVER_MEMORY_MB] ,
	                SOURCE.[MAX_SIZE_SERVER_MEMORY_MB],
	                SOURCE.[CTFP] ,
	                SOURCE.[MDOP],
	                SOURCE.[IsAdHocEnabled],
	                SOURCE.[IsDBMailEnabled] ,
	                SOURCE.[IsAgentXPsEnabled] ,
	                SOURCE.[IsHadrEnabled],
	                SOURCE.[HadrManagerStatus] ,
	                SOURCE.[InSingleUser] ,
	                SOURCE.[IsClustered] ,
	                SOURCE.[ServerEnvironment] ,
	                SOURCE.[ServerStatus] ,
                    SOURCE.[ServerLocation] ,
	                SOURCE.[Comments],
                    GetDate()
            );

	END
ELSE
	BEGIN
		if @Debug = 1 print @sqlCMD

		SELECT * FROM #Instance
	END

END;
GO


