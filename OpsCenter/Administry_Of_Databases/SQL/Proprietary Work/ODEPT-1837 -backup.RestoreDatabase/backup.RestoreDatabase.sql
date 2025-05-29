USE [DBA]

GO

/****** Object:  StoredProcedure [backup].[RestoreDatabase]    Script Date: 3/25/2024 11:03:58 AM ******/
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[backup].[RestoreDatabase]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [backup].[RestoreDatabase] AS RETURN 0;';
  END;

GO

ALTER PROCEDURE [backup].[RestoreDatabase] @ClientHost            VARCHAR (50) = NULL,-- -c Client/Host SQL Server Backup Source
                                           @RecoveryState         VARCHAR (10) = "normal",-- -S Recovery State <normal,norecover,standby>
                                           @BackupSoftware        VARCHAR (100) = NULL,
                                           @DDHost                VARCHAR (50) = NULL,-- -a NSR_DFA_SI_DD_HOST - Data Domain Host Name
                                           @DDBoostUser           VARCHAR (50) = NULL,-- -a NSR_DFA_SI_DD_USER - DD Boost User
                                           @DDStorageUnit         VARCHAR (50) = NULL,-- -a NSR_DFA_SI_DEVICE_PATH - Storage Unit Name
                                           @SQLDatabaseName       VARCHAR (100),-- SQL Database Name
                                           @RestoreDatabaseName   NVARCHAR(128)= NULL,
                                           @SQLInstanceName       VARCHAR (50) = NULL,-- SQL INstance Name - Defaults to MSSQL
                                           @DDLockBoxPath         VARCHAR (100) = NULL,--
                                           @StandbyFile           VARCHAR (255) = NULL,-- File path of standby file for standby recovery option
                                           @BackupTimeStamp       VARCHAR (50) = NULL,-- -t Last Backup Time Stamp
                                           @Overwrite             BIT = 0,-- -f Overwrites the existing database with the current database that you restore,if the names of both the databases are same.
                                           @CCheck                BIT = NULL,-- -j Performs a database consistency check between the SQL Server backed up data and the SQL Server restored data.
                                           @CreateChecksum        BIT = NULL,-- -k Performs checksum before restoring the data from the device.
                                           @ContinueOnChecksumErr BIT = NULL,-- -u Performs checksum and continues the operation even in case of errors.
                                           @Relocate              BIT = NULL,-- -C Relocates the database files (.mdf and .ldf) to a different folder.
                                           @DataPath              VARCHAR(255) = NULL,-- Path to relocate SQL .mdf data file 'Contacts'='C:\AW_DB\Contacts.mdf'
                                           @DiffPath              VARCHAR(255) = NULL,-- Path to relocate SQL .ldf log file  'Contacts_log'='C:\AW_DB\Contacts_log.ldf'"
                                           @LogPath               VARCHAR(255) = NULL,-- Path to relocate SQL .ldf log file  'Contacts_log'='C:\AW_DB\Contacts_log.ldf'"
                                           @Quiet                 BIT = NULL,-- -q Displays ddbmsqlrc messages in the quiet mode, that is, the option provides minimal information about the progress of the restore operation including error messages.
                                           @DebugLevel            CHAR(1) = NULL,-- -D Generates detailed logs that you can use to troubleshoot the backup issues. <0-9>
                                           @BackupLevel           VARCHAR (50) = 'FULL',
                                           @ForceSimpleRecovery   BIT = NULL,
										   @ExecCommand   VARCHAR(255)=null,
                                           @ProcedureName NVARCHAR(128)=null,

                                           -- The following options of the ddbmsqlrc.exe command have not been implemented
                                           --@BackupLevel				varchar (10)	= NULL					-- THIS MAY BE A TYPO IN THE MANUAL -- GUI DOES NOT SEEM CREATE THIS OPTION --if @BackupLevel is not null Set @ddbmacmd = @ddbmacmd + ' -l "' + @BackupLevel + '"'  INVALID RESTORE OPTION ??
                                           --@TailLog					bit				= NULL,					-- -H Performs a tail-log backup of the database and leave it in the restoring state. IN GUI BUT NOT DOCUMENTED FOR COMMAND LINE
                                           --@VirtualServer			varchar (50)  	= NULL					-- -A Note: This appears to be intended for use with virtual cluster nodes, but is not documented well in the administration guide
                                           @Bucket                NVARCHAR(100) = NULL,
                                           @DryRun                BIT = 1,
                                           @Force                 BIT = 1,
                                           @Verbose               BIT = 1
