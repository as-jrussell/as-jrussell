USE [master]
GO
ALTER DATABASE [ReaOnlyDB] SET  ONLINE
GO




---Location of files 
select d.name [database_name], md.* 
from sys.databases d 
join sys.master_files mf on d.database_id = mf.database_id and mf.file_id = 2
join sys.master_files md on d.database_id = md.database_id and md.file_id = 1
WHERE mf.database_id >= 5

---Non-System Database set to offline
select CONCAT('ALTER DATABASE [',md.name, '] SET  OFFLINE')
from sys.databases d 
join sys.master_files mf on d.database_id = mf.database_id and mf.file_id = 2
join sys.master_files md on d.database_id = md.database_id and md.file_id = 1
WHERE mf.database_id >= 5



---Non-System Database set to moving files both data and logs
select CONCAT('ALTER DATABASE [',md.name, ']
MODIFY FILE(NAME=[',mf.name,'], FILENAME=''C:\Downloads\SQLLOGS\',mf.name,'.ldf'')
ALTER DATABASE [',md.name, ']
MODIFY FILE(NAME=[',md.name,'], FILENAME=''C:\Downloads\SQLDATA\',md.name,'.mdf'')')
from sys.databases d 
join sys.master_files mf on d.database_id = mf.database_id and mf.file_id = 2
join sys.master_files md on d.database_id = md.database_id and md.file_id = 1
WHERE mf.database_id >= 5



---Non-System Database set to moving files logs
select CONCAT('ALTER DATABASE [',md.name, ']
MODIFY FILE(NAME=[',mf.name,'], FILENAME=''C:\Downloads\SQLLOGS\',mf.name,'.ldf'')')
from sys.databases d 
join sys.master_files mf on d.database_id = mf.database_id and mf.file_id = 2
join sys.master_files md on d.database_id = md.database_id and md.file_id = 1
WHERE mf.database_id >= 5



---Non-System Database set to online
select CONCAT('ALTER DATABASE [',md.name, '] SET  ONLINE')
from sys.databases d 
join sys.master_files mf on d.database_id = mf.database_id and mf.file_id = 2
join sys.master_files md on d.database_id = md.database_id and md.file_id = 1
WHERE mf.database_id >= 5


