USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 1GB )
GO




ALTER DATABASE tempdb
                ADD FILE (
                               FILENAME = 'G:\tempdb8.ndf',
                               NAME = tempdev8,
                               SIZE = 8GB,
                               FILEGROWTH = 10%)
ALTER DATABASE tempdb
                ADD FILE (
                               FILENAME = 'G:\tempdb7.ndf',
                               NAME = tempdev7,
                               SIZE = 8GB,
                               FILEGROWTH =10%)
ALTER DATABASE tempdb
                ADD FILE (
                               FILENAME = 'G:\tempdb6.ndf',
                               NAME = tempdev6,
                               SIZE = 8GB,
                               FILEGROWTH = 10%)
ALTER DATABASE tempdb
                ADD FILE (
                               FILENAME = 'G:\tempdb5.ndf',
                               NAME = tempdev5,
                               SIZE = 8GB,
                               FILEGROWTH =10%)