USE [DBA]
GO

/****** Object:  StoredProcedure [ddbma].[BackupImage]    Script Date: 10/10/2022 3:13:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [ddbma].[BackupImage] 
	@ClientHost					varchar (50),							-- -c Client/Host SQL Server Backup Source
	@BackupLevel				varchar (10),							-- -l Backup Level <full,incr,diff>
	@BackupSetName 				varchar (100), 							-- -N Backup Set Name
	@BackupSetDescription 		varchar (255),							-- -b Backup Set Description
	@RetentionDays				int 		  	= 30,					-- -y Default to 30 days if not supplied - Generates 
	@DDHost						varchar (50),							-- -a NSR_DFA_SI_DD_HOST - Data Domain Host Name
	@DDBoostUser				varchar (50),							-- -a NSR_DFA_SI_DD_USER - DD Boost User
	@DDStorageUnit				varchar (50),							-- -a NSR_DFA_SI_DEVICE_PATH - Storage Unit Name
	@DDLockBoxPath				varchar (100),							--
	@SkipBadState				varchar (10)    = "TRUE",				--
	@SQLDatabaseName			varchar (100),							-- SQL Database Name
	@SQLInstanceName 			varchar (50)  	= "MSSQL",				-- SQL INstance Name - Defaults to MSSQL
	@NumberOfStripes			int				= NULL,					-- -S Number of Stripes
	@NoTruncate					bit				= NULL,					-- -R Uses the NO_TRUNCATE option when backing up transaction logs.
	@TruncateOnly				bit				= NULL,					-- -T Performs a TRUNCATE_ONLY transaction log backup before backing up the database. This option is valid only for full backups on SQL Server 2005.
	@NoLogTRN					bit				= NULL,					-- -G Specifies a NO_LOG transaction log backup before backing up the database. This option is valid only for full backups on SQL Server 2005.
	@TailLog					bit				= NULL,					-- -H Performs a tail-log backup of the database and leave it in the restoring state.
	@CCheck						bit				= NULL,					-- -j Performs a database consistency check before starting the backup.
	@CreateChecksum				bit				= NULL,					-- -k Performs checksum before backing up the data to the device.
	@ContinueOnChecksumErr		bit				= NULL,					-- -u Performs checksum and continues the operation even in case of errors.
	@DDFCHostName				varchar (50)	= NULL,					-- -a NSR_FC_HOSTNAME - Data Domain FC Hostname
	@Quiet						bit				= NULL,					-- -q Displays ddbmsqlsv messages in the quiet mode, that is, the option displays summary information and error messages only.
	@Verbose					bit				= NULL,					-- -v Displays ddbmsqlsv messages in the verbose mode, that is, the option provides detailed information about the progress of the backup operation.
	@DebugLevel					char(1)			= 1,					-- -D Generates detailed logs that you can use to troubleshoot the backup issues. <0-9>
	@DryRun						bit				= 1
	--@VirtualServer			varchar (50)  	= NULL					-- -A Note: This appears to be intended for use with virtual cluster nodes, but is not documented well in the administration guide - Do not have environment to test this functionality, so have not implemented
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Check required parameters
	if @ClientHost is null raiserror('Null values not allowed for ClientHost', 16, 1)
	if @BackupLevel is null raiserror('Null values not allowed for BackupLevel', 16, 1)
	if @BackupSetName is null raiserror('Null values not allowed for BackupSetName', 16, 1)
	if @BackupSetDescription is null raiserror('Null values not allowed for BackupSetDescription', 16, 1)
	if @DDHost is null raiserror('Null values not allowed for DDHost', 16, 1)
	if @DDBoostUser is null raiserror('Null values not allowed for DDBoostUser', 16, 1)
	if @DDStorageUnit is null raiserror('Null values not allowed for DDStorageUnit', 16, 1)
	if @SQLInstanceName is null raiserror('Null values not allowed for SQLInstanceName', 16, 1)
	if @SQLDatabaseName is null raiserror('Null values not allowed for SQLDatabaseName', 16, 1)
	
	declare @ddbmacmd nvarchar(4000);
	declare @EXPDate varchar(25) = Convert(varchar(20),dateadd(day,@RetentionDays,getdate()), 101) +' '+ Convert(varchar(20),dateadd(day,@RetentionDays,getdate()), 108);
	declare @cur cursor;
	declare @line nvarchar(4000);
	declare @rcode bit;
	declare @BackupTime varchar(25)
	DECLARE @BackupStatus int = 0
	
	-- Set return code to no errors
	SET @rcode = 0;
	
	-- Base DD Boost Command
	SET @ddbmacmd = 'ddbmsqlsv.exe -c ' + @ClientHost + 
	' -l "' + @BackupLevel + 
	'" -N "' + @BackupSetName + 
	'" -b "' + @BackupSetDescription +
	'" -y "' + @EXPDate + '"'
	
	-- Optional DD Boost command switches
	if @DebugLevel is not null Set @ddbmacmd = @ddbmacmd + ' -D ' + @DebugLevel
	if @NumberOfStripes is not null Set @ddbmacmd = @ddbmacmd + ' -S ' + convert(varchar(10), @NumberOfStripes )
	if @NoLogTRN is not null 
	Begin 
		if @NoLogTRN = 1 Set @ddbmacmd = @ddbmacmd + ' -G '
	End
	if @CCheck is not null 
	Begin 
		if @CCheck = 1 Set @ddbmacmd = @ddbmacmd + ' -j '
	End
	if @CreateChecksum is not null 
	Begin 
		if @CreateChecksum = 1 Set @ddbmacmd = @ddbmacmd + ' -k '
		if @ContinueOnChecksumErr = 1 Set @ddbmacmd = @ddbmacmd + ' -u '
	End
	if @TailLog is not null 
	Begin 
		if @TailLog = 1 Set @ddbmacmd = @ddbmacmd + ' -H '
	End
	if @NoTruncate is not null 
	Begin 
		if @NoTruncate = 1 Set @ddbmacmd = @ddbmacmd + ' -R '
	End
	if @TruncateOnly is not null 
	Begin 
		if @TruncateOnly = 1 Set @ddbmacmd = @ddbmacmd + ' -T '
	End
	if @Quiet is not null 
	Begin 
		if @Quiet = 1 Set @ddbmacmd = @ddbmacmd + ' -q '
	End
	if @Verbose is not null 
	Begin 
		if @Verbose = 1 Set @ddbmacmd = @ddbmacmd + ' -v '
	End
	
	-- Standard DD Boost options
	Set @ddbmacmd = @ddbmacmd + ' -a "NSR_DFA_SI=TRUE"' +
	' -a "NSR_DFA_SI_USE_DD=TRUE"' +
	' -a "NSR_DFA_SI_DD_HOST=' + @DDHost + '"' +
	' -a "NSR_DFA_SI_DD_USER=' + @DDBoostUser + '"' +
	' -a "NSR_DFA_SI_DEVICE_PATH=' + @DDStorageUnit + '"' + 
	' -a "NSR_DFA_SI_DD_LOCKBOX_PATH=' + @DDLockBoxPath + '"' + 
	' -a "NSR_SKIP_NON_BACKUPABLE_STATE_DB='+ @SkipBadState + '"' + 
	' "' + @SQLInstanceName + ':' + CASE WHEN CharIndex('.', @SQLDatabaseName) >0 THEN ( SELECT REPLACE(@SQLDatabaseName,'.','\.') )
										 ELSE @SQLDatabaseName 
									END + '"'
	
	-- Optional DD Boost commands
	if @DDFCHostName is not null Set @ddbmacmd = @ddbmacmd + ' -a "NSR_FC_HOSTNAME=' + @DDFCHostName + '"'
	
	IF( @DryRun = 0 )
		BEGIN
			-- Setup temprorary in memory table to loop through DDB executable output
			DECLARE @t TABLE (LINE NVARCHAR(4000))
			INSERT INTO @t
			exec xp_cmdshell @ddbmacmd --DBA DDBoost take backup

			SET @cur = Cursor FOR
			SELECT LINE FROM @t
	
			open @cur
			fetch next FROM @cur INTO @line
	
			while @@fetch_status = 0
			begin
		
				-- Check if bachup started and record backup time
				IF @line LIKE 'Stop Time: %'
				BEGIN
					Set @BackupTime = SubString(REPLACE(@Line ,'Stop Time: ','' ),5, LEN(REPLACE(@Line ,'Stop Time: ','' ))-4 ) 
				END
		
				-- Check if backup was successful
				IF @line = 'Backup of '+ @SQLDatabaseName +' succeeded.'
				BEGIN
					Set @BackupStatus = 1
				END

				-- Check for error messages
				IF( (@line LIKE '%error%failed%') OR (@line like '%not recognized as an internal or external command%') OR (@line like '%Failed to retrieve DD password%') OR (@line like '%Lockbox does not exist in the directory%') )
				BEGIN
					SET @rcode = 1
				END
				-- Print output and process next line
				print @line
				fetch next FROM @cur INTO @line
			end

			close @cur;
			Deallocate @cur;

			IF( @BackupStatus = 1 )
			BEGIN
				PRINT 'Insert record'
				-- Insert backup metadata into SQL backup catalog table
				Insert Into DBA.DDBMA.SQLCatalog (ClientHostName,
												BackupLevel,
												BackupSetName,
												BackupSetDescription,
												BackupDate,
												ExpDate,
												DDHost,
												DDStorageUnit,
												DatabaseName,
												SQLInstance)
						Values(@ClientHost,
								@BackupLevel,
								@BackupSetName, 
								@BackupSetDescription,
								(Select convert(datetime,@BackupTime)),
								(Select convert(datetime,@ExpDate)),
								@DDHost,
								@DDStorageUnit,
								@SQLDatabaseName,	
								@SQLInstanceName)
			END
			-- Report if errors were returned
			IF @rcode = 1
				raiserror('An error occured with the backup',16,1)
		END
	ELSE
		BEGIN
			PRINT @ddbmacmd
		END
		
END
GO

