


select CONCAT('RESTORE DATABASE ',name,' FROM DISK = N''\\Dba-sqlqa-01\Restores\jrussell\',name,'.Bak''

WITH

MOVE N''',name,''' TO N''E:\SQLDATA\',name,'.mdf'',

MOVE N''',name,'_log'' TO N''F:\SQLLOGS\',name,'_log.ldf'',

NORECOVERY, NOUNLOAD, STATS = 5')
--select *
from sys.databases 
where name = 'HDTSTORAGE'




select CONCAT('RESTORE LOG ',name,' FROM DISK = N''\\Dba-sqlqa-01\Restores\jrussell\',name,'.LOG''
WITH NORECOVERY, STATS = 5')
--select *
from sys.databases 
where name = 'HDTSTORAGE'



DECLARE @Database nvarchar (100) = 'AppLog'
DECLARE @Path nvarchar(255) = 'arn:aws:s3:::alss3sqlstst01/applog_migration_full.bak'
DECLARE @type nvarchar(10) = 'FULL'

print ('exec msdb.dbo.rds_restore_database
@restore_db_name='''+@database+ ''',
@s3_arn_to_restore_from='''+@path+ ''',
@type='''+@type+''',
@with_norecovery=0
')

