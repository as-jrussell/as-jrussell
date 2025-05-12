DECLARE @sqlcmd VARCHAR(max)
DECLARE @Location NVARCHAR(25) = '' --ON-PREM, EC2, RDS
DECLARE @Application NVARCHAR(100) = ''
DECLARE @DBName NVARCHAR(50) = 'iqq_live'
DECLARE @ServerEnvironment VARCHAR(10) = '' ---DEV, TST, STG,ADMIN, PRD
DECLARE @Machine NVARCHAR(100) = '' --ServerName
DECLARE @SQLServername VARCHAR(100) ='' --SQL Instance Name
DECLARE @DB INT = 1 --- 1 is enabled to give exact name of @DBNAME else will give the all the names that have @DBNAME and names that are like it
DECLARE @DryRun INT = 0

IF @SQLServername <> ''
  BEGIN
      SELECT @sqlcmd = 'SELECT DISTINCT ApplicationName, SQLServerName,[IP Address] = [Local_Net_Address] ,
				   DatabaseName,   
				   CASE ServerEnvironment
					 --WHEN ''ADMIN'' THEN ''Admin Envrionment''
					 WHEN ''PRD'' THEN ''Production Envrionment''
					 WHEN ''QA'' THEN ''QA Envrionment - Non Prod''
					 WHEN ''STG'' THEN ''Staging Envrionment - Non Prod''
					 WHEN ''TMP'' THEN ''Temporary Envrionment - Non Prod''
					 WHEN ''TST'' THEN ''Test Envrionment - Non Prod''
					 WHEN ''DEV'' THEN  ''Development Environment - Non Prod''
					 ELSE ''WARNING: No Environment!''
				   END [Environment],ServerLocation,  ProductName,CASE ServerLocation
				   WHEN ''AWS-RDS'' THEN CONCAT(SQLServerName, ''.aws.local'') 
				   ELSE CASE  WHEN ServerEnvironment != ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLTST-01\I02'',
					''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN CONCAT(machinename,''.'',DOMAINNAME)
				   WHEN ServerEnvironment = ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN  CONCAT(machinename,''.'',DOMAINNAME)
					WHEN SQLServerName  IN (
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLPRD-01\I01'', ''DBA-SQLQA-01\I01'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'', ''WWW-DB-01\WWWSITECOREPROD'') THEN CONCAT(machinename,''.'',DOMAINNAME ,''\'',InstanceName )
				   ELSE SQLServerName
				   END
				   END
				   	
			--select top 1 * 
	FROM   [InventoryDWH].[inv].[Instance] I
				   JOIN [InventoryDWH].[inv].[Database] D
					 ON I.ID = D.InstanceID
					 JOIN [InventoryDWH].[inv].AppDatabase  A on A.InstanceID = I.ID
					 JOIN [InventoryDWH].[inv].Application APP on APP.ApplicationID = A.ApplicationID
			WHERE (SQLServerName = '''
                       + @SQLServername + '''
			OR MACHINENAME = '''
                       + @SQLServername + ''')
			 AND ServerStatus <> ''DOWN''
			 	   AND DatabaseName='''
                       + @DBName
                       + ''' 
			 AND State = ''ONLINE''
			
			 '

      IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END
ELSE IF @DB = 1
  BEGIN
      SELECT @sqlcmd = '			SELECT DISTINCT   SQLServerName, [IP Address] =[Local_Net_Address],
				   DatabaseName,  
				   CASE ServerEnvironment
					 WHEN ''ADMIN'' THEN ''Admin Envrionment''
					 WHEN ''PRD'' THEN ''Production Envrionment''
					 WHEN ''QA'' THEN ''QA Envrionment - Non Prod''
					 WHEN ''STG'' THEN ''Staging Envrionment - Non Prod''
					 WHEN ''TMP'' THEN ''Temporary Envrionment - Non Prod''
					 WHEN ''TST'' THEN ''Test Envrionment - Non Prod''
					 ELSE ''Development Environment - Non Prod''
				   END [Environment],ServerLocation,  ProductName,CASE ServerLocation
				   WHEN ''AWS-RDS'' THEN CONCAT(SQLServerName,''.aws.local'') 
				   ELSE CASE  WHEN ServerEnvironment != ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLTST-01\I02'',
					''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN CONCAT(machinename,''.'',DOMAINNAME)
				   WHEN ServerEnvironment = ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN  CONCAT(machinename,''.'',DOMAINNAME)
					WHEN SQLServerName  IN (
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLPRD-01\I01'', ''DBA-SQLQA-01\I01'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'', ''WWW-DB-01\WWWSITECOREPROD'') THEN  CONCAT(machinename,''.'',DOMAINNAME ,''\'',InstanceName )
				   ELSE SQLServerName
				   END  
				   END [Connection String]
			
	FROM   [InventoryDWH].[inv].[Instance] I
				   JOIN [InventoryDWH].[inv].[Database] D
					 ON I.ID = D.InstanceID
					 JOIN [InventoryDWH].[inv].AppDatabase  A on A.InstanceID = I.ID
					 JOIN [InventoryDWH].[inv].Application APP on APP.ApplicationID = A.ApplicationID
			WHERE  ServerLocation  like ''%'
                       + @Location
                       + '%'' 
				   AND SQLServerName like ''%'
                       + @Machine + '%'' 
				   AND DatabaseName='''
                       + @DBName
                       + ''' 
				   AND ServerEnvironment like ''%'
                       + @ServerEnvironment
                       + '%'' 
				   AND ServerStatus <> ''DOWN''
				   AND State = ''ONLINE''
				    ORDER BY [Connection String] ASC, DatabaseName DESC'

      IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END