AS
  BEGIN
    /*
    ######################################################################
		Examples
    ######################################################################

		EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'Test', @Verbose = 0, @Force= 0  ---Test backup and drops the database
		EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'Test', @RestoreDatabaseName ='NotDBA'  , @Verbose = 0, @Force= 0  ---Test backup and drops the database
		EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'DBA', @RestoreDatabaseName ='NotDBA' ---words only
		EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'DBA' ---words only
		EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'Test' , @DryRun =0 
		EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'Test', @RestoreDatabaseName ='NotDBA'  , @DryRun =0 
    */
    IF( @DryRun = 0 ) SET NOCOUNT ON;

    /*
    ######################################################################
		Declarations
    ######################################################################
    */
	DECLARE @ddbmacmd NVARCHAR(4000);
	DECLARE @cur CURSOR;
	DECLARE @line NVARCHAR(4000);
	DECLARE @rcode BIT;
	DECLARE @dbname NVARCHAR(100);
	DECLARE @t TABLE
    (
        DBNAME NVARCHAR(100)
    );

	SELECT @ProcedureName = Quotename(Db_name()) + '.'
                        + Quotename(Object_schema_name(@@PROCID, Db_id()))
                        + '.'
                        + Quotename(Object_name(@@PROCID, Db_id()))

  IF( @Bucket IS NULL )
	BEGIN
        SELECT @Bucket = LEFT(Replace([confvalue], '\\', ''), 15)
        FROM   [DBA].[info].[databaseConfig]
        WHERE  [confkey] = 'StorageGatewayPath'
	END

    IF( @RestoreDatabaseName IS NULL ) SET @RestoreDatabaseName = @SQLDatabaseName;
    IF( @DDHost IS NULL ) SELECT @DDHost = Upper(info.Getdatabaseconfig('DataDomain', 'Host', ''));
    IF( @DDBoostUser IS NULL ) SELECT @DDBoostUser = info.Getdatabaseconfig('DataDomain', 'User', '');
    --IF( @BackupSetName is null ) SELECT @BackupSetName = UPPER(info.GetDatabaseConfig('DataDomain','SetName', ''));
    IF( @DDStorageUnit IS NULL ) SELECT @DDStorageUnit = Upper(info.Getdatabaseconfig('DataDomain', 'DevicePath', ''));
    IF( @DDLockBoxPath IS NULL ) SELECT @DDLockBoxPath = info.Getdatabaseconfig('DataDomain', 'LockBoxPath', '');
    --IF( @BackupSetDescription is null ) SET @BackupSetDescription = @BackupLevel +' Backup'
    IF( @ClientHost IS NULL ) SET @ClientHost =  (SELECT TOP 1 
            CASE 
                WHEN InstanceName <> 'MSSQLSERVER' THEN REPLACE(@@SERVERNAME, '\', '$')
                ELSE SQLServerName
            END
        FROM DBA.INFO.Instance
        ORDER BY HARVESTDATE DESC)
	IF @ClientHost IS NOT NULL SET @ClientHost = CASE WHEN @ClientHost like '%\%' THEN REPLACE(@ClientHost, '\', '$') ELSE @ClientHost END 
    IF( @SQLInstanceName IS NULL ) SET @SQLInstanceName = (SELECT Isnull('MSSQL$'+ CONVERT(VARCHAR(max), Serverproperty('instancename')), 'MSSQL'));
    IF( @BackupSoftware IS NULL ) SET @BackupSoftware = info.Getdatabaseconfig('Backup', 'Software', '');
    IF ( @ForceSimpleRecovery IS NULL )
	BEGIN
        SELECT @ForceSimpleRecovery = CASE
                                        WHEN recovery_model_desc = 'SIMPLE' THEN '1'
                                        ELSE '0'
                                      END
        --select recovery_model_desc
        FROM   sys.databases
        WHERE  name = 'model'
	END

      -- Check required parameters
    IF( @ClientHost IS NULL ) RAISERROR('Null values not allowed for ClientHost',16,1);
    IF( @RecoveryState IS NULL ) RAISERROR('Null values not allowed for RestoreType',16,1);
    IF( @DDHost IS NULL ) RAISERROR('Null values not allowed for DDHost',16,1);
    IF( @DDBoostUser IS NULL ) RAISERROR('Null values not allowed for DDBoostUser',16,1);
    IF( @DDStorageUnit IS NULL ) RAISERROR('Null values not allowed for DDStorageUnit',16,1);
    IF( @SQLInstanceName IS NULL ) RAISERROR('Null values not allowed for SQLInstanceName',16,1);
    IF( @SQLDatabaseName IS NULL ) RAISERROR('Null values not allowed for SQLDatabaseName',16,1);

	IF( @DataPath IS NULL )
	BEGIN
        SELECT @DataPath = [confvalue] +'\'+ CASE 
    WHEN @ClientHost IS NOT NULL THEN @ClientHost
    ELSE 
        (SELECT TOP 1 
            CASE 
                WHEN InstanceName <> 'MSSQLSERVER' THEN REPLACE(@@SERVERNAME, '\', '$')
                ELSE SQLServerName
            END
        FROM DBA.INFO.Instance
        ORDER BY HARVESTDATE DESC)
END +'\'+ @SQLDatabaseName +'\FULL\'
		FROM   [DBA].[info].[databaseConfig]
        WHERE  [confkey] = 'StorageGatewayPath'
	END

    IF( @DiffPath IS NULL )
	BEGIN
        SELECT @DiffPath = [confvalue] +'\'+ CASE 
    WHEN @ClientHost IS NOT NULL THEN @ClientHost
    ELSE 
        (SELECT TOP 1 
            CASE 
                WHEN InstanceName <> 'MSSQLSERVER' THEN REPLACE(@@SERVERNAME, '\', '$')
                ELSE SQLServerName
            END
        FROM DBA.INFO.Instance
        ORDER BY HARVESTDATE DESC)
END +'\'+ @SQLDatabaseName +'\DIFF\'
        FROM   [DBA].[info].[databaseConfig]
        WHERE  [confkey] = 'StorageGatewayPath'
	END

    IF( @LogPath IS NULL )
	BEGIN
        SELECT @LogPath = [confvalue] +'\'+ CASE 
    WHEN @ClientHost IS NOT NULL THEN @ClientHost
    ELSE 
        (SELECT TOP 1 
            CASE 
                WHEN InstanceName <> 'MSSQLSERVER' THEN REPLACE(@@SERVERNAME, '\', '$')
                ELSE SQLServerName
            END
        FROM DBA.INFO.Instance
        ORDER BY HARVESTDATE DESC)
END +'\'+ @SQLDatabaseName +'\LOG\'
        FROM   [DBA].[info].[databaseConfig]
        WHERE  [confkey] = 'StorageGatewayPath'
	END



    /*
    ######################################################################
		Populate Database list
    ######################################################################
    */
	IF EXISTS (SELECT DatabaseName FROM   [DBA].[backup].[Schedule] WHERE  ( DatabaseName = @SQLDatabaseName ) )
BEGIN

    INSERT INTO @t
    SELECT DatabaseName -- SELECT * 
    FROM   [DBA].[backup].[Schedule]
    WHERE  ( BackupMethod = @DDBoostUser
            OR DatabaseName = @SQLDatabaseName ) --OR @Force = 1 )
    ORDER  BY DatabaseName
END
ELSE 
BEGIN
INSERT INTO @t
SELECT @SQLDatabaseName
END 

    SET @cur = CURSOR
    FOR SELECT DBNAME
        FROM   @t

    OPEN @cur

    FETCH next FROM @cur INTO @dbname

      WHILE @@FETCH_STATUS = 0
        BEGIN
            /* Get info on DB or return empty resultset. */
            IF( @BackupLevel = 'FULL' ) -- someday this can check for point in time
              BEGIN
                  IF( @BackupSoftware = 'ddboost' ) -- someday this can check for point in time
                    BEGIN
                        /* This section will need to be updated for other restore types */
                        SELECT @SQLDatabaseName = DatabaseName,
                               @BackupTimeStamp = CONVERT(VARCHAR, BackupDate, 22)
                        --select *
                        FROM   DBA.ddbma.SQLCatalog
                        WHERE  databaseName = @dbname
                               AND BAckupLEvel = @BackupLevel
                               AND BAckupDate = (SELECT Max(BackupDate)
                                                 FROM   DBA.ddbma.SQLCatalog
                                                 WHERE  databaseName = @dbname
                                                        AND BAckupLEvel = @BackupLevel)

                        PRINT '--------------------------------------------------------------'

                        PRINT 'Restoring ' + @BackupLevel + ': ' + @dbname + ' '
                              + @BackupTimeStamp

                        PRINT 'Old DB Name: ' + @dbname

                        PRINT 'New DB Name: '
                              + Upper(@RestoreDatabaseName)

                        PRINT '--------------------------------------------------------------'
                    END
                  ELSE
                    BEGIN
                        IF @BackupLevel = 'FULL'
                          BEGIN
                              SELECT @BackupTimeStamp = CONVERT(VARCHAR, Max(msdb.dbo.backupset.backup_finish_date), 22)
                              FROM   msdb.dbo.backupmediafamily
                                     INNER JOIN msdb.dbo.backupset
                                             ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
                              WHERE  msdb..backupset.type = 'D'
                                     AND msdb.dbo.backupset.database_name = @SQLDatabaseName
                              GROUP  BY msdb.dbo.backupset.database_name,
                                        msdb.dbo.backupset.type,
                                        msdb.dbo.backupmediafamily.physical_device_name,
                                        LEFT(Substring(physical_device_name, Len(physical_device_name) - Charindex('\', Reverse(physical_device_name)) + 2, Len(physical_device_name)), Len(physical_device_name) - Charindex('.', Reverse(physical_device_name)) + 1)
                          END
                        ELSE IF @BackupLevel = 'LOG'
                          BEGIN
                              SELECT @BackupTimeStamp = CONVERT(VARCHAR, Max(msdb.dbo.backupset.backup_finish_date), 22)
                              --select  top 5*
                              FROM   msdb.dbo.backupmediafamily
                                     INNER JOIN msdb.dbo.backupset
                                             ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
                              WHERE  msdb..backupset.type = 'L'
                                     AND msdb.dbo.backupset.database_name = @SQLDatabaseName
                              GROUP  BY msdb.dbo.backupset.database_name,
                                        msdb.dbo.backupset.type,
                                        msdb.dbo.backupmediafamily.physical_device_name,
                                        LEFT(Substring(physical_device_name, Len(physical_device_name) - Charindex('\', Reverse(physical_device_name)) + 2, Len(physical_device_name)), Len(physical_device_name) - Charindex('.', Reverse(physical_device_name)) + 1)
                          END
                        ELSE
                          BEGIN
                              SELECT @BackupTimeStamp = CONVERT(VARCHAR, Max(msdb.dbo.backupset.backup_finish_date), 22)
                              --select  top 5*
                              FROM   msdb.dbo.backupmediafamily
                                     INNER JOIN msdb.dbo.backupset
                                             ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
                              WHERE  msdb..backupset.type = 'I'
                                     AND msdb.dbo.backupset.database_name = @SQLDatabaseName
                              GROUP  BY msdb.dbo.backupset.database_name,
                                        msdb.dbo.backupset.type,
                                        msdb.dbo.backupmediafamily.physical_device_name,
                                        LEFT(Substring(physical_device_name, Len(physical_device_name) - Charindex('\', Reverse(physical_device_name)) + 2, Len(physical_device_name)), Len(physical_device_name) - Charindex('.', Reverse(physical_device_name)) + 1)
                          END
                     PRINT '--------------------------------------------------------------'

                        PRINT 'Restoring ' + @BackupLevel + ': ' + @dbname + ' '
                              + @BackupTimeStamp

                        PRINT 'Old DB Name: ' + @dbname

                        PRINT 'New DB Name: '
                              + Upper(@RestoreDatabaseName)

                        PRINT '--------------------------------------------------------------'
                    END
              END

   
            IF( @Relocate = 1 )
              BEGIN
                  /* This should probably be a temp table to process all files of type and concatenate them */
                  SELECT @DataPath = '"''''' + NAME + '''''=''' + '''' + @DataPath
                                     + RIGHT(fileName, Charindex('\', Reverse(fileName))-1)
                                     + ''''''
                  FROM   SYSALTFILES
                  WHERE  Db_name(dbid) = @dbname
                         AND groupid = 1

                  SELECT @LogPath = ', ''''' + NAME + '''''=''' + '''' + @LogPath
                                    + RIGHT(fileName, Charindex('\', Reverse(fileName))-1)
                                    + '''''"'
                  FROM   SYSALTFILES
                  WHERE  Db_name(dbid) = @dbname
                         AND groupid = 0
              END

            IF ( @Verbose = 0
                 AND @DryRun = 1 )
              BEGIN
                  EXEC ola.Sp_databaserestore
                    @Database = @dbname,
                    @RestoreDatabaseName = @RestoreDatabaseName,
                    @BackupPathFull = @DataPath,
                    @BackupPathDiff = @DiffPath,
                    @BackupPathLog = @LogPath,
                    @MoveFiles = 1,
                    @RestoreDiff = 0,
                    @ContinueLogs = 0,
                    @RunRecovery = 1,
                    @TestRestore = 0,
                    @RunCheckDB = 1,
                    @Debug = 1,
                    @ForceSimpleRecovery= @ForceSimpleRecovery,
                    @Execute = 'Y'
              END

            IF ( @Force = 0
                 AND @Verbose = 0
                 AND @DryRun = 1 )
              BEGIN
                  EXEC ola.Sp_databaserestore
                    @Database = @dbname,
                    @BackupPathFull = @DataPath,
                    @BackupPathDiff = @DiffPath,
                    @BackupPathLog = @LogPath,
                    @MoveFiles = 1,
                    @RestoreDiff = 0,
                    @ContinueLogs = 0,
                    @RunRecovery = 1,
                    @TestRestore = 1,
                    @RunCheckDB = 1,
                    @Debug = 1,
                    @ForceSimpleRecovery= @ForceSimpleRecovery,
                    @Execute = 'Y'
              END

            -- CAll RestoreImage
            IF( @BackupSoftware = 'ddboost' )
              BEGIN
                  PRINT 'This tool has been retired and enjoying retirement'
              END
            ELSE IF( @BackupSoftware = 'SQLNative' )
              BEGIN
                  PRINT @BackupSoftware
                        + '- We do not do this here'
              END
            ELSE IF( @BackupSoftware = 'AWS-EC2' )
              BEGIN
                  IF( @DryRun = 1 )
                    BEGIN
                        IF @SQLDatabaseName <> @RestoreDatabaseName
                          BEGIN
                              PRINT '
							  EXEC ola.sp_DatabaseRestore
									@Database = ''' + @dbname + ''', 
									@RestoreDatabaseName = '''+ Upper(@RestoreDatabaseName) + ''', 
									@BackupPathFull = '''+ @DataPath  + ''',
									@BackupPathDiff = '''+ @DiffPath  + ''',
									@BackupPathLog = '''+ @LogPath  + ''',
									@ForceSimpleRecovery= '''+ Cast(@ForceSimpleRecovery AS NVARCHAR(1)) + ''',
									@MoveFiles = 1,
									@RestoreDiff = 0,
									@ContinueLogs = 0,
									@RunRecovery = 1,
									@TestRestore = 0,
									@RunCheckDB = 1,
									@Debug = 1,
									@Execute = ''Y'';'

                              PRINT ( 'ALTER DATABASE [' + @RestoreDatabaseName
                                      + ']  MODIFY FILE ( NAME = ''' + @DBName
                                      + ''', NEWNAME = ''' + @RestoreDatabaseName
                                      + ''' );' )

                              PRINT ( 'ALTER DATABASE [' + @RestoreDatabaseName
                                      + ']  MODIFY FILE ( NAME = ''' + @DBName
                                      + '_log'', NEWNAME = '''
                                      + @RestoreDatabaseName + '_log'' );' )

                              PRINT ( 'ALTER AUTHORIZATION ON DATABASE:: ['
                                      + @RestoreDatabaseName + '] TO [SA]' )
                          END
                        ELSE
                          BEGIN
                              PRINT '
							  EXEC ola.sp_DatabaseRestore
									@Database = ''' + @dbname   + ''', 
									@RestoreDatabaseName = '''+ Upper(@RestoreDatabaseName)  + ''', 
									@BackupPathFull = ''' + @DataPath  + ''',
									@BackupPathDiff =''' + @DiffPath + ''', ,
									@BackupPathLog = ''' + @LogPath  + ''',
									@ForceSimpleRecovery= '''+ Cast(@ForceSimpleRecovery AS NVARCHAR(1)) + ''',
									@MoveFiles = 1,
									@RestoreDiff = 0,
									@ContinueLogs = 0,
									@RunRecovery = 1,
									@TestRestore = 0,
									@RunCheckDB = 1,
									@Debug = 1,
									@Execute = ''Y'';'

                              PRINT ( 'ALTER AUTHORIZATION ON DATABASE:: ['
                                      + @RestoreDatabaseName + '] TO [SA]' )
                          END
                    ----spit out file path for backup 
                    END
                  ELSE
                    BEGIN
                        IF @RestoreDatabaseName <> @SQLDatabaseName
                          BEGIN
                              EXEC ola.Sp_databaserestore
                                @Database = @dbname,
                                @RestoreDatabaseName = @RestoreDatabaseName,
                                @BackupPathFull = @DataPath,
                                @BackupPathDiff = @DiffPath,
                                @BackupPathLog = @LogPath,
                                @MoveFiles = 1,
                                @RestoreDiff = 0,
                                @ContinueLogs = 0,
                                @RunRecovery = 1,
                                @TestRestore = 0,
                                @RunCheckDB = 1,
                                @Debug = 1,
                                @ForceSimpleRecovery= @ForceSimpleRecovery,
                                @Execute = 'Y'

                              EXEC ('ALTER DATABASE ['+ @RestoreDatabaseName +']  MODIFY FILE ( NAME = '''+@DBName+''', NEWNAME = '''+@RestoreDatabaseName+''' );')

                              EXEC ('ALTER DATABASE ['+ @RestoreDatabaseName +']  MODIFY FILE ( NAME = '''+@DBName+'_log'', NEWNAME = '''+@RestoreDatabaseName+'_log'' );')

                              EXEC ( 'ALTER AUTHORIZATION ON DATABASE:: ['+ @RestoreDatabaseName + '] TO [SA]')
                          END
                        ELSE
                          BEGIN
                              EXEC ola.Sp_databaserestore
                                @Database = @dbname,
                                @RestoreDatabaseName = @RestoreDatabaseName,
                                @BackupPathFull = @DataPath,
                                @BackupPathDiff = @DiffPath,
                                @BackupPathLog = @LogPath,
                                @MoveFiles = 1,
                                @RestoreDiff = 0,
                                @ContinueLogs = 0,
                                @RunRecovery = 1,
                                @TestRestore = 0,
                                @RunCheckDB = 1,
                                @Debug = 1,
                                @Execute = 'Y'

                              EXEC ( 'ALTER AUTHORIZATION ON DATABASE:: ['+ @RestoreDatabaseName + '] TO [SA]')
                          END
                    END
              END
            ELSE IF( @BackupSoftware = 'AWS-RDS' )
              BEGIN
                  IF( @DryRun = 1 )
                    BEGIN
                        PRINT 'exec msdb.dbo.rds_restore_database
								@restore_db_name=''' + @dbname
                              + ''',@s3_arn_to_restore_from=''arn:aws:s3:::'
                              + @Bucket + '/' + @dbname + '_migration_full.bak'',
								@type='''
                              + @BackupLevel + '''@with_norecovery=0'
                    END
                  ELSE
                    BEGIN
                        PRINT @BackupSoftware + ' Can do not do this here... permissions prohibit it!
							  HERE IS THE CODE:
							  '

                        PRINT 'exec msdb.dbo.rds_restore_database
								@restore_db_name=''' + @dbname
                              + ''',@s3_arn_to_restore_from=''arn:aws:s3:::'
                              + @Bucket + '/' + @dbname + '_migration_full.bak'',
								@type='''
                              + @BackupLevel + '''@with_norecovery=0'
                    END
              END
            ELSE IF( @BackupSoftware = 'MS-AZURE' )
              BEGIN
                  PRINT @BackupSoftware
                        + '- We do not do this here'
              END
            ELSE IF( @BackupSoftware = 'Clumio' )
              BEGIN
                  PRINT @BackupSoftware
                        + '- We do not do this here'
              END
            ELSE
              BEGIN
                  PRINT 'Backup Software undefined'

                  RAISERROR('Backup Software undefined',16,1)
              END

            FETCH next FROM @cur INTO @dbname
        END

      CLOSE @cur;

      DEALLOCATE @cur;


     
    SET @ExecCommand = 'EXEC '+ @ProcedureName + ' @ClientHost = '''+ @ClientHost  + ''', @BackupSoftware = '''+ @BackupSoftware  +''', @SQLDatabaseName = '''+ @SQLDatabaseName+''', @RestoreDatabaseName = '''+ @RestoreDatabaseName +''', @Dryrun = '''+ CONVERT(CHAR(1), @DryRun)+''', @Verbose = '''+ CONVERT(CHAR(1), @Verbose)+''',   @Force = '''+ CONVERT(CHAR(1), @Force) +''';'

 /*
    ######################################################################
					    Record entry - no error handling
    ######################################################################
    */

DECLARE @ServerENV VARCHAR(1000), @ServerName VARCHAR(1000)
    IF( @DryRun = 1 )
        BEGIN
            /* Record zero execution - result zero is "unknown" */
            INSERT INTO [deploy].[ExecHistory]
                ( [TimeStampUTC], [UserName], [Command], [ErrorMessage], [Result] )
            VALUES
                ( Getdate(), Original_login(), @ExecCommand, 'No error handling - DryRun', 0 )
        END
    ELSE
        BEGIN
            /* Record zero execution - result one is success */
            INSERT INTO [deploy].[ExecHistory]
                ( [TimeStampUTC], [UserName], [Command], [ErrorMessage], [Result] )
            VALUES
                ( Getdate(), Original_login(), @ExecCommand, 'No error handling', 1 )
        END

    SELECT  @ServerName = @@SERVERNAME,
		    @ServerENV = CASE WHEN @@SERVERNAME LIKE '%-DEVTEST%' THEN 'DEV'
						      WHEN @@SERVERNAME LIKE '%-PREPROD%' THEN 'TEST'
						      WHEN @@SERVERNAME LIKE '%-PROD%' THEN 'PROD'
						      ELSE ( SELECT confValue FROM dba.info.Systemconfig WHERE confkey = 'Server.Environment' )
					     END



  END; 
