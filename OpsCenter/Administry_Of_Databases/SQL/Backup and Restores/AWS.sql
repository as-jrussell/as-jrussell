--1) Log Databases - CP-SQLQA-02 Test Backup Queries - Execute on CP-SQLQA-02

/*AppLog backup to dev storage gateway*/
BACKUP DATABASE [AppLog] TO DISK = N'\\dbbktstawstgy01.as.local\alss3sqlstst01\applog_migration_full.bak'
WITH COPY_ONLY, INIT, NAME = N'AppLog Migration Full DB Backup',
COMPRESSION, FORMAT, STATS = 5
GO




BACKUP DATABASE [IVOS] TO  DISK = '\\dbbktstawstgy01.as.local\alss3sqlstst01\IVOS_migration_full.BAK' WITH COPY_ONLY, INIT, NAME = N'IVOS Migration Full DB Backup'  ,
COMPRESSION, FORMAT, STATS = 5




/*SysLog backup to dev storage gateway*/
BACKUP DATABASE [SysLog] TO DISK = N'\\dbbktstawstgy01.as.local\alss3sqlstst01\syslog_migration_full.bak'
WITH COPY_ONLY, INIT, NAME = N'SysLog Migration Full DB Backup',
COMPRESSION, FORMAT, STATS = 5
GO


/*WinSvcLog backup to dev storage gateway*/
BACKUP DATABASE [WinSvcLog] TO DISK = N'\\dbbktstawstgy01.as.local\alss3sqlstst01\winsvclog_migration_full.bak'
WITH COPY_ONLY, INIT, NAME = N'WinSvcLog Migration Full DB Backup',
COMPRESSION, FORMAT, STATS = 5
GO






--2) Execute restores for each backup on new aws server

exec msdb.dbo.rds_restore_database
@restore_db_name='IVOS',
@s3_arn_to_restore_from='arn:aws:s3:::alss3sqlstst01/IVOS_full.bak',
@type='FULL',
@with_norecovery=0


exec msdb.dbo.rds_restore_database
@restore_db_name='SysLog',
@s3_arn_to_restore_from='arn:aws:s3:::alss3sqlstst01/syslog_migration_full.bak',
@type='FULL',
@with_norecovery=0

exec msdb.dbo.rds_restore_database
@restore_db_name='WinSvcLog',
@s3_arn_to_restore_from='arn:aws:s3:::alss3sqlstst01/winsvclog_migration_full.bak',
@type='FULL',
@with_norecovery=0






exec msdb.dbo.rds_task_status
--EXECUTE msdb.dbo.rds_drop_database  N'OCR_POC'



exec msdb.dbo.rds_backup_database
        @source_db_name='IVOS',
        @s3_arn_to_backup_to='arn:aws:s3:::alss3sqlstst01/IVOS_migration_full.bak',
        @overwrite_S3_backup_file=1,
        @type='FULL';


		exec msdb.dbo.rds_task_status




		arn:aws:s3:::alss3sqlstst01/IVOS_migration_full.bak