USE [msdb]
GO

/****** Object:  Job [DCOM-BackupMaintenance_LF-SQLPRD-01]    Script Date: 10/27/2021 2:29:55 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 10/27/2021 2:29:56 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DCOM-BackupMaintenance_LF-SQLPRD-01', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge from creation]    Script Date: 10/27/2021 2:29:56 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge from creation', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/* Marks backups for garbage collector since SQL install date */
        DECLARE @xpCMD              	NVARCHAR(500)  	= ''''
        DECLARE @StartDate          	datetime        	= ''1/1/2020''
        DECLARE @ClientHost		varchar (50)	= NULL
        DECLARE @ClusterHost       	varchar (50)	= ''LF-SQLPRD-01.as.local''
        DECLARE @SQLInstanceName	varchar (50)  	= NULL
        DECLARE @Retention          	INT            	 -- Set using DatabaseConfig value
        DECLARE @DryRun            	INT             	= 0

        IF EXISTS( SELECT * FROM MASTER..SYSOBJECTS where name = ''dm_hadr_cluster'')
            BEGIN
                IF EXISTS (select * from master.sys.dm_hadr_cluster) 
                    BEGIN
                        SET @ClientHost = ( (SELECT UPPER(cluster_name) from master.sys.dm_hadr_cluster)+''.''+(SELECT DomainName FROM DBA.info.Instance) )
                        SET @ClusterHost = ( SELECT UPPER( convert(varchar(100), SERVERPROPERTY(''MachineName'')) )+''.''+(SELECT DomainName FROM DBA.info.Instance) )
                    END
                ELSE
                    BEGIN
                        SET @ClientHost = ( SELECT UPPER( convert(varchar(100), SERVERPROPERTY(''MachineName'')) )+''.''+(SELECT DomainName FROM DBA.info.Instance) )
                    END
            END
        ELSE
            BEGIN
                SET @ClientHost = ( SELECT UPPER( convert(varchar(100), SERVERPROPERTY(''MachineName'')) )+''.''+(SELECT DomainName FROM DBA.info.Instance) )
            END

        IF( @SQLInstanceName is null ) SET @SQLInstanceName = (select isnull(''MSSQL$''+ convert(varchar(max),serverproperty(''instancename'')),''MSSQL'') )
        --IF( @SQLInstanceName  != ''MSSQL'' ) SET @ClientHost = @ClientHost +''\''+ (REPLACE(@SQLInstanceName,''MSSQL$'',''''))

        If @StartDate is NULL 
        BEGIN
            IF EXISTS ( SELECT ConfValue FROM DBA.info.SystemConfig WHERE ConfKey = ''VUTPRODPurgeStartDate'' )
                BEGIN
                    SELECT @StartDate = ConfValue -- select *
                    FROM DBA.info.SystemConfig 
                    WHERE ConfKey = ''DDBoostPurgeStartDate''
                END
            ELSE
                BEGIN
                    SELECT @StartDate = create_date
                    FROM sys.server_principals
                    WHERE sid = 0x010100000000000512000000

                    EXEC [DBA].[info].[SetSystemConfig] ''VUTPRODPurgeStartDate'', @StartDate
                END
        END

        SET @Retention = ( SELECT [info].[GetDatabaseConfig] (''DataDomain'', ''Retention'' , 14) )

        WHILE( (SELECT DATEDIFF(dd,@StartDate, GetDate() - @Retention )) > 0 )
        BEGIN 
            PRINT convert(varchar(11),@StartDAte) 

            SET @xpCMD = ''ECHO Y | ddbmexptool.exe -k -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=ON-DD9300-01" -a "CLIENT=''+ @ClientHost +''" -a MSSQL -e "''+ convert(varchar(11),@StartDate) +''"''

            PRINT @xpCMD
            IF(@DryRun = 0 )
            BEGIN
                EXEC xp_cmdShell @xpCMD
            END

            IF( @ClusterHost IS NOT NULL)
            BEGIN
                SET @xpCMD = ''ECHO Y | ddbmexptool.exe -k -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=ON-DD9300-01" -a "CLIENT=''+ @ClusterHost +''" -a MSSQL -e "''+ convert(varchar(11),@StartDate) +''"''

                PRINT @xpCMD
                EXEC xp_cmdShell @xpCMD
            END 

            SET @StartDate = @StartDate + 1
            EXEC [DBA].[info].[SetSystemConfig] ''VUTPRODPurgeStartDate'', @StartDate
        END
        
        /*  Drop Purge Date */
        -- DELETE FROM DBA.info.SystemConfig WHERE ConfKey = ''DDBoostPurgeStartDate''', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


