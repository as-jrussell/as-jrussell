USE [master]

IF EXISTS(select 1 from sys.databases where name = 'UniTracArchive') 

BEGIN
    ALTER DATABASE [UniTracArchive] MODIFY FILE ( NAME = N'UniTracArchive', MAXSIZE =9126GB)
END