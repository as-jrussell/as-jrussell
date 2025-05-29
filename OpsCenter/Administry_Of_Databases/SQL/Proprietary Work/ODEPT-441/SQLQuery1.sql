 --EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'dba', @DryRun= 1 ,  @BackupSoftware ='AWS-EC2'


-- EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'dba', @RestoreDatabaseName ='NotDBA' ,@relocate = 1, @DataPath = 'F:\SQLData\I01', @LogPath = 'G:\SQLLogs\I01', @dryrun = 1

 --EXEC [backup].[RestoreDatabase] @SQLDatabaseName = 'dba', @Dryrun= 1,   @BackupSoftware = 'Clumio' 

 /*
exec msdb.dbo.rds_restore_database
@restore_db_name='WinSvcLog',
@s3_arn_to_restore_from='arn:aws:s3:::alss3sqlstst01/winsvclog_migration_full.bak',
@type='FULL',
@with_norecovery=0
*/


EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'Test' , @DryRun =0



EXEC DBA.[backup].[RestoreDatabase] @SQLDatabaseName = 'Test', @RestoreDatabaseName ='NotDBA'  , @DryRun =0


