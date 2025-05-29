ALTER DATABASE tempdb
                ADD FILE (
                               FILENAME = 'G:\TEMPDB\tempdb2.ndf',
                               NAME = tempdev2,
                               SIZE = 10240MB,
                               FILEGROWTH = 10%)


USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 1GB )
GO

ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 10240MB )
GO