DECLARE @sqlcmd         VARCHAR(max),
        @DatabaseName   VARCHAR(100) ='DYNAMICS',
        @Date           DATETIME2 = CURRENT_TIMESTAMP,
        @path           NVARCHAR(100) = '\\dbbktstawstgy01.as.local\alss3sqlstst01\GP-SQLTST-01$I02\PROD\GP-SQLPRD-01$I02_',
		@filename NVARCHAR(100) ='_FULL_20221027_000003',
        @type           NVARCHAR(50) ='FULL',
        @DataDrive      NVARCHAR(50) ='F:\I02\SQLData\',
        @LogDrive       NVARCHAR(50) ='G:\I02\SQLLogs\',
        @Recovery       NVARCHAR(50) ='RECOVERY',--RECOVERY, NORECOVERY (typically for AG purposes)
        @logicalenabled NVARCHAR(1) ='N',--If you're database name has a different logical name other than the database name itself
        @logicalname    NVARCHAR(50)='GPSDYNAMICSDat.mdf',
        @logicallogname NVARCHAR(50)='GPSDYNAMICSLog.ldf',
        @DryRun         INT = 0

			   		 	  	  	   		 	  
--\\dbbktstawstgy01.as.local\alss3sqlstst01\GP-SQLTST-01$I02\PROD\GP-SQLPRD-01$I02_DYNAMICS_FULL_20221027_000003_8.bak
--'\\dbbktstawstgy01.as.local\alss3sqlstst01\GP-SQLTST-01$I02\PROD\GP-SQLPRD-01$I02_DYNAMICS_FULL_20221027_00003_8.bak'

SELECT @sqlcmd = '
  RESTORE DATABASE [' + @DatabaseName
                       + '] FROM
DISK = ''' + @path + '' + @DatabaseName+@filename+'_1.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + @filename +'_2.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + @filename+'_3.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + @filename +'_4.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + @filename+'_5.bak'',
DISK = '''
                       + @path + '' + @DatabaseName+@filename +'_6.bak'',
DISK = '''
                       + @path + '' + @DatabaseName +@filename +'_7.bak'',
DISK = '''
                       + @path + '' + @DatabaseName +@filename +'_8.bak''
WITH REPLACE, MOVE  N''' + @logicalname
                       + ''' TO N''' + @DataDrive 
                       + @logicalname + ''',
				   MOVE  N'''
                       + @logicallogname + ''' TO N''' + @LogDrive
                        + @logicallogname + ''',
				    '
                       + @Recovery + ', NOUNLOAD, STATS = 5'
  

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
