select CONCAT('BACKUP DATABASE [',  name ,'] TO
DISK = ''\\Dba-sqlqa-01\Restores\jrussell\' ,name, '.Bak''
WITH INIT , NOUNLOAD , NAME = ''Backup'', NOSKIP , STATS = 10, COMPRESSION, NOFORMAT')
--select CONCAT('''',name,''''), database_id, *  
from sys.databases 
where database_id > '5'

select CONCAT( 'BACKUP LOG [',  name ,'] TO
DISK = ''\\Dba-sqlqa-01\Restores\jrussell\' ,name, '.LOG''')
from sys.databases 
where database_id between '7' and '15'




DECLARE @path nvarchar(50) = '\\dbbktstawstgy01.as.local\alss3sqlstst01\'

select CONCAT( 'BACKUP DATABASE [',  name ,'] TO
DISK = '''+@path +'' ,name, '_migration_full.BAK'' WITH COPY_ONLY, INIT, NAME = N''',  name ,' Migration Full DB Backup''
')
from sys.databases 
where database_id > '5' and name like '%_log'

