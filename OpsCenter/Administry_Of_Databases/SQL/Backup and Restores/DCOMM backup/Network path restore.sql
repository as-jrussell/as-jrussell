DECLARE @sqlcmd         VARCHAR(max),
        @DatabaseName   VARCHAR(100) ='DBA',
        @Date           DATETIME2 = CURRENT_TIMESTAMP,
        @path           NVARCHAR(50) = '\\DBA-SQLQA-01\f$\Restores\jrussell\',
        @type           NVARCHAR(50) ='FULL',
        @DataDrive      NVARCHAR(50) ='F:\SQLData\',
        @LogDrive       NVARCHAR(50) ='G:\SQLLogs\',
        @Recovery       NVARCHAR(50) ='RECOVERY',--RECOVERY, NORECOVERY (typically for AG purposes)
       
	   @logicalenabled NVARCHAR(1) ='N',--If you're database name has a different logical name other than the database name itself
        @logicalname    NVARCHAR(50),--='GPSDYNAMICSDat.mdf',
        @logicallogname NVARCHAR(50),--='GPSDYNAMICSLog.ldf',
        @DryRun         INT = 1



IF @type = 'FULL'
   AND @DatabaseName IN ( 'Unitrac', 'UnitracArchive', 'KAFC_Data', 'UTL',
                          'IQQ_LIVE', 'IVOS' )
  BEGIN
      SELECT @sqlcmd = '
  RESTORE DATABASE [' + @DatabaseName
                       + '] FROM
DISK = ''' + @path + '' + @DatabaseName
                       + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23) + '_1.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23) + '_2.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23) + '_3.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23) + '_4.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23) + '_5.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23) + '_6.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23) + '_7.bak'',
DISK = '''
                       + @path + '' + @DatabaseName + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23)
                       + '_8.bak''

WITH INIT , NOUNLOAD , NAME = '''
                       + @DatabaseName + 'WITH MOVE  N'''
                       + @DatabaseName + ''' TO N''' + @DataDrive
                      + @DatabaseName
                       + '.mdf'',
				   MOVE  N''' + @DatabaseName
                       + '_log'' TO N''' + @LogDrive 
                       + @DatabaseName + '_log.ldf'',
				    ' + @Recovery
                       + ', NOUNLOAD, STATS = 5'
  END
ELSE IF @logicalenabled = 'Y'
  BEGIN

IF @logicalname IS NULL
  SET @logicalname = @DatabaseName

IF @logicallogname IS NULL
  SET @logicallogname = @DatabaseName

      SELECT @sqlcmd = '
  RESTORE DATABASE [' + @DatabaseName
                       + '] FROM
DISK = ''' + @path + '' + @DatabaseName
                       + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23)
                       + '_1.bak''
				   WITH MOVE  N''' + @logicalname
                       + ''' TO N''' + @DataDrive 
                       + @logicalname + ''',
				   MOVE  N'''
                       + @logicallogname + ''' TO N''' + @LogDrive
                        + @logicallogname + ''',
				    '
                       + @Recovery + ', NOUNLOAD, STATS = 5'
  END
ELSE
  BEGIN
      SELECT @sqlcmd = ' 
  RESTORE DATABASE [' + @DatabaseName
                       + '] FROM
DISK = ''' + @path + '' + @DatabaseName
                       + '_migration_full_'
                       + CONVERT(VARCHAR(23), @Date, 23)
                       + '_1.bak''
				   WITH MOVE  N''' + @DatabaseName
                       + ''' TO N''' + @DataDrive + 
                       + @DatabaseName + '.mdf'',
				   MOVE  N'''
                       + @DatabaseName + '_log'' TO N''' + @LogDrive
                       + @DatabaseName + '_log.ldf'',
				    '
                       + @Recovery + ', NOUNLOAD, STATS = 5'
  END


 IF @type = 'LOG'
  BEGIN
      SELECT @sqlcmd = '
RESTORE LOG [' + @DatabaseName
                       + ']
FROM DISK = ''' + @path + '' + @DatabaseName
                       + '_migration_log_'
                       + CONVERT(VARCHAR(23), @Date, 23)
                       + '.trn''  WITH ' + @Recovery + ', STATS = 5'
  END
 

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 
