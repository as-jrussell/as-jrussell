USE [DBA]
GO
/****** Object:  StoredProcedure [backup].[RestoreDatabase]    Script Date: 3/15/2024 10:08:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [backup].[RestoreDatabase]
	@ClientHost					varchar (50)	= NULL,					-- -c Client/Host SQL Server Backup Source
	@RecoveryState				varchar (10)	= "normal",				-- -S Recovery State <normal,norecover,standby>
	@BackupSoftware				varchar	(100)	= NULL,
	@DDHost						varchar (50)	= NULL,					-- -a NSR_DFA_SI_DD_HOST - Data Domain Host Name
	@DDBoostUser				varchar (50)	= NULL,					-- -a NSR_DFA_SI_DD_USER - DD Boost User
	@DDStorageUnit				varchar (50)	= NULL,					-- -a NSR_DFA_SI_DEVICE_PATH - Storage Unit Name
	@SQLDatabaseName			varchar (100),							-- SQL Database Name
	@SQLInstanceName 			varchar (50)  	= NULL,				    -- SQL INstance Name - Defaults to MSSQL
	@DDLockBoxPath				varchar (100)	= NULL,					--
	@StandbyFile				varchar (255)	= NULL,					-- File path of standby file for standby recovery option
	@BackupTimeStamp 			varchar (50)  	= NULL,					-- -t Last Backup Time Stamp
	@Overwrite					bit				= 0,					-- -f Overwrites the existing database with the current database that you restore,if the names of both the databases are same.
	@CCheck						bit				= NULL,					-- -j Performs a database consistency check between the SQL Server backed up data and the SQL Server restored data.
	@CreateChecksum				bit				= NULL,					-- -k Performs checksum before restoring the data from the device.
	@ContinueOnChecksumErr		bit				= NULL,					-- -u Performs checksum and continues the operation even in case of errors.
	@Relocate					bit				= NULL,					-- -C Relocates the database files (.mdf and .ldf) to a different folder.
	@DataPath					varchar(255)	= NULL,					-- Path to relocate SQL .mdf data file 'Contacts'='C:\AW_DB\Contacts.mdf'
	@LogPath					varchar(255)	= NULL,					-- Path to relocate SQL .ldf log file  'Contacts_log'='C:\AW_DB\Contacts_log.ldf'"
	@Quiet						bit				= NULL,					-- -q Displays ddbmsqlrc messages in the quiet mode, that is, the option provides minimal information about the progress of the restore operation including error messages.
	@DebugLevel					char(1)			= NULL,					-- -D Generates detailed logs that you can use to troubleshoot the backup issues. <0-9>
	@BackupLevel				varchar (50)	= 'FULL',
	-- The following options of the ddbmsqlrc.exe command have not been implemented
	--@BackupLevel				varchar (10)	= NULL					-- THIS MAY BE A TYPO IN THE MANUAL -- GUI DOES NOT SEEM CREATE THIS OPTION --if @BackupLevel is not null Set @ddbmacmd = @ddbmacmd + ' -l "' + @BackupLevel + '"'  INVALID RESTORE OPTION ??
	--@TailLog					bit				= NULL,					-- -H Performs a tail-log backup of the database and leave it in the restoring state. IN GUI BUT NOT DOCUMENTED FOR COMMAND LINE
	--@VirtualServer			varchar (50)  	= NULL					-- -A Note: This appears to be intended for use with virtual cluster nodes, but is not documented well in the administration guide
	@DryRun						bit				= 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- EXEC [backup].[RestoreDatabase] @SQLDatabaseName = 'dba'
	-- EXEC [backup].[RestoreDatabase] @SQLDatabaseName = 'USER_Databases', @relocate = 1, @DataPath = 'F:\SQLData\I01', @LogPath = 'G:\SQLLogs\I01'
	-- EXEC [backup].[RestoreDatabase] @SQLDatabaseName = 'System_Databases'

	-- Set Default values 
	IF( @DDHost is null ) SELECT @DDHost = UPPER(info.GetDatabaseConfig('DataDomain','Host', ''));
	IF( @DDBoostUser is null ) SELECT @DDBoostUser = info.GetDatabaseConfig('DataDomain','User', '');
	--IF( @BackupSetName is null ) SELECT @BackupSetName = UPPER(info.GetDatabaseConfig('DataDomain','SetName', ''));
	IF( @DDStorageUnit is null ) SELECT @DDStorageUnit = UPPER(info.GetDatabaseConfig('DataDomain','DevicePath', ''));
	IF( @DDLockBoxPath is null ) SELECT @DDLockBoxPath = info.GetDatabaseConfig('DataDomain','LockBoxPath', '');
	--IF( @BackupSetDescription is null ) SET @BackupSetDescription = @BackupLevel +' Backup'
	IF( @ClientHost is null ) SET @ClientHost = ( SELECT UPPER( convert(varchar(100), SERVERPROPERTY('MachineName')) ) )
	IF( @SQLInstanceName is null ) SET @SQLInstanceName = (select isnull('MSSQL$'+ convert(varchar(max),serverproperty('instancename')),'MSSQL') )
	IF( @BackupSoftware is null ) SET @BackupSoftware = info.GetDatabaseConfig('Backup','Software', '');

	-- Check required parameters
	if @ClientHost is null raiserror('Null values not allowed for ClientHost', 16, 1)
	if @RecoveryState is null raiserror('Null values not allowed for RestoreType', 16, 1)
	if @DDHost is null raiserror('Null values not allowed for DDHost', 16, 1)
	if @DDBoostUser is null raiserror('Null values not allowed for DDBoostUser', 16, 1)
	if @DDStorageUnit is null raiserror('Null values not allowed for DDStorageUnit', 16, 1)
	if @SQLInstanceName is null raiserror('Null values not allowed for SQLInstanceName', 16, 1)
	if @SQLDatabaseName is null raiserror('Null values not allowed for SQLDatabaseName', 16, 1)

	IF( @Relocate = 1 )
		BEGIN
			IF( (@DataPath IS null) OR (@LogPath IS null) )
				BEGIN
					raiserror('Null values not allowed for Data and Log Path', 16, 1)
				END
			ELSE
				BEGIN
					SELECT @DataPath = CASE WHEN Right(@DataPath, 1) IN ('\') THEN @DataPath ELSE @DataPath +'\' END
					SELECT @LogPath  = CASE WHEN Right(@LogPath, 1)  IN ('\') THEN @LogPath  ELSE @LogPath +'\'  END
				END
		END
	
	declare @ddbmacmd nvarchar(4000);
	declare @cur cursor;
	declare @line nvarchar(4000);
	declare @rcode bit;
	DECLARE @dbname nvarchar(100);
	DECLARE @t TABLE (DBNAME NVARCHAR(100))
	
	INSERT INTO @t
	SELECT DatabaseName -- SELECT * 
	FROM [DBA].[backup].[Schedule]
	WHERE ( DatabaseType = CASE WHEN @SQLDatabaseName= 'user_databases' THEN 'USER'
							    WHEN @SQLDatabaseName= 'system_databases' THEN 'SYSTEM'
						   END AND BackupMethod = @DDBoostUser 
			OR DatabaseName = @SQLDatabaseName ) --OR @Force = 1 )
	ORDER BY DatabaseName

	SET @cur = Cursor FOR
	SELECT DBNAME
	FROM @t
	open @cur
	fetch next FROM @cur INTO @dbname
	while @@fetch_status = 0
		BEGIN
			/* Get info on DB or return empty resultset. */
			IF( @BackupLevel = 'FULL' ) -- someday this can check for point in time
			BEGIN
				IF( @BackupSoftware = 'ddboost' ) -- someday this can check for point in time
				BEGIN
				/* This section will need to be updated for other restore types */
				SELECT @SQLDatabaseName = DatabaseName, @BackupTimeStamp = CONVERT(varchar,BackupDate,22)
				--select *
				FROM DBA.ddbma.SQLCatalog 
				WHERE databaseName = @dbname and BAckupLEvel = @BackupLevel AND
					BAckupDate = (  SELECT MAX(BackupDate) 
									FROM DBA.ddbma.SQLCatalog 
									WHERE databaseName = @dbname and BAckupLEvel = @BackupLevel)
			print '--------------------------------------------------------------'
			print 'Restoring '+ @BackupLevel +': '+ @dbname +' '+ @BackupTimeStamp
			print '--------------------------------------------------------------'

				END
				ELSE
		BEGIN
			print '--------------------------------------------------------------'
			print 'Restoring '+  @BackupLevel +': '+ @ClientHost +'\'+@dbname
			print '--------------------------------------------------------------'
			END 
			END

			IF( @Relocate = 1 )
				BEGIN
				/* This should probably be a temp table to process all files of type and concatenate them */
					SELECT @DataPath ='"''''' + Name + '''''=''' + '''' + @DataPath + RIGHT(fileName, CHARINDEX('\', REVERSE(fileName))-1) +'''''' FROM  SYSALTFILES WHERE db_name(dbid) = @dbname and groupid = 1
					SELECT @LogPath =', ''''' + Name + '''''=''' + '''' + @LogPath + RIGHT(fileName, CHARINDEX('\', REVERSE(fileName))-1) +'''''"' FROM  SYSALTFILES WHERE db_name(dbid) = @dbname and groupid = 0
				END
			-- CAll RestoreImage
			  IF( @BackupSoftware = 'ddboost' )
	                    BEGIN
						PRINT 'This tool has been retired and enjoying retirement'
						PRINT '--------------------------------------------------------------'
				END
			ELSE IF( @BackupSoftware = 'SQLNative' )
       				BEGIN
						PRINT 'We do not do this here'
						PRINT '--------------------------------------------------------------'
					END
			ELSE  IF( @BackupSoftware = 'AWS-EC2' )
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
			ELSE  IF( @BackupSoftware = 'AWS-RDS' )
                    		BEGIN
					IF( @DryRun = 1 )
					BEGIN

						PRINT 'We do not do this here'
						PRINT '--------------------------------------------------------------'
					END
					ELSE
					BEGIN
						PRINT '------------------------WE NEED WORK HERE---------------------------'
					END 
				END
			ELSE  IF( @BackupSoftware = 'MS-AZURE' )
                    		BEGIN
					IF( @DryRun = 1 )
					BEGIN
		
						PRINT 'We do not do this here'
					END
						ELSE
					BEGIN
						PRINT '------------------------WE NEED WORK HERE---------------------------'
					END 
				END
		    	ELSE
				BEGIN
				    PRINT 'Backup Software undefined'
				    raiserror('Backup Software undefined',16,1) 
				END		
			fetch next FROM @cur INTO @dbname
		end
	close @cur;
	Deallocate @cur;

END;

