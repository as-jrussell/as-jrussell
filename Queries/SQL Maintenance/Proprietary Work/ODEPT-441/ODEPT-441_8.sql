USE [DBA]

GO

/****** Object:  StoredProcedure [backup].[RestoreDatabase]    Script Date: 3/15/2024 10:08:42 AM ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

ALTER PROCEDURE [backup].[Restoredatabase] @ClientHost            VARCHAR (50) = NULL,-- -c Client/Host SQL Server Backup Source
                                           @RecoveryState         VARCHAR (10) = "normal",-- -S Recovery State <normal,norecover,standby>
                                           @BackupSoftware        VARCHAR (100) = NULL,
                                           @DDHost                VARCHAR (50) = NULL,-- -a NSR_DFA_SI_DD_HOST - Data Domain Host Name
                                           @DDBoostUser           VARCHAR (50) = NULL,-- -a NSR_DFA_SI_DD_USER - DD Boost User
                                           @DDStorageUnit         VARCHAR (50) = NULL,-- -a NSR_DFA_SI_DEVICE_PATH - Storage Unit Name
                                           @SQLDatabaseName       VARCHAR (100),-- SQL Database Name
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
                                           @LogPath               VARCHAR(255) = NULL,-- Path to relocate SQL .ldf log file  'Contacts_log'='C:\AW_DB\Contacts_log.ldf'"
                                           @Quiet                 BIT = NULL,-- -q Displays ddbmsqlrc messages in the quiet mode, that is, the option provides minimal information about the progress of the restore operation including error messages.
                                           @DebugLevel            CHAR(1) = NULL,-- -D Generates detailed logs that you can use to troubleshoot the backup issues. <0-9>
                                           @BackupLevel           VARCHAR (50) = 'FULL',
										  
                                           -- The following options of the ddbmsqlrc.exe command have not been implemented
                                           --@BackupLevel				varchar (10)	= NULL					-- THIS MAY BE A TYPO IN THE MANUAL -- GUI DOES NOT SEEM CREATE THIS OPTION --if @BackupLevel is not null Set @ddbmacmd = @ddbmacmd + ' -l "' + @BackupLevel + '"'  INVALID RESTORE OPTION ??
                                           --@TailLog					bit				= NULL,					-- -H Performs a tail-log backup of the database and leave it in the restoring state. IN GUI BUT NOT DOCUMENTED FOR COMMAND LINE
                                           --@VirtualServer			varchar (50)  	= NULL					-- -A Note: This appears to be intended for use with virtual cluster nodes, but is not documented well in the administration guide
                                           @DryRun                BIT = 1
AS
  BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET NOCOUNT ON;

      -- EXEC [backup].[RestoreDatabase] @SQLDatabaseName = 'dba'
      -- EXEC [backup].[RestoreDatabase] @SQLDatabaseName = 'USER_Databases', @relocate = 1, @DataPath = 'F:\SQLData\I01', @LogPath = 'G:\SQLLogs\I01'
      -- EXEC [backup].[RestoreDatabase] @SQLDatabaseName = 'System_Databases', @Dryrun= 1
      -- Set Default values 
	  DECLARE @Bucket nvarchar(100) 
	SELECT @Bucket = LEFT(REPLACE([confvalue],'\\',''),15)
  FROM [DBA].[info].[databaseConfig]
  WHERE [confkey]= 'StorageGatewayPath'
      IF( @DDHost IS NULL )
        SELECT @DDHost = Upper(info.Getdatabaseconfig('DataDomain', 'Host', ''));

      IF( @DDBoostUser IS NULL )
        SELECT @DDBoostUser = info.Getdatabaseconfig('DataDomain', 'User', '');

      --IF( @BackupSetName is null ) SELECT @BackupSetName = UPPER(info.GetDatabaseConfig('DataDomain','SetName', ''));
      IF( @DDStorageUnit IS NULL )
        SELECT @DDStorageUnit = Upper(info.Getdatabaseconfig('DataDomain', 'DevicePath', ''));

      IF( @DDLockBoxPath IS NULL )
        SELECT @DDLockBoxPath = info.Getdatabaseconfig('DataDomain', 'LockBoxPath', '');

      --IF( @BackupSetDescription is null ) SET @BackupSetDescription = @BackupLevel +' Backup'
      IF( @ClientHost IS NULL )
        SET @ClientHost = (SELECT Upper(CONVERT(VARCHAR(100), Serverproperty('MachineName'))))

      IF( @SQLInstanceName IS NULL )
        SET @SQLInstanceName = (SELECT Isnull('MSSQL$'
                                              + CONVERT(VARCHAR(max), Serverproperty('instancename')), 'MSSQL'))

      IF( @BackupSoftware IS NULL )
        SET @BackupSoftware = info.Getdatabaseconfig('Backup', 'Software', '');

      -- Check required parameters
      IF @ClientHost IS NULL
        RAISERROR('Null values not allowed for ClientHost',16,1)

      IF @RecoveryState IS NULL
        RAISERROR('Null values not allowed for RestoreType',16,1)

      IF @DDHost IS NULL
        RAISERROR('Null values not allowed for DDHost',16,1)

      IF @DDBoostUser IS NULL
        RAISERROR('Null values not allowed for DDBoostUser',16,1)

      IF @DDStorageUnit IS NULL
        RAISERROR('Null values not allowed for DDStorageUnit',16,1)

      IF @SQLInstanceName IS NULL
        RAISERROR('Null values not allowed for SQLInstanceName',16,1)

      IF @SQLDatabaseName IS NULL
        RAISERROR('Null values not allowed for SQLDatabaseName',16,1)

      IF( @Relocate = 1 )
        BEGIN
            IF( ( @DataPath IS NULL )
                 OR ( @LogPath IS NULL ) )
              BEGIN
                  RAISERROR('Null values not allowed for Data and Log Path',16,1)
              END
            ELSE
              BEGIN
                  SELECT @DataPath = CASE
                                       WHEN RIGHT(@DataPath, 1) IN ( '\' ) THEN @DataPath
                                       ELSE @DataPath + '\'
                                     END

                  SELECT @LogPath = CASE
                                      WHEN RIGHT(@LogPath, 1) IN ( '\' ) THEN @LogPath
                                      ELSE @LogPath + '\'
                                    END
              END
        END

      DECLARE @ddbmacmd NVARCHAR(4000);
      DECLARE @cur CURSOR;
      DECLARE @line NVARCHAR(4000);
      DECLARE @rcode BIT;
      DECLARE @dbname NVARCHAR(100);
      DECLARE @t TABLE
        (
           DBNAME NVARCHAR(100)
        )

      INSERT INTO @t
      SELECT DatabaseName -- SELECT * 
      FROM   [DBA].[backup].[Schedule]
      WHERE ( BackupMethod = @DDBoostUser
                OR DatabaseName = @SQLDatabaseName ) --OR @Force = 1 )
      ORDER  BY DatabaseName

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
                        PRINT '--------------------AWS-EC2------------------------------------------'
                    END
                  ELSE
                    BEGIN
                        PRINT '------------------------WE NEED WORK HERE---------------------------'
                    END
              END
            ELSE IF( @BackupSoftware = 'AWS-RDS' )
              BEGIN
                  IF( @DryRun = 1 )
                    BEGIN
                        PRINT 
                              'exec msdb.dbo.rds_restore_database
								@restore_db_name='''+@dbname+''',@s3_arn_to_restore_from=''arn:aws:s3:::'+@Bucket+'/'+@dbname+'_migration_full.bak'',
								@type='''+@BackupLevel+'''@with_norecovery=0'

                    END
                  ELSE
                    BEGIN
                        PRINT @BackupSoftware
                              + ' Can do not do this here... permissions prohibit it!
							  HERE IS THE CODE:
							  '
                        PRINT 
                              'exec msdb.dbo.rds_restore_database
								@restore_db_name='''+@dbname+''',@s3_arn_to_restore_from=''arn:aws:s3:::'+@Bucket+'/'+@dbname+'_migration_full.bak'',
								@type='''+@BackupLevel+'''@with_norecovery=0'
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
  END; 
