USE [master]

IF EXISTS(select 1
from sys.databases
where name = 'LIMC')
 BEGIN
    ALTER DATABASE [LIMC] MODIFY FILE ( NAME = N'LIMC', MAXSIZE =101GB)
END