ELSE IF @Application <> ''
  BEGIN
      SELECT @sqlcmd = 'SELECT DISTINCT  ApplicationName, SQLServerName, [IP Address] =[Local_Net_Address],
				   DatabaseName,  
				   CASE ServerEnvironment
					 WHEN ''ADMIN'' THEN ''Admin Envrionment''
					 WHEN ''PRD'' THEN ''Production Envrionment''
					 WHEN ''QA'' THEN ''QA Envrionment - Non Prod''
					 WHEN ''STG'' THEN ''Staging Envrionment - Non Prod''
					 WHEN ''TMP'' THEN ''Temporary Envrionment - Non Prod''
					 WHEN ''TST'' THEN ''Test Envrionment - Non Prod''
					 ELSE ''Development Environment - Non Prod''
				   END [Environment],ServerLocation, ProductName, CASE ServerLocation
				   WHEN ''AWS-RDS'' THEN CONCAT(SQLServerName,''.aws.local'') 
				   ELSE CASE  WHEN ServerEnvironment != ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLTST-01\I02'',
					''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN CONCAT(machinename,''.'',DOMAINNAME)
				   WHEN ServerEnvironment = ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN  CONCAT(machinename,''.'',DOMAINNAME)
					WHEN SQLServerName  IN (
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLPRD-01\I01'', ''DBA-SQLQA-01\I01'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'', ''WWW-DB-01\WWWSITECOREPROD'') THEN  CONCAT(machinename,''.'',DOMAINNAME ,''\'',InstanceName )
				   ELSE SQLServerName
				   END  
				   END [Connection String]


	FROM   [InventoryDWH].[inv].[Instance] I
				   JOIN [InventoryDWH].[inv].[Database] D
					 ON I.ID = D.InstanceID
					 JOIN [InventoryDWH].[inv].AppDatabase  A on A.InstanceID = I.ID
					 JOIN [InventoryDWH].[inv].Application APP on APP.ApplicationID = A.ApplicationID
			WHERE  ServerLocation  like ''%'
                       + @Location
                       + '%'' 
				   AND SQLServerName like ''%'
                       + @Machine
                       + '%'' 
				   AND DatabaseName like ''%' + @DBName
                       + '%'' 
				   AND ServerEnvironment like ''%'
                       + @ServerEnvironment
                       + '%'' 
				   AND ServerStatus <> ''DOWN''
				   AND ApplicationName  like ''%'
                       + @Application
                       + '%'' 
				   AND State = ''ONLINE''
				   ORDER BY [Connection String] ASC, DatabaseName DESC '

      IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END
ELSE
  BEGIN
      SELECT @sqlcmd = '			SELECT DISTINCT  ApplicationName, SQLServerName, [IP Address] =[Local_Net_Address],
				   DatabaseName,  
				   CASE ServerEnvironment
					 WHEN ''ADMIN'' THEN ''Admin Envrionment''
					 WHEN ''PRD'' THEN ''Production Envrionment''
					 WHEN ''QA'' THEN ''QA Envrionment - Non Prod''
					 WHEN ''STG'' THEN ''Staging Envrionment - Non Prod''
					 WHEN ''TMP'' THEN ''Temporary Envrionment - Non Prod''
					 WHEN ''TST'' THEN ''Test Envrionment - Non Prod''
					 ELSE ''Development Environment - Non Prod''
				   END [Environment],ServerLocation,  ProductName,CASE ServerLocation
				   WHEN ''AWS-RDS'' THEN CONCAT(SQLServerName,''.aws.local'') 
				   ELSE CASE  WHEN ServerEnvironment != ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLTST-01\I02'',
					''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN CONCAT(machinename,''.'',DOMAINNAME)
				   WHEN ServerEnvironment = ''PRD'' AND SQLServerName Not IN (''WWW-DB-01\WWWSITECOREPROD'',
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLPRD-01\I01'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'') THEN  CONCAT(machinename,''.'',DOMAINNAME)
					WHEN SQLServerName  IN (
					''WWW-DBTEST-01\WWWSITECOREDEV'',''GP-SQLTST-01\I01'',''GP-SQLPRD-01\I02'',''GP-SQLPRD-01\I01'', ''DBA-SQLQA-01\I01'',
					''GP-SQLTST-01\I02'',''DBA-SQLPRD-01\I01'',''WWW-DBTEST-01\WWWSITECORETEST'', ''WWW-DB-01\WWWSITECOREPROD'') THEN  CONCAT(machinename,''.'',DOMAINNAME ,''\'',InstanceName )
				   ELSE SQLServerName
				   END  
				   END [Connection String]

	FROM   [InventoryDWH].[inv].[Instance] I
				   JOIN [InventoryDWH].[inv].[Database] D
					 ON I.ID = D.InstanceID
					 JOIN [InventoryDWH].[inv].AppDatabase  A on A.InstanceID = I.ID
					 JOIN [InventoryDWH].[inv].Application APP on APP.ApplicationID = A.ApplicationID
			WHERE  ServerLocation  like ''%'
                       + @Location
                       + '%'' 
				   AND SQLServerName like ''%'
                       + @Machine
                       + '%'' 
				   AND DatabaseName like ''%' + @DBName
                       + '%'' 
				   AND ServerEnvironment like ''%'
                       + @ServerEnvironment
                       + '%'' 
				   AND ServerStatus <> ''DOWN''
				   AND State = ''ONLINE''
				      ORDER BY [Connection String] ASC, DatabaseName DESC'

      IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END 


